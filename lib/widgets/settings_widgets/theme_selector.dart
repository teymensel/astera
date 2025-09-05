import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/theme_provider.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tema',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Tema seçenekleri
                _buildThemeOption(
                  'system',
                  'Sistem',
                  'Cihaz ayarlarını takip eder',
                  Icons.brightness_auto,
                  themeProvider.currentTheme,
                  (value) => themeProvider.setTheme(value),
                ),
                _buildThemeOption(
                  'light',
                  'Açık Tema',
                  'Her zaman açık tema kullan',
                  Icons.light_mode,
                  themeProvider.currentTheme,
                  (value) => themeProvider.setTheme(value),
                ),
                _buildThemeOption(
                  'dark',
                  'Koyu Tema',
                  'Her zaman koyu tema kullan',
                  Icons.dark_mode,
                  themeProvider.currentTheme,
                  (value) => themeProvider.setTheme(value),
                ),
                
                const SizedBox(height: 16),
                
                // Renk paleti
                const Text(
                  'Renk Paleti',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    _buildColorOption(
                      'Pembe',
                      AppTheme.primaryColor,
                      true,
                    ),
                    const SizedBox(width: 12),
                    _buildColorOption(
                      'Mor',
                      AppTheme.secondaryColor,
                      false,
                    ),
                    const SizedBox(width: 12),
                    _buildColorOption(
                      'Mavi',
                      Colors.blue,
                      false,
                    ),
                    const SizedBox(width: 12),
                    _buildColorOption(
                      'Yeşil',
                      Colors.green,
                      false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    String value, 
    String title, 
    String subtitle, 
    IconData icon,
    String currentTheme,
    Function(String) onChanged,
  ) {
    final isSelected = currentTheme == value;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected 
                  ? AppTheme.primaryColor
                  : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? AppTheme.primaryColor
                    : Colors.grey[600],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? AppTheme.primaryColor
                            : Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(String name, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Renk değiştirme işlemi
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey[300]!,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}