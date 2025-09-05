import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  bool _profileVisibility = true;
  bool _activitySharing = true;
  bool _locationSharing = false;
  bool _dataAnalytics = true;
  bool _crashReporting = true;
  bool _marketingEmails = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gizlilik ve Güvenlik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Profil gizliliği
            _buildPrivacySection(
              'Profil Gizliliği',
              [
                _buildPrivacyItem(
                  'Profil Görünürlüğü',
                  'Profilinizi diğer kullanıcılara göster',
                  _profileVisibility,
                  (value) => setState(() => _profileVisibility = value),
                ),
                _buildPrivacyItem(
                  'Aktivite Paylaşımı',
                  'Aktivitelerinizi sevgilinizle paylaş',
                  _activitySharing,
                  (value) => setState(() => _activitySharing = value),
                ),
                _buildPrivacyItem(
                  'Konum Paylaşımı',
                  'Konumunuzu sevgilinizle paylaş',
                  _locationSharing,
                  (value) => setState(() => _locationSharing = value),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Veri kullanımı
            _buildPrivacySection(
              'Veri Kullanımı',
              [
                _buildPrivacyItem(
                  'Veri Analizi',
                  'Uygulama geliştirme için anonim veri topla',
                  _dataAnalytics,
                  (value) => setState(() => _dataAnalytics = value),
                ),
                _buildPrivacyItem(
                  'Hata Raporlama',
                  'Uygulama hatalarını otomatik raporla',
                  _crashReporting,
                  (value) => setState(() => _crashReporting = value),
                ),
                _buildPrivacyItem(
                  'Pazarlama E-postaları',
                  'Promosyon ve güncelleme e-postaları al',
                  _marketingEmails,
                  (value) => setState(() => _marketingEmails = value),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Veri yönetimi
            _buildDataManagement(),
            
            const SizedBox(height: 16),
            
            // Gizlilik politikası
            _buildPrivacyPolicy(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildPrivacyItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDataManagement() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Veri Yönetimi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildDataAction(
            'Verilerimi İndir',
            'Tüm verilerinizi indirin',
            Icons.download,
            () => _showDataDownloadDialog(),
          ),
          
          const Divider(),
          
          _buildDataAction(
            'Verilerimi Sil',
            'Tüm verilerinizi kalıcı olarak silin',
            Icons.delete_forever,
            () => _showDataDeleteDialog(),
            isDestructive: true,
          ),
          
          const Divider(),
          
          _buildDataAction(
            'Hesabımı Sil',
            'Hesabınızı ve tüm verilerinizi silin',
            Icons.person_remove,
            () => _showAccountDeleteDialog(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDataAction(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? AppTheme.errorColor : Colors.black,
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
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return Container(
      padding: const EdgeInsets.all(12),
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
            'Gizlilik Politikası',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Verilerinizin nasıl kullanıldığını ve korunduğunu öğrenin.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () => _showPrivacyPolicy(),
                child: const Text('Gizlilik Politikası'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _showTermsOfService(),
                child: const Text('Kullanım Şartları'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDataDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Veri İndirme'),
        content: const Text('Tüm verileriniz hazırlanıyor. E-posta adresinize indirme linki gönderilecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veri indirme talebi gönderildi'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('İndir'),
          ),
        ],
      ),
    );
  }

  void _showDataDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Veri Silme'),
        content: const Text('Tüm verileriniz kalıcı olarak silinecek. Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veri silme talebi gönderildi'),
                  backgroundColor: AppTheme.warningColor,
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

  void _showAccountDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesap Silme'),
        content: const Text('Hesabınız ve tüm verileriniz kalıcı olarak silinecek. Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hesap silme talebi gönderildi'),
                  backgroundColor: AppTheme.errorColor,
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

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gizlilik Politikası'),
        content: const Text('Gizlilik politikası sayfası yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kullanım Şartları'),
        content: const Text('Kullanım şartları sayfası yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
