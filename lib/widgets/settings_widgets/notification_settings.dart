import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _anniversaryReminders = true;
  bool _fightReminders = true;
  bool _petCareReminders = true;
  bool _musicNotifications = true;
  bool _dailyReminders = false;
  bool _weeklyReports = true;

  @override
  Widget build(BuildContext context) {
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
                  _pushNotifications,
                  (value) => setState(() => _pushNotifications = value),
                ),
                _buildNotificationItem(
                  'E-posta Bildirimleri',
                  'E-posta ile bildirimler',
                  _emailNotifications,
                  (value) => setState(() => _emailNotifications = value),
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
                  _anniversaryReminders,
                  (value) => setState(() => _anniversaryReminders = value),
                ),
                _buildNotificationItem(
                  'Kavga Hatırlatmaları',
                  'Barışma önerileri',
                  _fightReminders,
                  (value) => setState(() => _fightReminders = value),
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
                  _petCareReminders,
                  (value) => setState(() => _petCareReminders = value),
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
                  _musicNotifications,
                  (value) => setState(() => _musicNotifications = value),
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
                  _dailyReminders,
                  (value) => setState(() => _dailyReminders = value),
                ),
                _buildNotificationItem(
                  'Haftalık Raporlar',
                  'Haftalık ilişki raporları',
                  _weeklyReports,
                  (value) => setState(() => _weeklyReports = value),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Bildirim zamanları
            _buildTimeSettings(),
          ],
        ),
      ),
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

  Widget _buildTimeSettings() {
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
            'Bildirim Zamanları',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector('Sabah', '09:00'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeSelector('Akşam', '20:00'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, String time) {
    return InkWell(
      onTap: () {
        // Zaman seçici aç
        _showTimePicker(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(String label) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time != null) {
        // Zaman güncelleme işlemi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label bildirim zamanı güncellendi'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    });
  }
}
