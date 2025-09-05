import 'package:flutter/foundation.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyProvider extends ChangeNotifier {
  bool _isConnected = false;
  bool _isPlaying = false;
  String? _currentTrackId;
  String? _currentTrackName;
  String? _currentArtist;
  String? _currentAlbum;
  String? _currentImageUrl;
  int _currentPosition = 0;
  int _duration = 0;
  bool _isShuffling = false;
  bool _isRepeating = false;
  List<Map<String, dynamic>> _recentTracks = [];
  List<Map<String, dynamic>> _playlists = [];

  // Getters
  bool get isConnected => _isConnected;
  bool get isPlaying => _isPlaying;
  String? get currentTrackId => _currentTrackId;
  String? get currentTrackName => _currentTrackName;
  String? get currentArtist => _currentArtist;
  String? get currentAlbum => _currentAlbum;
  String? get currentImageUrl => _currentImageUrl;
  int get currentPosition => _currentPosition;
  int get duration => _duration;
  bool get isShuffling => _isShuffling;
  bool get isRepeating => _isRepeating;
  List<Map<String, dynamic>> get recentTracks => _recentTracks;
  List<Map<String, dynamic>> get playlists => _playlists;

  // Spotify'a bağlanma
  Future<bool> connectToSpotify() async {
    try {
      final result = await SpotifySdk.connectToSpotifyRemote(
        clientId: 'YOUR_SPOTIFY_CLIENT_ID', // Bu değer gerçek client ID ile değiştirilecek
        redirectUrl: 'astera://callback',
        scope: 'app-remote-control,user-read-playback-state,user-modify-playback-state,user-read-currently-playing,playlist-read-private,playlist-read-collaborative,user-library-read,user-top-read,user-read-recently-played',
      );
      
      _isConnected = result;
      if (_isConnected) {
        await _loadUserData();
      }
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Spotify connection error: $e');
      return false;
    }
  }

  // Spotify'dan bağlantıyı kesme
  Future<void> disconnectFromSpotify() async {
    try {
      await SpotifySdk.disconnect();
      _isConnected = false;
      _isPlaying = false;
      _currentTrackId = null;
      _currentTrackName = null;
      _currentArtist = null;
      _currentAlbum = null;
      _currentImageUrl = null;
      _currentPosition = 0;
      _duration = 0;
      _isShuffling = false;
      _isRepeating = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Spotify disconnection error: $e');
    }
  }

  // Kullanıcı verilerini yükleme
  Future<void> _loadUserData() async {
    if (!_isConnected) return;

    try {
      // Son çalınan şarkıları yükle
      await _loadRecentTracks();
      
      // Playlist'leri yükle
      await _loadPlaylists();
      
      // Mevcut çalma durumunu yükle
      await _loadCurrentPlaybackState();
    } catch (e) {
      debugPrint('Load user data error: $e');
    }
  }

  // Son çalınan şarkıları yükleme
  Future<void> _loadRecentTracks() async {
    try {
      // Burada Spotify API'den son çalınan şarkıları alacak
      // Şimdilik mock data
      _recentTracks = [
        {
          'id': '1',
          'name': 'Love Story',
          'artist': 'Taylor Swift',
          'album': 'Fearless',
          'imageUrl': 'https://via.placeholder.com/300x300',
          'playedAt': DateTime.now().subtract(const Duration(hours: 1)),
        },
        {
          'id': '2',
          'name': 'Perfect',
          'artist': 'Ed Sheeran',
          'album': '÷ (Divide)',
          'imageUrl': 'https://via.placeholder.com/300x300',
          'playedAt': DateTime.now().subtract(const Duration(hours: 2)),
        },
      ];
      notifyListeners();
    } catch (e) {
      debugPrint('Load recent tracks error: $e');
    }
  }

  // Playlist'leri yükleme
  Future<void> _loadPlaylists() async {
    try {
      // Burada Spotify API'den playlist'leri alacak
      // Şimdilik mock data
      _playlists = [
        {
          'id': '1',
          'name': 'Liked Songs',
          'description': 'Beğenilen şarkılar',
          'imageUrl': 'https://via.placeholder.com/300x300',
          'trackCount': 150,
        },
        {
          'id': '2',
          'name': 'Romantic Songs',
          'description': 'Romantik şarkılar',
          'imageUrl': 'https://via.placeholder.com/300x300',
          'trackCount': 75,
        },
      ];
      notifyListeners();
    } catch (e) {
      debugPrint('Load playlists error: $e');
    }
  }

  // Mevcut çalma durumunu yükleme
  Future<void> _loadCurrentPlaybackState() async {
    try {
      if (!_isConnected) return;

      // Burada Spotify API'den mevcut çalma durumunu alacak
      // Şimdilik mock data
      _isPlaying = true;
      _currentTrackId = 'current_track_id';
      _currentTrackName = 'Current Song';
      _currentArtist = 'Current Artist';
      _currentAlbum = 'Current Album';
      _currentImageUrl = 'https://via.placeholder.com/300x300';
      _currentPosition = 120000; // 2 dakika
      _duration = 240000; // 4 dakika
      notifyListeners();
    } catch (e) {
      debugPrint('Load playback state error: $e');
    }
  }

  // Çalma/durdurma
  Future<void> togglePlayPause() async {
    try {
      if (!_isConnected) return;

      if (_isPlaying) {
        await SpotifySdk.pause();
        _isPlaying = false;
      } else {
        await SpotifySdk.resume();
        _isPlaying = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Toggle play/pause error: $e');
    }
  }

  // Sonraki şarkı
  Future<void> skipNext() async {
    try {
      if (!_isConnected) return;
      await SpotifySdk.skipNext();
      await _loadCurrentPlaybackState();
    } catch (e) {
      debugPrint('Skip next error: $e');
    }
  }

  // Önceki şarkı
  Future<void> skipPrevious() async {
    try {
      if (!_isConnected) return;
      await SpotifySdk.skipPrevious();
      await _loadCurrentPlaybackState();
    } catch (e) {
      debugPrint('Skip previous error: $e');
    }
  }

  // Karışık çalma
  Future<void> toggleShuffle() async {
    try {
      if (!_isConnected) return;
      _isShuffling = !_isShuffling;
      await SpotifySdk.setShuffle(shuffle: _isShuffling);
      notifyListeners();
    } catch (e) {
      debugPrint('Toggle shuffle error: $e');
    }
  }

  // Tekrar etme
  Future<void> toggleRepeat() async {
    try {
      if (!_isConnected) return;
      _isRepeating = !_isRepeating;
      await SpotifySdk.setRepeatMode(repeatMode: _isRepeating ? 1 : 0);
      notifyListeners();
    } catch (e) {
      debugPrint('Toggle repeat error: $e');
    }
  }

  // Şarkı arama
  Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    try {
      if (!_isConnected) return [];

      // Burada Spotify API'den şarkı arama yapılacak
      // Şimdilik mock data
      return [
        {
          'id': 'search_1',
          'name': 'Search Result 1',
          'artist': 'Artist 1',
          'album': 'Album 1',
          'imageUrl': 'https://via.placeholder.com/300x300',
        },
        {
          'id': 'search_2',
          'name': 'Search Result 2',
          'artist': 'Artist 2',
          'album': 'Album 2',
          'imageUrl': 'https://via.placeholder.com/300x300',
        },
      ];
    } catch (e) {
      debugPrint('Search tracks error: $e');
      return [];
    }
  }

  // Şarkı çalma
  Future<void> playTrack(String trackId) async {
    try {
      if (!_isConnected) return;
      await SpotifySdk.play(spotifyUri: 'spotify:track:$trackId');
      await _loadCurrentPlaybackState();
    } catch (e) {
      debugPrint('Play track error: $e');
    }
  }
}
