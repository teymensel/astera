import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../utils/app_theme.dart';

class HealthWeeklyChart extends StatelessWidget {
  const HealthWeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        final weeklyData = healthProvider.weeklyData;
        
        if (weeklyData.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Haftalık Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Adım grafiği
                _buildChart(
                  'Adım Sayısı',
                  weeklyData.map((day) => day['steps'] ?? 0).toList(),
                  AppTheme.primaryColor,
                  'adım',
                ),
                
                const SizedBox(height: 20),
                
                // Kalori grafiği
                _buildChart(
                  'Kalori',
                  weeklyData.map((day) => (day['calories'] ?? 0.0).toDouble()).toList(),
                  AppTheme.warningColor,
                  'kcal',
                ),
                
                const SizedBox(height: 20),
                
                // Mesafe grafiği
                _buildChart(
                  'Mesafe',
                  weeklyData.map((day) => (day['distanceKm'] ?? 0.0).toDouble()).toList(),
                  AppTheme.accentColor,
                  'km',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart(String title, List<double> data, Color color, String unit) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final normalizedData = range > 0 
        ? data.map((value) => (value - minValue) / range).toList()
        : data.map((_) => 0.5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${maxValue.toStringAsFixed(0)}$unit',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Grafik
        Container(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final value = normalizedData[index];
              final dayValue = data[index];
              final dayName = _getDayName(index);
              
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      // Grafik çubuğu
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.bottomCenter,
                            heightFactor: value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Gün adı
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 2),
                      
                      // Değer
                      Text(
                        '${dayValue.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  String _getDayName(int index) {
    final now = DateTime.now();
    final day = now.subtract(Duration(days: 6 - index));
    final weekdays = ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'];
    return weekdays[day.weekday - 1];
  }
}
