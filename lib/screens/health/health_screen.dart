import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/health_widgets/health_summary_card.dart';
import '../../widgets/health_widgets/health_goals_card.dart';
import '../../widgets/health_widgets/health_weekly_chart.dart';
import '../../widgets/health_widgets/health_permissions_card.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sağlık & Fitness'),
        actions: [
          Consumer<HealthProvider>(
            builder: (context, healthProvider, child) {
              if (healthProvider.hasPermissions) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => healthProvider.refreshData(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<HealthProvider>(
        builder: (context, healthProvider, child) {
          if (healthProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!healthProvider.hasPermissions) {
            return const HealthPermissionsCard();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Günlük özet
                const HealthSummaryCard(),
                
                const SizedBox(height: 16),
                
                // Hedefler
                const HealthGoalsCard(),
                
                const SizedBox(height: 16),
                
                // Haftalık grafik
                const HealthWeeklyChart(),
                
                const SizedBox(height: 16),
                
                // Detaylı istatistikler
                _buildDetailedStats(healthProvider),
                
                const SizedBox(height: 16),
                
                // Haftalık özet
                _buildWeeklySummary(healthProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailedStats(HealthProvider healthProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detaylı İstatistikler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Kalp Atışı',
                    '${healthProvider.todayHeartRate.toStringAsFixed(0)} BPM',
                    Icons.favorite,
                    AppTheme.errorColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Kalori',
                    '${healthProvider.todayCalories.toStringAsFixed(0)} kcal',
                    Icons.local_fire_department,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Mesafe',
                    '${healthProvider.todayDistance.toStringAsFixed(1)} km',
                    Icons.directions_walk,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Uyku',
                    _getSleepText(healthProvider.todaySleep),
                    Icons.bedtime,
                    AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary(HealthProvider healthProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Haftalık Özet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildWeeklyStatItem(
                    'Ort. Adım',
                    '${healthProvider.weeklyAverageSteps.toStringAsFixed(0)}',
                    Icons.directions_walk,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWeeklyStatItem(
                    'Ort. Kalori',
                    '${healthProvider.weeklyAverageCalories.toStringAsFixed(0)}',
                    Icons.local_fire_department,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildWeeklyStatItem(
                    'Ort. Mesafe',
                    '${healthProvider.weeklyAverageDistance.toStringAsFixed(1)} km',
                    Icons.straighten,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWeeklyStatItem(
                    'Ort. Uyku',
                    '${healthProvider.weeklyAverageSleep.toStringAsFixed(1)} saat',
                    Icons.bedtime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStatItem(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getSleepText(Map<String, dynamic>? sleep) {
    if (sleep == null || sleep['totalSleepHours'] == null) {
      return 'Veri yok';
    }
    
    final hours = sleep['totalSleepHours'].toDouble();
    return '${hours.toStringAsFixed(1)} saat';
  }
}
