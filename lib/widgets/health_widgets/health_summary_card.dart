import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../utils/app_theme.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        return Card(
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.today,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Bugünkü Özet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getDateString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Ana istatistikler
                  Row(
                    children: [
                      Expanded(
                        child: _buildMainStat(
                          'Adım',
                          '${healthProvider.todaySteps}',
                          Icons.directions_walk,
                          healthProvider.hasReachedStepGoal,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMainStat(
                          'Kalori',
                          '${healthProvider.todayCalories.toStringAsFixed(0)}',
                          Icons.local_fire_department,
                          healthProvider.hasReachedCalorieGoal,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildMainStat(
                          'Mesafe',
                          '${healthProvider.todayDistance.toStringAsFixed(1)} km',
                          Icons.straighten,
                          healthProvider.hasReachedDistanceGoal,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMainStat(
                          'Uyku',
                          _getSleepText(healthProvider.todaySleep),
                          Icons.bedtime,
                          healthProvider.hasReachedSleepGoal,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Genel ilerleme
                  _buildOverallProgress(healthProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainStat(String label, String value, IconData icon, bool isGoalReached) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGoalReached ? Colors.green : Colors.white.withOpacity(0.3),
          width: isGoalReached ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const Spacer(),
              if (isGoalReached)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(HealthProvider healthProvider) {
    final progress = healthProvider.overallGoalProgress;
    final progressPercent = (progress * 100).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Genel İlerleme',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$progressPercent%',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          _getProgressText(progress),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  String _getDateString() {
    final now = DateTime.now();
    final weekdays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    final months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 
                   'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  String _getSleepText(Map<String, dynamic>? sleep) {
    if (sleep == null || sleep['totalSleepHours'] == null) {
      return 'Veri yok';
    }
    
    final hours = sleep['totalSleepHours'].toDouble();
    return '${hours.toStringAsFixed(1)}h';
  }

  String _getProgressText(double progress) {
    if (progress >= 1.0) {
      return 'Tüm hedeflere ulaşıldı! 🎉';
    } else if (progress >= 0.8) {
      return 'Harika gidiyorsunuz! 💪';
    } else if (progress >= 0.6) {
      return 'İyi gidiyorsunuz! 👍';
    } else if (progress >= 0.4) {
      return 'Devam edin! 💪';
    } else {
      return 'Hedeflere ulaşmak için daha fazla çalışın! 🎯';
    }
  }
}
