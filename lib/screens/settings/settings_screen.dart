import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/settings_widgets/theme_selector.dart';
import '../../widgets/settings_widgets/language_selector.dart';
import '../../widgets/settings_widgets/notification_settings.dart';
import '../../widgets/settings_widgets/privacy_settings.dart';
import '../../widgets/settings_widgets/about_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı profili
            _buildUserProfile(),
            
            const SizedBox(height: 24),
            
            // Tema ayarları
            const ThemeSelector(),
            
            const SizedBox(height: 16),
            
            // Dil ayarları
            const LanguageSelector(),
            
            const SizedBox(height: 16),
            
            // Bildirim ayarları
            const NotificationSettings(),
            
            const SizedBox(height: 16),
            
            // Gizlilik ayarları
            const PrivacySettings(),
            
            const SizedBox(height: 16),
            
            // Hesap ayarları
            _buildAccountSection(),
            
            const SizedBox(height: 16),
            
            // Uygulama ayarları
            _buildAppSection(),
            
            const SizedBox(height: 16),
            
            // Hakkında
            const AboutSection(),
            
            const SizedBox(height: 32),
            
            // Çıkış yap butonu
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    authProvider.userName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.userName ?? 'Kullanıcı',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.userEmail ?? 'email@example.com',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: authProvider.isPaired 
                              ? AppTheme.successColor.withOpacity(0.1)
                              : AppTheme.warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          authProvider.isPaired ? 'Eşleşmiş' : 'Eşleşmemiş',
                          style: TextStyle(
                            color: authProvider.isPaired 
                                ? AppTheme.successColor
                                : AppTheme.warningColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Profil düzenleme sayfasına git
                    _showEditProfileDialog(context);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Hesap',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.person,
            title: 'Profil Bilgileri',
            subtitle: 'Ad, e-posta ve diğer bilgiler',
            onTap: () => _showEditProfileDialog(context),
          ),
          _buildSettingItem(
            icon: Icons.security,
            title: 'Güvenlik',
            subtitle: 'Şifre ve güvenlik ayarları',
            onTap: () => _showSecurityDialog(context),
          ),
          _buildSettingItem(
            icon: Icons.sync,
            title: 'Veri Senkronizasyonu',
            subtitle: 'Verilerinizi senkronize edin',
            onTap: () => _showSyncDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Uygulama',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.storage,
            title: 'Depolama',
            subtitle: 'Uygulama verilerini yönetin',
            onTap: () => _showStorageDialog(context),
          ),
          _buildSettingItem(
            icon: Icons.backup,
            title: 'Yedekleme',
            subtitle: 'Verilerinizi yedekleyin',
            onTap: () => _showBackupDialog(context),
          ),
          _buildSettingItem(
            icon: Icons.restore,
            title: 'Geri Yükleme',
            subtitle: 'Yedekten geri yükleyin',
            onTap: () => _showRestoreDialog(context),
          ),
          _buildSettingItem(
            icon: Icons.bug_report,
            title: 'Hata Bildirimi',
            subtitle: 'Sorun bildirin',
            onTap: () => _showBugReportDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout),
        label: const Text('Çıkış Yap'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profil Düzenle'),
        content: const Text('Profil düzenleme sayfası yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Güvenlik'),
        content: const Text('Güvenlik ayarları yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Veri Senkronizasyonu'),
        content: const Text('Veri senkronizasyonu yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Depolama'),
        content: const Text('Depolama yönetimi yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yedekleme'),
        content: const Text('Veri yedekleme yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Geri Yükleme'),
        content: const Text('Veri geri yükleme yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata Bildirimi'),
        content: const Text('Hata bildirimi yakında eklenecek.'),
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
