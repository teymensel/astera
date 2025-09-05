import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/health_connect_service.dart';

class HealthProvider extends ChangeNotifier {
  final HealthConnectService _healthService = HealthConnectService();
  
  bool _isInitialized = false;
  bool _hasPermissions = false;
  bool _isLoading = false;
  
  // Günlük veriler
  int _todaySteps = 0;
  double _todayHeartRate = 0.0;
  double _todayCalories = 0.0;
  double _todayDistance = 0.0;
  Map<String, dynamic>? _todaySleep;
  
  // Haftalık veriler
  List<Map<String, dynamic>> _weeklyData = [];
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get hasPermissions => _hasPermissions;
  bool get isLoading => _isLoading;
  
  int get todaySteps => _todaySteps;
  double get todayHeartRate => _todayHeartRate;
  double get todayCalories => _todayCalories;
  double get todayDistance => _todayDistance;
  Map<String, dynamic>? get todaySleep => _todaySleep;
  List<Map<String, dynamic>> get weeklyData => _weeklyData;

  HealthProvider() {
    _loadSettings();
  }

  // Health Connect'i başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      notifyListeners();

      await _healthService.initialize();
      _isInitialized = _healthService.isInitialized;
      _hasPermissions = _healthService.hasPermissions;

      if (_hasPermissions) {
        await _loadTodayData();
        await _loadWeeklyData();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to initialize health service: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // İzinleri iste
  Future<bool> requestPermissions() async {
    try {
      _isLoading = true;
      notifyListeners();

      final granted = await _healthService.requestPermissions();
      _hasPermissions = granted;

      if (granted) {
        await _loadTodayData();
        await _loadWeeklyData();
      }

      _isLoading = false;
      notifyListeners();
      return granted;
    } catch (e) {
      print('Failed to request permissions: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Ayarları yükle
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _hasPermissions = prefs.getBool('health_permissions') ?? false;
  }

  // Ayarları kaydet
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_permissions', _hasPermissions);
  }

  // Bugünkü verileri yükle
  Future<void> _loadTodayData() async {
    if (!_hasPermissions) return;

    try {
      final todayData = await _healthService.getDailySummary();
      if (todayData != null) {
        _todaySteps = todayData['steps'] ?? 0;
        _todayHeartRate = todayData['heartRate'] ?? 0.0;
        _todayCalories = todayData['calories'] ?? 0.0;
        _todayDistance = todayData['distanceKm'] ?? 0.0;
        _todaySleep = todayData['sleep'];
      }
    } catch (e) {
      print('Failed to load today data: $e');
    }
  }

  // Haftalık verileri yükle
  Future<void> _loadWeeklyData() async {
    if (!_hasPermissions) return;

    try {
      _weeklyData.clear();
      
      for (int i = 6; i >= 0; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dayData = await _healthService.getDailySummary(date: date);
        
        if (dayData != null) {
          _weeklyData.add(dayData);
        } else {
          _weeklyData.add({
            'date': date.toIso8601String().split('T')[0],
            'steps': 0,
            'heartRate': 0.0,
            'calories': 0.0,
            'distanceKm': 0.0,
            'sleep': null,
          });
        }
      }
    } catch (e) {
      print('Failed to load weekly data: $e');
    }
  }

  // Verileri yenile
  Future<void> refreshData() async {
    if (!_hasPermissions) return;

    try {
      _isLoading = true;
      notifyListeners();

      await _loadTodayData();
      await _loadWeeklyData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to refresh data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adım sayısını al
  Future<int?> getStepCount({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;
    return await _healthService.getStepCount(startDate: startDate, endDate: endDate);
  }

  // Kalp atış hızını al
  Future<double?> getHeartRate({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;
    return await _healthService.getHeartRate(startDate: startDate, endDate: endDate);
  }

  // Uyku verilerini al
  Future<Map<String, dynamic>?> getSleepData({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;
    return await _healthService.getSleepData(startDate: startDate, endDate: endDate);
  }

  // Kalori verilerini al
  Future<double?> getCaloriesBurned({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;
    return await _healthService.getCaloriesBurned(startDate: startDate, endDate: endDate);
  }

  // Mesafe verilerini al
  Future<double?> getDistance({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;
    return await _healthService.getDistance(startDate: startDate, endDate: endDate);
  }

  // Günlük özet al
  Future<Map<String, dynamic>?> getDailySummary({DateTime? date}) async {
    if (!_hasPermissions) return null;
    return await _healthService.getDailySummary(date: date);
  }

  // Health Connect ayarlarını aç
  Future<void> openHealthConnectSettings() async {
    await _healthService.openHealthConnectSettings();
  }

  // Veri mevcut mu kontrol et
  Future<bool> isDataAvailable() async {
    if (!_hasPermissions) return false;
    return await _healthService.isDataAvailable();
  }

  // Haftalık ortalama adım sayısı
  double get weeklyAverageSteps {
    if (_weeklyData.isEmpty) return 0.0;
    
    int totalSteps = 0;
    for (var day in _weeklyData) {
      totalSteps += day['steps'] ?? 0;
    }
    
    return totalSteps / _weeklyData.length;
  }

  // Haftalık ortalama kalori
  double get weeklyAverageCalories {
    if (_weeklyData.isEmpty) return 0.0;
    
    double totalCalories = 0.0;
    for (var day in _weeklyData) {
      totalCalories += (day['calories'] ?? 0.0).toDouble();
    }
    
    return totalCalories / _weeklyData.length;
  }

  // Haftalık ortalama mesafe
  double get weeklyAverageDistance {
    if (_weeklyData.isEmpty) return 0.0;
    
    double totalDistance = 0.0;
    for (var day in _weeklyData) {
      totalDistance += (day['distanceKm'] ?? 0.0).toDouble();
    }
    
    return totalDistance / _weeklyData.length;
  }

  // Haftalık ortalama uyku süresi
  double get weeklyAverageSleep {
    if (_weeklyData.isEmpty) return 0.0;
    
    double totalSleep = 0.0;
    int daysWithSleep = 0;
    
    for (var day in _weeklyData) {
      final sleep = day['sleep'];
      if (sleep != null && sleep['totalSleepHours'] != null) {
        totalSleep += sleep['totalSleepHours'].toDouble();
        daysWithSleep++;
      }
    }
    
    return daysWithSleep > 0 ? totalSleep / daysWithSleep : 0.0;
  }

  // Günlük hedefler
  Map<String, int> get dailyGoals {
    return {
      'steps': 10000,
      'calories': 500,
      'distance': 5, // km
      'sleep': 8, // saat
    };
  }

  // Hedeflere ulaşma yüzdesi
  Map<String, double> get goalProgress {
    final goals = dailyGoals;
    
    return {
      'steps': (_todaySteps / goals['steps']! * 100).clamp(0.0, 100.0),
      'calories': (_todayCalories / goals['calories']! * 100).clamp(0.0, 100.0),
      'distance': (_todayDistance / goals['distance']! * 100).clamp(0.0, 100.0),
      'sleep': _todaySleep != null 
          ? ((_todaySleep!['totalSleepHours'] ?? 0.0) / goals['sleep']! * 100).clamp(0.0, 100.0)
          : 0.0,
    };
  }

  // Başarı durumu
  bool get hasReachedStepGoal => _todaySteps >= dailyGoals['steps']!;
  bool get hasReachedCalorieGoal => _todayCalories >= dailyGoals['calories']!;
  bool get hasReachedDistanceGoal => _todayDistance >= dailyGoals['distance']!;
  bool get hasReachedSleepGoal {
    if (_todaySleep == null) return false;
    return (_todaySleep!['totalSleepHours'] ?? 0.0) >= dailyGoals['sleep']!;
  }

  // Genel başarı yüzdesi
  double get overallGoalProgress {
    final progress = goalProgress;
    return (progress['steps']! + progress['calories']! + progress['distance']! + progress['sleep']!) / 4.0;
  }
}
