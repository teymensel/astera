import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/notification_provider.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bildirimler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Genel bildirimler
                _buildNotificationSection(
                  'Genel',
                  [
                    _buildNotificationItem(
                      'Push Bildirimleri',
                      'Uygulama bildirimleri',
                      notificationProvider.pushNotificationsEnabled,
                      (value) => notificationProvider.setPushNotificationsEnabled(value),
                    ),
                    _buildNotificationItem(
                      'E-posta Bildirimleri',
                      'E-posta ile bildirimler',
                      notificationProvider.emailNotificationsEnabled,
                      (value) => notificationProvider.setEmailNotificationsEnabled(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // İlişki bildirimleri
                _buildNotificationSection(
                  'İlişki',
                  [
                    _buildNotificationItem(
                      'Yıldönümü Hatırlatmaları',
                      'Özel günler için hatırlatmalar',
                      notificationProvider.anniversaryRemindersEnabled,
                      (value) => notificationProvider.setAnniversaryRemindersEnabled(value),
                    ),
                    _buildNotificationItem(
                      'Kavga Hatırlatmaları',
                      'Barışma önerileri',
                      notificationProvider.fightRemindersEnabled,
                      (value) => notificationProvider.setFightRemindersEnabled(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Pet bildirimleri
                _buildNotificationSection(
                  'Sanal Pet',
                  [
                    _buildNotificationItem(
                      'Pet Bakım Hatırlatmaları',
                      'Petinizin bakıma ihtiyacı olduğunda',
                      notificationProvider.petCareRemindersEnabled,
                      (value) => notificationProvider.setPetCareRemindersEnabled(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Müzik bildirimleri
                _buildNotificationSection(
                  'Müzik',
                  [
                    _buildNotificationItem(
                      'Müzik Bildirimleri',
                      'Spotify entegrasyonu bildirimleri',
                      notificationProvider.musicNotificationsEnabled,
                      (value) => notificationProvider.setMusicNotificationsEnabled(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Raporlar
                _buildNotificationSection(
                  'Raporlar',
                  [
                    _buildNotificationItem(
                      'Günlük Hatırlatmalar',
                      'Günlük aktivite hatırlatmaları',
                      notificationProvider.dailyRemindersEnabled,
                      (value) => notificationProvider.setDailyRemindersEnabled(value),
                    ),
                    _buildNotificationItem(
                      'Haftalık Raporlar',
                      'Haftalık ilişki raporları',
                      notificationProvider.weeklyReportsEnabled,
                      (value) => notificationProvider.setWeeklyReportsEnabled(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Test notification butonu
                _buildTestNotificationButton(notificationProvider),
                
                const SizedBox(height: 16),
                
                // Notification ayarları
                _buildNotificationSettingsButton(notificationProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationSection(String title, List<Widget> children) {
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

  Widget _buildNotificationItem(
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

  Widget _buildTestNotificationButton(NotificationProvider notificationProvider) {
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
            'Test Bildirimi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bildirim ayarlarınızı test etmek için bir test bildirimi gönderin.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _sendTestNotification(notificationProvider),
            icon: const Icon(Icons.notifications, size: 16),
            label: const Text('Test Bildirimi Gönder'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettingsButton(NotificationProvider notificationProvider) {
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
            'Sistem Ayarları',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Cihazınızın bildirim ayarlarını yönetin.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => notificationProvider.openNotificationSettings(),
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Bildirim Ayarlarını Aç'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _sendTestNotification(NotificationProvider notificationProvider) {
    notificationProvider.sendNotification(
      title: 'Astera Test Bildirimi',
      body: 'Bildirim ayarlarınız çalışıyor! 🎉',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test bildirimi gönderildi'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}