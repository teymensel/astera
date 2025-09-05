import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PetActions extends StatelessWidget {
  final VoidCallback onFeed;
  final VoidCallback onPlay;
  final VoidCallback onSleep;
  final VoidCallback onCare;
  final bool isFeeding;
  final bool isPlaying;
  final bool isSleeping;

  const PetActions({
    super.key,
    required this.onFeed,
    required this.onPlay,
    required this.onSleep,
    required this.onCare,
    required this.isFeeding,
    required this.isPlaying,
    required this.isSleeping,
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
              'Pet Aksiyonları',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Ana aksiyonlar
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Besle',
                    Icons.restaurant,
                    AppTheme.warningColor,
                    onFeed,
                    isFeeding,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Oyna',
                    Icons.sports_esports,
                    AppTheme.accentColor,
                    onPlay,
                    isPlaying,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Uyut',
                    Icons.bedtime,
                    AppTheme.primaryColor,
                    onSleep,
                    isSleeping,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Bakım',
                    Icons.medical_services,
                    AppTheme.successColor,
                    onCare,
                    false,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Aksiyon açıklamaları
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aksiyon Etkileri',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildActionInfo('🍽️ Besle', 'Açlık +30, Mutluluk +10'),
                  _buildActionInfo('🎮 Oyna', 'Mutluluk +20, Enerji -15'),
                  _buildActionInfo('😴 Uyut', 'Enerji +100, Sağlık +10'),
                  _buildActionInfo('🏥 Bakım', 'Sağlık +100, Mutluluk +50'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
    bool isLoading,
  ) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildActionInfo(String action, String effect) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              effect,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
