import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/virtual_pet_provider.dart';
import '../../models/virtual_pet_data.dart';
import '../../utils/app_theme.dart';
import '../../widgets/virtual_pet_widgets/pet_display.dart';
import '../../widgets/virtual_pet_widgets/pet_stats.dart';
import '../../widgets/virtual_pet_widgets/pet_actions.dart';
import '../../widgets/virtual_pet_widgets/pet_creation.dart';

class VirtualPetScreen extends StatefulWidget {
  const VirtualPetScreen({super.key});

  @override
  State<VirtualPetScreen> createState() => _VirtualPetScreenState();
}

class _VirtualPetScreenState extends State<VirtualPetScreen> {
  @override
  void initState() {
    super.initState();
    // Pet durumunu periyodik olarak kontrol et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPetStatusTimer();
    });
  }

  void _startPetStatusTimer() {
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        context.read<VirtualPetProvider>().checkPetStatus();
        _startPetStatusTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanal Evcil Hayvan'),
        actions: [
          Consumer<VirtualPetProvider>(
            builder: (context, petProvider, child) {
              if (petProvider.hasPet) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'settings':
                        _showPetSettings(context);
                        break;
                      case 'delete':
                        _showDeletePetDialog(context);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 20),
                          SizedBox(width: 8),
                          Text('Ayarlar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<VirtualPetProvider>(
        builder: (context, petProvider, child) {
          if (!petProvider.hasPet) {
            return _buildPetCreationScreen();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Pet görüntüleme
                PetDisplay(pet: petProvider.pet!),
                
                const SizedBox(height: 24),
                
                // Pet istatistikleri
                PetStats(pet: petProvider.pet!),
                
                const SizedBox(height: 24),
                
                // Pet aksiyonları
                PetActions(
                  onFeed: () => petProvider.feedPet(),
                  onPlay: () => petProvider.playWithPet(),
                  onSleep: () => petProvider.putPetToSleep(),
                  onCare: () => petProvider.careForPet(),
                  isFeeding: petProvider.isFeeding,
                  isPlaying: petProvider.isPlaying,
                  isSleeping: petProvider.isSleeping,
                ),
                
                const SizedBox(height: 24),
                
                // Pet başarıları
                _buildAchievements(petProvider.pet!),
                
                const SizedBox(height: 24),
                
                // Pet eşyaları
                _buildItems(petProvider.pet!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPetCreationScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'Sanal Evcil Hayvanınız Yok',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sevgilinizle birlikte büyütebileceğiniz bir sanal evcil hayvan oluşturun!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showPetCreationDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Evcil Hayvan Oluştur'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(VirtualPetData pet) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Başarılar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (pet.achievements.isEmpty)
              const Text(
                'Henüz başarı yok. Petinizle oynayarak başarılar kazanın!',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pet.achievements.map((achievement) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.accentColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: AppTheme.accentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          achievement,
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItems(VirtualPetData pet) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eşyalar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (pet.unlockedItems.isEmpty)
              const Text(
                'Henüz eşya yok. Petinizle oynayarak eşyalar kazanın!',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pet.unlockedItems.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.inventory,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showPetCreationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PetCreationDialog(
        onPetCreated: (name, type, customImageUrl) {
          context.read<VirtualPetProvider>().createPet(
            name: name,
            type: type,
            customImageUrl: customImageUrl,
          );
        },
      ),
    );
  }

  void _showPetSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pet Ayarları'),
        content: const Text('Pet ayarları yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showDeletePetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Peti Sil'),
        content: const Text('Sanal evcil hayvanınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<VirtualPetProvider>().deletePet();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pet silindi'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
