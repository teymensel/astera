import 'package:flutter/foundation.dart';
import '../models/note_data.dart';

class NotesProvider extends ChangeNotifier {
  List<NoteData> _notes = [];
  List<NoteData> _sharedNotes = [];
  String _searchQuery = '';
  List<String> _selectedTags = [];
  String _sortBy = 'updatedAt'; // createdAt, updatedAt, title, contentLength
  bool _sortAscending = false;

  // Getters
  List<NoteData> get notes => _getFilteredNotes();
  List<NoteData> get sharedNotes => _sharedNotes;
  String get searchQuery => _searchQuery;
  List<String> get selectedTags => _selectedTags;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;

  // Filtrelenmiş notları getir
  List<NoteData> _getFilteredNotes() {
    List<NoteData> filteredNotes = List.from(_notes);

    // Arama filtresi
    if (_searchQuery.isNotEmpty) {
      filteredNotes = filteredNotes.where((note) {
        return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               note.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               note.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Tag filtresi
    if (_selectedTags.isNotEmpty) {
      filteredNotes = filteredNotes.where((note) {
        return _selectedTags.every((tag) => note.tags.contains(tag));
      }).toList();
    }

    // Sıralama
    filteredNotes.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'updatedAt':
          comparison = a.updatedAt.compareTo(b.updatedAt);
          break;
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'contentLength':
          comparison = a.contentLength.compareTo(b.contentLength);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filteredNotes;
  }

  // Not ekleme
  void addNote(NoteData note) {
    _notes.add(note);
    notifyListeners();
  }

  // Not güncelleme
  void updateNote(NoteData note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  // Not silme
  void deleteNote(String noteId) {
    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }

  // Not paylaşma
  void shareNote(String noteId, String partnerId) {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        isShared: true,
        sharedWith: partnerId,
      );
      notifyListeners();
    }
  }

  // Paylaşılan notu kaldırma
  void unshareNote(String noteId) {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        isShared: false,
        sharedWith: null,
      );
      notifyListeners();
    }
  }

  // Arama sorgusu güncelleme
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Tag seçimi güncelleme
  void updateSelectedTags(List<String> tags) {
    _selectedTags = tags;
    notifyListeners();
  }

  // Sıralama güncelleme
  void updateSorting(String sortBy, bool ascending) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    notifyListeners();
  }

  // Tüm tag'leri getir
  List<String> getAllTags() {
    final allTags = <String>{};
    for (final note in _notes) {
      allTags.addAll(note.tags);
    }
    return allTags.toList()..sort();
  }

  // İstatistikler
  int get totalNotes => _notes.length;
  int get sharedNotesCount => _notes.where((n) => n.isShared).length;
  int get totalWords => _notes.fold(0, (sum, note) => sum + note.wordCount);
  int get totalCharacters => _notes.fold(0, (sum, note) => sum + note.contentLength);

  // En çok kullanılan tag'ler
  List<MapEntry<String, int>> get mostUsedTags {
    final tagCounts = <String, int>{};
    for (final note in _notes) {
      for (final tag in note.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    final entries = tagCounts.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(10).toList();
  }

  // Son güncellenen notlar
  List<NoteData> get recentlyUpdatedNotes {
    final sortedNotes = List<NoteData>.from(_notes);
    sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedNotes.take(5).toList();
  }

  // Favori notlar (en çok güncellenen)
  List<NoteData> get favoriteNotes {
    final sortedNotes = List<NoteData>.from(_notes);
    sortedNotes.sort((a, b) {
      final aUpdates = a.timeSinceUpdate.inDays;
      final bUpdates = b.timeSinceUpdate.inDays;
      return aUpdates.compareTo(bUpdates);
    });
    return sortedNotes.take(5).toList();
  }

  // Not arama
  List<NoteData> searchNotes(String query) {
    if (query.isEmpty) return _notes;
    
    return _notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
             note.content.toLowerCase().contains(query.toLowerCase()) ||
             note.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Notları temizle
  void clearNotes() {
    _notes.clear();
    _sharedNotes.clear();
    notifyListeners();
  }

  // Notları yükle (veritabanından)
  void loadNotes(List<NoteData> notes) {
    _notes = notes;
    notifyListeners();
  }

  // Notları kaydet (veritabanına)
  List<NoteData> getNotesToSave() {
    return _notes;
  }
}
