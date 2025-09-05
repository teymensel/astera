import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _fcmToken;

  // Getters
  bool get isInitialized => _isInitialized;
  String? get fcmToken => _fcmToken;

  // Notification service'i başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // İzinleri kontrol et ve iste
      await _requestPermissions();

      // Firebase Messaging'i başlat
      await _initializeFirebaseMessaging();

      // Local notifications'ı başlat
      await _initializeLocalNotifications();

      // FCM token'ı al
      await _getFCMToken();

      _isInitialized = true;
    } catch (e) {
      print('Notification service initialization failed: $e');
    }
  }

  // İzinleri iste
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ için notification izni
      final status = await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Notification permission denied');
      }
    }

    if (Platform.isIOS) {
      // iOS için notification izni
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        throw Exception('Notification permission denied');
      }
    }
  }

  // Firebase Messaging'i başlat
  Future<void> _initializeFirebaseMessaging() async {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // App açıldığında gelen message handler
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // App kapalıyken gelen message handler
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  // Local notifications'ı başlat
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android için notification channel oluştur
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  // FCM token'ı al
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      print('FCM Token: $_fcmToken');
      
      // Token'ı kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', _fcmToken ?? '');
    } catch (e) {
      print('Failed to get FCM token: $e');
    }
  }

  // Android notification channel'ları oluştur
  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
      'astera_general',
      'Astera Genel',
      description: 'Genel bildirimler',
      importance: Importance.high,
    );

    const AndroidNotificationChannel relationshipChannel = AndroidNotificationChannel(
      'astera_relationship',
      'İlişki Bildirimleri',
      description: 'İlişki ile ilgili bildirimler',
      importance: Importance.high,
    );

    const AndroidNotificationChannel petChannel = AndroidNotificationChannel(
      'astera_pet',
      'Pet Bildirimleri',
      description: 'Sanal pet ile ilgili bildirimler',
      importance: Importance.medium,
    );

    const AndroidNotificationChannel musicChannel = AndroidNotificationChannel(
      'astera_music',
      'Müzik Bildirimleri',
      description: 'Müzik ile ilgili bildirimler',
      importance: Importance.low,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(relationshipChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(petChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(musicChannel);
  }

  // Foreground message handler
  void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.messageId}');
    _showLocalNotification(message);
  }

  // Message opened app handler
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.messageId}');
    // Burada navigation logic'i eklenebilir
  }

  // Local notification göster
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'astera_general',
      'Astera Genel',
      channelDescription: 'Genel bildirimler',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
    );
  }

  // Notification tapped handler
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Burada navigation logic'i eklenebilir
  }

  // Local notification gönder
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'astera_general',
    String channelName = 'Astera Genel',
    String channelDescription = 'Genel bildirimler',
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'astera_general',
      'Astera Genel',
      channelDescription: 'Genel bildirimler',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Scheduled notification gönder
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'astera_general',
      'Astera Genel',
      channelDescription: 'Genel bildirimler',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Notification'ları temizle
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Belirli notification'ı iptal et
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Notification izinlerini kontrol et
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return status == PermissionStatus.granted;
    } else if (Platform.isIOS) {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  // Notification ayarlarını aç
  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }
}

// Background message handler (top-level function olmalı)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // Burada background'da yapılacak işlemler
}
