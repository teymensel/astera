import 'package:flutter/material.dart';
import '../../models/virtual_pet_data.dart';
import '../../utils/app_theme.dart';

class PetStats extends StatelessWidget {
  final VirtualPetData pet;

  const PetStats({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pet İstatistikleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Ana istatistikler
            Row(
              children: [
                Expanded(
                  child: _buildStatBar(
                    'Sağlık',
                    pet.health,
                    100,
                    AppTheme.errorColor,
                    Icons.favorite,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatBar(
                    'Açlık',
                    pet.hunger,
                    100,
                    AppTheme.warningColor,
                    Icons.restaurant,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatBar(
                    'Mutluluk',
                    pet.happiness,
                    100,
                    AppTheme.accentColor,
                    Icons.sentiment_very_satisfied,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatBar(
                    'Enerji',
                    pet.energy,
                    100,
                    AppTheme.primaryColor,
                    Icons.battery_charging_full,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Detaylı bilgiler
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Genel Sağlık', '${pet.overallHealth.toStringAsFixed(1)}%'),
                  const Divider(),
                  _buildDetailRow('Seviye', '${pet.level}'),
                  const Divider(),
                  _buildDetailRow('Deneyim', '${pet.experience} XP'),
                  const Divider(),
                  _buildDetailRow('Aşama', _getStageText(pet.stage)),
                  const Divider(),
                  _buildDetailRow('Yaş', '${pet.ageInDays} gün'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Durum uyarıları
            if (pet.isHungry || pet.isTired || !pet.isHappy || pet.isSick) ...[
              const Text(
                'Durum Uyarıları',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (pet.isHungry)
                _buildWarningItem('Petiniz aç! Besleyin.', Icons.restaurant, AppTheme.warningColor),
              if (pet.isTired)
                _buildWarningItem('Petiniz yorgun! Uyutun.', Icons.bedtime, Colors.blue),
              if (!pet.isHappy)
                _buildWarningItem('Petiniz mutsuz! Oynayın.', Icons.sentiment_dissatisfied, Colors.orange),
              if (pet.isSick)
                _buildWarningItem('Petiniz hasta! Bakım yapın.', Icons.medical_services, AppTheme.errorColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int value, int maxValue, Color color, IconData icon) {
    final percentage = value / maxValue;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$value/$maxValue',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String message, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStageText(PetStage stage) {
    switch (stage) {
      case PetStage.egg:
        return 'Yumurta';
      case PetStage.baby:
        return 'Bebek';
      case PetStage.child:
        return 'Çocuk';
      case PetStage.teen:
        return 'Genç';
      case PetStage.adult:
        return 'Yetişkin';
      case PetStage.elder:
        return 'Yaşlı';
    }
  }
}
