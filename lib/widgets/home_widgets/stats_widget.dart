import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/couple_provider.dart';
import '../../utils/app_theme.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoupleProvider>(
      builder: (context, coupleProvider, child) {
        final daysTogether = coupleProvider.getDaysTogether();
        final fightCount = coupleProvider.fightCount;
        final makeupCount = coupleProvider.makeupCount;
        
        // İstatistikler
        final weeksTogether = (daysTogether / 7).floor();
        final monthsTogether = (daysTogether / 30).floor();
        final yearsTogether = (daysTogether / 365).floor();
        
        final fightRate = daysTogether > 0 ? (fightCount / daysTogether * 30).toStringAsFixed(1) : '0';
        final makeupRate = fightCount > 0 ? (makeupCount / fightCount * 100).toStringAsFixed(0) : '0';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.analytics,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'İstatistikler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Ana istatistikler
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Gün',
                        '$daysTogether',
                        Icons.calendar_today,
                        AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Hafta',
                        '$weeksTogether',
                        Icons.date_range,
                        AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Ay',
                        '$monthsTogether',
                        Icons.calendar_month,
                        AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Yıl',
                        '$yearsTogether',
                        Icons.cake,
                        AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Kavga istatistikleri
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kavga Analizi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Aylık Kavga Oranı',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$fightRate kavga/ay',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.warningColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Barışma Oranı',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '%$makeupRate',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Motivasyon mesajı
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getMotivationalMessage(daysTogether, fightCount, makeupRate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalMessage(int daysTogether, int fightCount, String makeupRate) {
    if (daysTogether < 30) {
      return 'Yeni başlayan bir ilişki! Her gün birlikte büyüyorsunuz 💕';
    } else if (daysTogether < 365) {
      return 'Güzel bir ilişki kurmuşsunuz! Devam edin 🌟';
    } else if (fightCount == 0) {
      return 'Harika! Hiç kavga etmemişsiniz! 🎉';
    } else if (double.parse(makeupRate) >= 80) {
      return 'Mükemmel! Sorunları çözmeyi çok iyi biliyorsunuz 👏';
    } else if (double.parse(makeupRate) >= 60) {
      return 'İyi gidiyor! Biraz daha iletişim kurun 💬';
    } else {
      return 'İletişim kurmayı deneyin, birlikte çözebilirsiniz 🤝';
    }
  }
}
