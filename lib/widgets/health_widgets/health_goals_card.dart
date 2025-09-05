import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../utils/app_theme.dart';

class HealthGoalsCard extends StatelessWidget {
  const HealthGoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        final goals = healthProvider.dailyGoals;
        final progress = healthProvider.goalProgress;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Günlük Hedefler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Adım hedefi
                _buildGoalItem(
                  'Adım',
                  healthProvider.todaySteps,
                  goals['steps']!,
                  progress['steps']!,
                  Icons.directions_walk,
                  AppTheme.primaryColor,
                  healthProvider.hasReachedStepGoal,
                ),
                
                const SizedBox(height: 12),
                
                // Kalori hedefi
                _buildGoalItem(
                  'Kalori',
                  healthProvider.todayCalories.toInt(),
                  goals['calories']!,
                  progress['calories']!,
                  Icons.local_fire_department,
                  AppTheme.warningColor,
                  healthProvider.hasReachedCalorieGoal,
                ),
                
                const SizedBox(height: 12),
                
                // Mesafe hedefi
                _buildGoalItem(
                  'Mesafe',
                  (healthProvider.todayDistance * 1000).toInt(), // metre cinsinden
                  goals['distance']! * 1000, // metre cinsinden
                  progress['distance']!,
                  Icons.straighten,
                  AppTheme.accentColor,
                  healthProvider.hasReachedDistanceGoal,
                ),
                
                const SizedBox(height: 12),
                
                // Uyku hedefi
                _buildSleepGoalItem(
                  healthProvider.todaySleep,
                  goals['sleep']!,
                  progress['sleep']!,
                  healthProvider.hasReachedSleepGoal,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalItem(
    String label,
    int current,
    int target,
    double progress,
    IconData icon,
    Color color,
    bool isReached,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isReached ? Colors.green : color.withOpacity(0.3),
          width: isReached ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isReached)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _formatNumber(current),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                ' / ${_formatNumber(target)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isReached ? Colors.green : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              isReached ? Colors.green : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepGoalItem(
    Map<String, dynamic>? sleep,
    int targetHours,
    double progress,
    bool isReached,
  ) {
    final currentHours = sleep?['totalSleepHours']?.toDouble() ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isReached ? Colors.green : AppTheme.secondaryColor.withOpacity(0.3),
          width: isReached ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.bedtime, color: AppTheme.secondaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Uyku',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isReached)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${currentHours.toStringAsFixed(1)}h',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
              Text(
                ' / ${targetHours}h',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isReached ? Colors.green : AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              isReached ? Colors.green : AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
