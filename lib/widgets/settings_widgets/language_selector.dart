import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String _selectedLanguage = 'tr';

  final Map<String, Map<String, String>> _languages = {
    'tr': {
      'name': 'Türkçe',
      'flag': '🇹🇷',
      'code': 'tr',
    },
    'en': {
      'name': 'English',
      'flag': '🇺🇸',
      'code': 'en',
    },
    'es': {
      'name': 'Español',
      'flag': '🇪🇸',
      'code': 'es',
    },
    'fr': {
      'name': 'Français',
      'flag': '🇫🇷',
      'code': 'fr',
    },
    'de': {
      'name': 'Deutsch',
      'flag': '🇩🇪',
      'code': 'de',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Mevcut dil
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _languages[_selectedLanguage]!['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _languages[_selectedLanguage]!['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Mevcut dil',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Diğer diller
            const Text(
              'Diğer Diller',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            ..._languages.entries
                .where((entry) => entry.key != _selectedLanguage)
                .map((entry) => _buildLanguageOption(entry.key, entry.value))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, Map<String, String> language) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
          // Dil değiştirme işlemi
          _showLanguageChangeDialog(language['name']!);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Text(
                language['flag']!,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  language['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageChangeDialog(String languageName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dil Değiştir'),
        content: Text('Uygulama dili $languageName olarak değiştirilecek. Uygulama yeniden başlatılacak.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Dil değiştirme işlemi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dil $languageName olarak değiştirildi'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Değiştir'),
          ),
        ],
      ),
    );
  }
}
