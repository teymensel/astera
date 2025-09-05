import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isPaired = false;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _partnerId;
  String? _partnerName;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isPaired => _isPaired;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get partnerId => _partnerId;
  String? get partnerName => _partnerName;

  // Kullanıcı giriş yapma
  Future<bool> login(String email, String password) async {
    try {
      // Burada gerçek API çağrısı yapılacak
      // Şimdilik mock data kullanıyoruz
      await Future.delayed(const Duration(seconds: 2));
      
      if (email.isNotEmpty && password.isNotEmpty) {
        _isAuthenticated = true;
        _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        _userName = email.split('@')[0];
        _userEmail = email;
        
        await _saveAuthData();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // Kullanıcı kayıt olma
  Future<bool> register(String name, String email, String password) async {
    try {
      // Burada gerçek API çağrısı yapılacak
      await Future.delayed(const Duration(seconds: 2));
      
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _isAuthenticated = true;
        _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        _userName = name;
        _userEmail = email;
        
        await _saveAuthData();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  // Eşleşme durumu güncelleme
  Future<void> updatePairingStatus(bool isPaired, {String? partnerId, String? partnerName}) async {
    _isPaired = isPaired;
    if (partnerId != null) _partnerId = partnerId;
    if (partnerName != null) _partnerName = partnerName;
    
    await _saveAuthData();
    notifyListeners();
  }

  // Çıkış yapma
  Future<void> logout() async {
    _isAuthenticated = false;
    _isPaired = false;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _partnerId = null;
    _partnerName = null;
    
    await _clearAuthData();
    notifyListeners();
  }

  // Auth verilerini kaydetme
  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', _isAuthenticated);
    await prefs.setBool('isPaired', _isPaired);
    if (_userId != null) await prefs.setString('userId', _userId!);
    if (_userName != null) await prefs.setString('userName', _userName!);
    if (_userEmail != null) await prefs.setString('userEmail', _userEmail!);
    if (_partnerId != null) await prefs.setString('partnerId', _partnerId!);
    if (_partnerName != null) await prefs.setString('partnerName', _partnerName!);
  }

  // Auth verilerini temizleme
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Uygulama başlangıcında auth durumunu kontrol etme
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _isPaired = prefs.getBool('isPaired') ?? false;
    _userId = prefs.getString('userId');
    _userName = prefs.getString('userName');
    _userEmail = prefs.getString('userEmail');
    _partnerId = prefs.getString('partnerId');
    _partnerName = prefs.getString('partnerName');
    
    notifyListeners();
  }
}
