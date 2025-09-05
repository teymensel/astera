import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/virtual_pet_data.dart';
import '../../utils/app_theme.dart';

class PetDisplay extends StatefulWidget {
  final VirtualPetData pet;

  const PetDisplay({
    super.key,
    required this.pet,
  });

  @override
  State<PetDisplay> createState() => _PetDisplayState();
}

class _PetDisplayState extends State<PetDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    // Pet mutluysa zıplama animasyonu başlat
    if (widget.pet.isHappy) {
      _startBounceAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startBounceAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Pet görüntüsü
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_bounceAnimation.value * 0.1),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.pet.typeIcon,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Pet adı ve seviye
            Text(
              widget.pet.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Seviye ${widget.pet.level} • ${widget.pet.stage.name.toUpperCase()}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),

            // Ruh hali
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getMoodColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getMoodColor().withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.pet.moodIcon,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getMoodText(),
                    style: TextStyle(
                      color: _getMoodColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pet bilgileri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoItem(
                  'Yaş',
                  '${widget.pet.ageInDays} gün',
                  Icons.cake,
                ),
                _buildInfoItem(
                  'Deneyim',
                  '${widget.pet.experience}/${widget.pet.level * 100}',
                  Icons.star,
                ),
                _buildInfoItem(
                  'Sağlık',
                  '${widget.pet.overallHealth.toStringAsFixed(0)}%',
                  Icons.favorite,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Seviye ilerlemesi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Seviye İlerlemesi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${widget.pet.experienceToNextLevel} XP kaldı',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: widget.pet.levelProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              ],
            ),

            // Bakım gerekli uyarısı
            if (widget.pet.needsCare) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warningColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: AppTheme.warningColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Petinizin bakıma ihtiyacı var!',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getMoodColor() {
    switch (widget.pet.mood) {
      case PetMood.happy:
        return AppTheme.successColor;
      case PetMood.sad:
        return Colors.blue;
      case PetMood.excited:
        return AppTheme.accentColor;
      case PetMood.tired:
        return Colors.orange;
      case PetMood.hungry:
        return AppTheme.warningColor;
      case PetMood.sick:
        return AppTheme.errorColor;
      case PetMood.playful:
        return AppTheme.primaryColor;
      case PetMood.angry:
        return Colors.red;
    }
  }

  String _getMoodText() {
    switch (widget.pet.mood) {
      case PetMood.happy:
        return 'Mutlu';
      case PetMood.sad:
        return 'Üzgün';
      case PetMood.excited:
        return 'Heyecanlı';
      case PetMood.tired:
        return 'Yorgun';
      case PetMood.hungry:
        return 'Aç';
      case PetMood.sick:
        return 'Hasta';
      case PetMood.playful:
        return 'Oyuncul';
      case PetMood.angry:
        return 'Kızgın';
    }
  }
}
