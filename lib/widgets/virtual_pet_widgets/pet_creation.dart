import 'package:flutter/material.dart';
import '../../models/virtual_pet_data.dart';
import '../../utils/app_theme.dart';

class PetCreationDialog extends StatefulWidget {
  final Function(String name, PetType type, String? customImageUrl) onPetCreated;

  const PetCreationDialog({
    super.key,
    required this.onPetCreated,
  });

  @override
  State<PetCreationDialog> createState() => _PetCreationDialogState();
}

class _PetCreationDialogState extends State<PetCreationDialog> {
  final _nameController = TextEditingController();
  PetType _selectedType = PetType.cat;
  String? _customImageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Başlık
            const Text(
              'Sanal Evcil Hayvan Oluştur',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Pet adı
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Pet Adı',
                hintText: 'Evcil hayvanınızın adını girin...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pets),
              ),
            ),

            const SizedBox(height: 24),

            // Pet türü seçimi
            const Text(
              'Pet Türü Seçin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: PetType.values.length,
              itemBuilder: (context, index) {
                final type = PetType.values[index];
                final isSelected = _selectedType == type;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.primaryColor
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getPetTypeIcon(type),
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getPetTypeName(type),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? AppTheme.primaryColor
                                : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Özel resim URL'si (opsiyonel)
            TextField(
              onChanged: (value) {
                setState(() {
                  _customImageUrl = value.trim().isEmpty ? null : value.trim();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Özel Resim URL (Opsiyonel)',
                hintText: 'https://example.com/pet-image.jpg',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),

            const SizedBox(height: 24),

            // Butonlar
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('İptal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createPet,
                    child: const Text('Oluştur'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPetTypeIcon(PetType type) {
    switch (type) {
      case PetType.cat:
        return '🐱';
      case PetType.dog:
        return '🐶';
      case PetType.bird:
        return '🐦';
      case PetType.fish:
        return '🐠';
      case PetType.bunny:
        return '🐰';
      case PetType.custom:
        return '🎭';
    }
  }

  String _getPetTypeName(PetType type) {
    switch (type) {
      case PetType.cat:
        return 'Kedi';
      case PetType.dog:
        return 'Köpek';
      case PetType.bird:
        return 'Kuş';
      case PetType.fish:
        return 'Balık';
      case PetType.bunny:
        return 'Tavşan';
      case PetType.custom:
        return 'Özel';
    }
  }

  void _createPet() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet adı gerekli'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    widget.onPetCreated(
      _nameController.text.trim(),
      _selectedType,
      _customImageUrl,
    );
    Navigator.of(context).pop();
  }
}
