import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class HealthConnectService {
  static final HealthConnectService _instance = HealthConnectService._internal();
  factory HealthConnectService() => _instance;
  HealthConnectService._internal();

  Health? _health;
  bool _isInitialized = false;
  bool _hasPermissions = false;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get hasPermissions => _hasPermissions;

  // Health Connect'i başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _health = Health();
      _isInitialized = true;
      await _checkPermissions();
    } catch (e) {
      print('Health Connect initialization failed: $e');
    }
  }

  // İzinleri kontrol et
  Future<void> _checkPermissions() async {
    if (!_isInitialized) return;

    try {
      // Android için Health Connect izni
      if (Platform.isAndroid) {
        final status = await Permission.activityRecognition.request();
        _hasPermissions = status == PermissionStatus.granted;
      } else {
        // iOS için HealthKit izni
        _hasPermissions = await _health?.hasPermissions() ?? false;
      }
    } catch (e) {
      print('Permission check failed: $e');
      _hasPermissions = false;
    }
  }

  // İzinleri iste
  Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (Platform.isAndroid) {
        // Android Health Connect izinleri
        final permissions = [
          Permission.activityRecognition,
          Permission.sensors,
        ];

        Map<Permission, PermissionStatus> statuses = await permissions.request();
        
        _hasPermissions = statuses.values.every((status) => status == PermissionStatus.granted);
      } else {
        // iOS HealthKit izinleri
        _hasPermissions = await _health?.hasPermissions() ?? false;
        
        if (!_hasPermissions) {
          _hasPermissions = await _health?.requestAuthorization(
            types: _getHealthDataTypes(),
            permissions: _getHealthPermissions(),
          ) ?? false;
        }
      }

      return _hasPermissions;
    } catch (e) {
      print('Permission request failed: $e');
      return false;
    }
  }

  // Adım sayısını al
  Future<int?> getStepCount({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;

    try {
      final now = DateTime.now();
      final start = startDate ?? DateTime(now.year, now.month, now.day);
      final end = endDate ?? now;

      final steps = await _health?.getHealthDataFromTypes(
        start,
        end,
        [HealthDataType.STEPS],
      );

      if (steps != null && steps.isNotEmpty) {
        int totalSteps = 0;
        for (var step in steps) {
          if (step.value is NumericHealthValue) {
            totalSteps += (step.value as NumericHealthValue).numericValue.toInt();
          }
        }
        return totalSteps;
      }
    } catch (e) {
      print('Failed to get step count: $e');
    }

    return null;
  }

  // Kalp atış hızını al
  Future<double?> getHeartRate({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;

    try {
      final now = DateTime.now();
      final start = startDate ?? DateTime(now.year, now.month, now.day);
      final end = endDate ?? now;

      final heartRate = await _health?.getHealthDataFromTypes(
        start,
        end,
        [HealthDataType.HEART_RATE],
      );

      if (heartRate != null && heartRate.isNotEmpty) {
        // En son kalp atış hızını al
        var latest = heartRate.last;
        if (latest.value is NumericHealthValue) {
          return (latest.value as NumericHealthValue).numericValue;
        }
      }
    } catch (e) {
      print('Failed to get heart rate: $e');
    }

    return null;
  }

  // Uyku verilerini al
  Future<Map<String, dynamic>?> getSleepData({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;

    try {
      final now = DateTime.now();
      final start = startDate ?? DateTime(now.year, now.month, now.day);
      final end = endDate ?? now;

      final sleep = await _health?.getHealthDataFromTypes(
        start,
        end,
        [HealthDataType.SLEEP_IN_BED, HealthDataType.SLEEP_AWAKE, HealthDataType.SLEEP_DEEP, HealthDataType.SLEEP_LIGHT, HealthDataType.SLEEP_REM],
      );

      if (sleep != null && sleep.isNotEmpty) {
        int totalSleepMinutes = 0;
        int deepSleepMinutes = 0;
        int lightSleepMinutes = 0;
        int remSleepMinutes = 0;
        int awakeMinutes = 0;

        for (var sleepData in sleep) {
          if (sleepData.value is NumericHealthValue) {
            int minutes = (sleepData.value as NumericHealthValue).numericValue.toInt();
            
            switch (sleepData.type) {
              case HealthDataType.SLEEP_IN_BED:
                totalSleepMinutes += minutes;
                break;
              case HealthDataType.SLEEP_DEEP:
                deepSleepMinutes += minutes;
                break;
              case HealthDataType.SLEEP_LIGHT:
                lightSleepMinutes += minutes;
                break;
              case HealthDataType.SLEEP_REM:
                remSleepMinutes += minutes;
                break;
              case HealthDataType.SLEEP_AWAKE:
                awakeMinutes += minutes;
                break;
              default:
                break;
            }
          }
        }

        return {
          'totalSleepHours': totalSleepMinutes / 60.0,
          'deepSleepHours': deepSleepMinutes / 60.0,
          'lightSleepHours': lightSleepMinutes / 60.0,
          'remSleepHours': remSleepMinutes / 60.0,
          'awakeHours': awakeMinutes / 60.0,
        };
      }
    } catch (e) {
      print('Failed to get sleep data: $e');
    }

    return null;
  }

  // Kalori verilerini al
  Future<double?> getCaloriesBurned({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;

    try {
      final now = DateTime.now();
      final start = startDate ?? DateTime(now.year, now.month, now.day);
      final end = endDate ?? now;

      final calories = await _health?.getHealthDataFromTypes(
        start,
        end,
        [HealthDataType.ACTIVE_ENERGY_BURNED],
      );

      if (calories != null && calories.isNotEmpty) {
        double totalCalories = 0;
        for (var calorie in calories) {
          if (calorie.value is NumericHealthValue) {
            totalCalories += (calorie.value as NumericHealthValue).numericValue;
          }
        }
        return totalCalories;
      }
    } catch (e) {
      print('Failed to get calories: $e');
    }

    return null;
  }

  // Mesafe verilerini al
  Future<double?> getDistance({DateTime? startDate, DateTime? endDate}) async {
    if (!_hasPermissions) return null;

    try {
      final now = DateTime.now();
      final start = startDate ?? DateTime(now.year, now.month, now.day);
      final end = endDate ?? now;

      final distance = await _health?.getHealthDataFromTypes(
        start,
        end,
        [HealthDataType.DISTANCE_DELTA],
      );

      if (distance != null && distance.isNotEmpty) {
        double totalDistance = 0;
        for (var dist in distance) {
          if (dist.value is NumericHealthValue) {
            totalDistance += (dist.value as NumericHealthValue).numericValue;
          }
        }
        return totalDistance; // Metre cinsinden
      }
    } catch (e) {
      print('Failed to get distance: $e');
    }

    return null;
  }

  // Günlük özet verileri al
  Future<Map<String, dynamic>?> getDailySummary({DateTime? date}) async {
    if (!_hasPermissions) return null;

    try {
      final targetDate = date ?? DateTime.now();
      final start = DateTime(targetDate.year, targetDate.month, targetDate.day);
      final end = start.add(const Duration(days: 1));

      final steps = await getStepCount(startDate: start, endDate: end);
      final heartRate = await getHeartRate(startDate: start, endDate: end);
      final sleepData = await getSleepData(startDate: start, endDate: end);
      final calories = await getCaloriesBurned(startDate: start, endDate: end);
      final distance = await getDistance(startDate: start, endDate: end);

      return {
        'date': targetDate.toIso8601String().split('T')[0],
        'steps': steps ?? 0,
        'heartRate': heartRate ?? 0.0,
        'sleep': sleepData,
        'calories': calories ?? 0.0,
        'distance': distance ?? 0.0, // Metre
        'distanceKm': (distance ?? 0.0) / 1000.0, // Kilometre
      };
    } catch (e) {
      print('Failed to get daily summary: $e');
    }

    return null;
  }

  // Sağlık veri tiplerini al
  List<HealthDataType> _getHealthDataTypes() {
    return [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_REM,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_DELTA,
    ];
  }

  // Sağlık izinlerini al
  List<HealthDataAccess> _getHealthPermissions() {
    return [
      HealthDataAccess.READ,
    ];
  }

  // Health Connect ayarlarını aç
  Future<void> openHealthConnectSettings() async {
    if (Platform.isAndroid) {
      await openAppSettings();
    } else {
      // iOS için HealthKit ayarları
      await openAppSettings();
    }
  }

  // Veri senkronizasyonu kontrol et
  Future<bool> isDataAvailable() async {
    if (!_hasPermissions) return false;

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final steps = await getStepCount(startDate: today, endDate: now);
      return steps != null && steps > 0;
    } catch (e) {
      print('Data availability check failed: $e');
      return false;
    }
  }
}
