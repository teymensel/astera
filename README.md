# Astera - Sevgililer İçin Özel Uygulama

Astera, sevgililer için tasarlanmış kapsamlı bir Flutter uygulamasıdır. Spotify entegrasyonu, sağlık takibi, kavga yönetimi ve daha birçok özellik sunar.

## 🌟 Özellikler

### 🎵 Müzik & Eğlence
- **Spotify Entegrasyonu**: Spotify hesabınıza bağlanın ve müzik dinleyin
- **Beraber Dinleme**: Sevgilinizle aynı anda müzik dinleyin
- **Son Çalınanlar**: Son dinlediğiniz şarkıları görün
- **Playlist Yönetimi**: Favori şarkılarınızı organize edin

### 💕 İlişki Yönetimi
- **Eşleşme Sistemi**: Sevgilinizle güvenli bir şekilde eşleşin
- **Yıldönümü Takibi**: Tanışma, evlilik ve doğum günlerini takip edin
- **Birlikte Geçirilen Günler**: Kaç gün birlikte olduğunuzu görün
- **Kavga Yönetimi**: Kavgaları kaydedin ve çözüm süreçlerini takip edin

### 📊 İstatistikler & Analiz
- **İlişki İstatistikleri**: Detaylı analiz ve raporlar
- **Kavga Analizi**: Kavga sıklığı ve çözüm oranları
- **Motivasyon Mesajları**: Kişiselleştirilmiş öneriler

### 🏥 Sağlık & Fitness
- **Google Fit Entegrasyonu**: Sağlık verilerinizi takip edin
- **Mi Band Desteği**: Akıllı saat verilerinizi senkronize edin
- **Uyku Takibi**: Uyku kalitesi ve süresini izleyin
- **Stres Seviyesi**: Günlük stres durumunuzu takip edin

### 🎨 Kişiselleştirme
- **Sanal Evcil Hayvan**: Birlikte büyüttüğünüz sanal bir evcil hayvan
- **Sanal Bebek**: İlişkinizi simgeleyen sanal bir bebek
- **Kişisel Notlar**: Özel anılarınızı kaydedin
- **Yapılacaklar Listesi**: Birlikte yapmak istediğiniz şeyleri planlayın

### 🔔 Bildirimler & Hatırlatmalar
- **Push Notifications**: Önemli hatırlatmalar
- **Yıldönümü Bildirimleri**: Özel günler için hatırlatmalar
- **Barışma Önerileri**: Kavga sonrası çözüm önerileri

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK (3.2.0 veya üzeri)
- Dart SDK
- Android Studio / VS Code
- Git

### Adımlar

1. **Repository'yi klonlayın**
   ```bash
   git clone https://github.com/yourusername/astera.git
   cd astera
   ```

2. **Bağımlılıkları yükleyin**
   ```bash
   flutter pub get
   ```

3. **Uygulamayı çalıştırın**
   ```bash
   flutter run
   ```

## 📱 Platform Desteği

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🛠️ Teknolojiler

### Frontend
- **Flutter**: Cross-platform UI framework
- **Dart**: Programlama dili
- **Provider**: State management
- **Go Router**: Navigation

### Backend & Servisler
- **Spotify SDK**: Müzik entegrasyonu
- **Google Fit API**: Sağlık verileri
- **Firebase**: Push notifications
- **WebSocket**: Real-time iletişim

### Veritabanı
- **SQLite**: Yerel veri saklama
- **SharedPreferences**: Kullanıcı ayarları

## 📦 Kullanılan Paketler

```yaml
dependencies:
  # UI & Navigation
  go_router: ^14.2.0
  flutter_svg: ^2.0.9
  lottie: ^3.1.0
  
  # State Management
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  
  # Spotify Integration
  spotify_sdk: ^3.0.0-dev.3
  
  # Health & Fitness
  health: ^10.1.0
  flutter_blue: ^0.8.0
  
  # WebSocket & Real-time
  web_socket_channel: ^2.4.0
  
  # Push Notifications
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
  flutter_local_notifications: ^16.3.2
  
  # Date & Time
  intl: ^0.19.0
  timeago: ^3.6.1
  
  # Image & Drawing
  image_picker: ^1.0.7
  signature: ^5.0.0
  
  # HTTP & API
  http: ^1.2.0
  dio: ^5.4.0
  
  # Storage
  sqflite: ^2.3.0
  path: ^1.8.3
  
  # Utils
  uuid: ^4.3.3
  permission_handler: ^11.2.0
  device_info_plus: ^9.1.2
```

## 🎨 Tasarım

Astera, modern ve kullanıcı dostu bir tasarıma sahiptir:

- **Renk Paleti**: Pembe, mor ve mavi tonları
- **Gradientler**: Yumuşak geçişler
- **Material Design 3**: Güncel tasarım prensipleri
- **Responsive**: Tüm ekran boyutlarına uyumlu

## 🔧 Yapılandırma

### Spotify API
1. [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)'a gidin
2. Yeni bir uygulama oluşturun
3. Client ID'nizi alın
4. `lib/providers/spotify_provider.dart` dosyasında güncelleyin

### Firebase
1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. Yeni bir proje oluşturun
3. Android/iOS uygulamanızı ekleyin
4. `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ekleyin

## 📱 Ekran Görüntüleri

*Ekran görüntüleri yakında eklenecek*

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add some amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 👥 Geliştirici

**Astera Team**
- Email: contact@astera.app
- Website: https://astera.app

## 🙏 Teşekkürler

- Flutter ekibine harika framework için
- Spotify'a API desteği için
- Google'a sağlık API'leri için
- Tüm açık kaynak topluluğuna

## 📞 Destek

Herhangi bir sorunuz veya öneriniz varsa:

- GitHub Issues: [Issues sayfası](https://github.com/yourusername/astera/issues)
- Email: support@astera.app
- Discord: [Astera Community](https://discord.gg/astera)

---

**Astera ile sevgilinizle birlikte özel anlarınızı paylaşın! 💕**