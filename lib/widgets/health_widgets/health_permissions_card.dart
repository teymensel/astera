import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../utils/app_theme.dart';

class HealthPermissionsCard extends StatelessWidget {
  const HealthPermissionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety,
                size: 80,
                color: Colors.grey[400],
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Sağlık Verilerine Erişim Gerekli',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Adım sayısı, kalp atış hızı, uyku verileri ve diğer sağlık bilgilerinizi takip etmek için Health Connect izni gereklidir.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              Consumer<HealthProvider>(
                builder: (context, healthProvider, child) {
                  return Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: healthProvider.isLoading
                            ? null
                            : () => _requestPermissions(context, healthProvider),
                        icon: healthProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.health_and_safety),
                        label: Text(
                          healthProvider.isLoading
                              ? 'İzinler İsteniyor...'
                              : 'İzinleri İste',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextButton.icon(
                        onPressed: () => healthProvider.openHealthConnectSettings(),
                        icon: const Icon(Icons.settings),
                        label: const Text('Health Connect Ayarları'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Veri Güvenliği',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Tüm sağlık verileriniz cihazınızda güvenle saklanır\n'
                      '• Verileriniz üçüncü taraflarla paylaşılmaz\n'
                      '• Health Connect güvenlik standartlarına uygun\n'
                      '• İstediğiniz zaman izinleri iptal edebilirsiniz',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermissions(BuildContext context, HealthProvider healthProvider) async {
    try {
      final granted = await healthProvider.requestPermissions();
      
      if (granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sağlık verilerine erişim izni verildi'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sağlık verilerine erişim izni reddedildi'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
