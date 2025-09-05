import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/couple_provider.dart';
import '../../utils/app_theme.dart';

class FightCounterWidget extends StatelessWidget {
  const FightCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoupleProvider>(
      builder: (context, coupleProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      color: AppTheme.warningColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Kavga Durumu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    // Kavga sayısı
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.errorColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${coupleProvider.fightCount}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.errorColor,
                              ),
                            ),
                            const Text(
                              'Kavga',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.errorColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Barışma sayısı
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.successColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${coupleProvider.makeupCount}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.successColor,
                              ),
                            ),
                            const Text(
                              'Barışma',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Son kavga/barışma bilgisi
                if (coupleProvider.lastFightDate != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              coupleProvider.lastMakeupDate != null &&
                                      coupleProvider.lastMakeupDate!.isAfter(coupleProvider.lastFightDate!)
                                  ? Icons.favorite
                                  : Icons.warning,
                              size: 16,
                              color: coupleProvider.lastMakeupDate != null &&
                                      coupleProvider.lastMakeupDate!.isAfter(coupleProvider.lastFightDate!)
                                  ? AppTheme.successColor
                                  : AppTheme.warningColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              coupleProvider.lastMakeupDate != null &&
                                      coupleProvider.lastMakeupDate!.isAfter(coupleProvider.lastFightDate!)
                                  ? 'Son barışma'
                                  : 'Son kavga',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(
                            coupleProvider.lastMakeupDate != null &&
                                    coupleProvider.lastMakeupDate!.isAfter(coupleProvider.lastFightDate!)
                                ? coupleProvider.lastMakeupDate!
                                : coupleProvider.lastFightDate!,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Kavga ekleme butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showAddFightDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Kavga Ekle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warningColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${(difference.inDays / 7).floor()} hafta önce';
    }
  }

  void _showAddFightDialog(BuildContext context) {
    final reasonController = TextEditingController();
    final descriptionController = TextEditingController();
    int selectedSeverity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Kavga Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Kavga nedeni',
                    hintText: 'Örn: Para konusu',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Açıklama',
                    hintText: 'Kavganın detayları...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                const Text('Şiddet seviyesi:'),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    final severity = index + 1;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSeverity = severity;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedSeverity == severity
                                ? AppTheme.primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$severity',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selectedSeverity == severity
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.isNotEmpty) {
                  context.read<CoupleProvider>().addFight(
                    reasonController.text,
                    descriptionController.text,
                  );
                  Navigator.of(context).pop();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kavga eklendi'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
