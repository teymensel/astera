import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  bool _isInitialized = false;
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  bool _anniversaryRemindersEnabled = true;
  bool _fightRemindersEnabled = true;
  bool _petCareRemindersEnabled = true;
  bool _musicNotificationsEnabled = true;
  bool _dailyRemindersEnabled = false;
  bool _weeklyReportsEnabled = true;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get emailNotificationsEnabled => _emailNotificationsEnabled;
  bool get anniversaryRemindersEnabled => _anniversaryRemindersEnabled;
  bool get fightRemindersEnabled => _fightRemindersEnabled;
  bool get petCareRemindersEnabled => _petCareRemindersEnabled;
  bool get musicNotificationsEnabled => _musicNotificationsEnabled;
  bool get dailyRemindersEnabled => _dailyRemindersEnabled;
  bool get weeklyReportsEnabled => _weeklyReportsEnabled;

  NotificationProvider() {
    _loadSettings();
  }

  // Notification service'i başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _notificationService.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Failed to initialize notification service: $e');
    }
  }

  // Ayarları yükle
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _pushNotificationsEnabled = prefs.getBool('push_notifications_enabled') ?? true;
    _emailNotificationsEnabled = prefs.getBool('email_notifications_enabled') ?? false;
    _anniversaryRemindersEnabled = prefs.getBool('anniversary_reminders_enabled') ?? true;
    _fightRemindersEnabled = prefs.getBool('fight_reminders_enabled') ?? true;
    _petCareRemindersEnabled = prefs.getBool('pet_care_reminders_enabled') ?? true;
    _musicNotificationsEnabled = prefs.getBool('music_notifications_enabled') ?? true;
    _dailyRemindersEnabled = prefs.getBool('daily_reminders_enabled') ?? false;
    _weeklyReportsEnabled = prefs.getBool('weekly_reports_enabled') ?? true;
    
    notifyListeners();
  }

  // Ayarları kaydet
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('push_notifications_enabled', _pushNotificationsEnabled);
    await prefs.setBool('email_notifications_enabled', _emailNotificationsEnabled);
    await prefs.setBool('anniversary_reminders_enabled', _anniversaryRemindersEnabled);
    await prefs.setBool('fight_reminders_enabled', _fightRemindersEnabled);
    await prefs.setBool('pet_care_reminders_enabled', _petCareRemindersEnabled);
    await prefs.setBool('music_notifications_enabled', _musicNotificationsEnabled);
    await prefs.setBool('daily_reminders_enabled', _dailyRemindersEnabled);
    await prefs.setBool('weekly_reports_enabled', _weeklyReportsEnabled);
  }

  // Push notification'ları aç/kapat
  Future<void> setPushNotificationsEnabled(bool enabled) async {
    _pushNotificationsEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Email notification'ları aç/kapat
  Future<void> setEmailNotificationsEnabled(bool enabled) async {
    _emailNotificationsEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Yıldönümü hatırlatmalarını aç/kapat
  Future<void> setAnniversaryRemindersEnabled(bool enabled) async {
    _anniversaryRemindersEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Kavga hatırlatmalarını aç/kapat
  Future<void> setFightRemindersEnabled(bool enabled) async {
    _fightRemindersEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Pet bakım hatırlatmalarını aç/kapat
  Future<void> setPetCareRemindersEnabled(bool enabled) async {
    _petCareRemindersEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Müzik notification'larını aç/kapat
  Future<void> setMusicNotificationsEnabled(bool enabled) async {
    _musicNotificationsEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Günlük hatırlatmaları aç/kapat
  Future<void> setDailyRemindersEnabled(bool enabled) async {
    _dailyRemindersEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Haftalık raporları aç/kapat
  Future<void> setWeeklyReportsEnabled(bool enabled) async {
    _weeklyReportsEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Notification gönder
  Future<void> sendNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    if (!_pushNotificationsEnabled) return;

    try {
      await _notificationService.showLocalNotification(
        id: id ?? DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body,
        payload: payload,
      );
    } catch (e) {
      print('Failed to send notification: $e');
    }
  }

  // Yıldönümü hatırlatması gönder
  Future<void> sendAnniversaryReminder({
    required String title,
    required String body,
  }) async {
    if (!_anniversaryRemindersEnabled) return;

    await sendNotification(
      title: title,
      body: body,
      payload: 'anniversary',
    );
  }

  // Kavga hatırlatması gönder
  Future<void> sendFightReminder({
    required String title,
    required String body,
  }) async {
    if (!_fightRemindersEnabled) return;

    await sendNotification(
      title: title,
      body: body,
      payload: 'fight',
    );
  }

  // Pet bakım hatırlatması gönder
  Future<void> sendPetCareReminder({
    required String title,
    required String body,
  }) async {
    if (!_petCareRemindersEnabled) return;

    await sendNotification(
      title: title,
      body: body,
      payload: 'pet_care',
    );
  }

  // Müzik notification'ı gönder
  Future<void> sendMusicNotification({
    required String title,
    required String body,
  }) async {
    if (!_musicNotificationsEnabled) return;

    await sendNotification(
      title: title,
      body: body,
      payload: 'music',
    );
  }

  // Günlük hatırlatma gönder
  Future<void> sendDailyReminder({
    required String title,
    required String body,
  }) async {
    if (!_dailyRemindersEnabled) return;

    await sendNotification(
      title: title,
      body: body,
      payload: 'daily',
    );
  }

  // Haftalık rapor gönder
  Future<void> sendWeeklyReport({
    required String title,
    required String body,
  }) async {
    if (!_weeklyReportsEnabled) return;

    await sendNotification(
      title: title,
      body: body,
      payload: 'weekly_report',
    );
  }

  // Scheduled notification gönder
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_pushNotificationsEnabled) return;

    try {
      await _notificationService.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: payload,
      );
    } catch (e) {
      print('Failed to schedule notification: $e');
    }
  }

  // Notification'ları temizle
  Future<void> clearAllNotifications() async {
    await _notificationService.clearAllNotifications();
  }

  // Notification izinlerini kontrol et
  Future<bool> areNotificationsEnabled() async {
    return await _notificationService.areNotificationsEnabled();
  }

  // Notification ayarlarını aç
  Future<void> openNotificationSettings() async {
    await _notificationService.openNotificationSettings();
  }

  // FCM token'ı al
  String? get fcmToken => _notificationService.fcmToken;
}
