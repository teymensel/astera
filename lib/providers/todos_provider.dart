import 'package:flutter/foundation.dart';
import '../models/todo_data.dart';

class TodosProvider extends ChangeNotifier {
  List<TodoData> _todos = [];
  List<TodoData> _sharedTodos = [];
  String _searchQuery = '';
  List<String> _selectedTags = [];
  List<TodoStatus> _selectedStatuses = [];
  List<TodoPriority> _selectedPriorities = [];
  String _sortBy = 'createdAt'; // createdAt, dueDate, priority, title
  bool _sortAscending = false;
  String? _selectedCategory;

  // Getters
  List<TodoData> get todos => _getFilteredTodos();
  List<TodoData> get sharedTodos => _sharedTodos;
  String get searchQuery => _searchQuery;
  List<String> get selectedTags => _selectedTags;
  List<TodoStatus> get selectedStatuses => _selectedStatuses;
  List<TodoPriority> get selectedPriorities => _selectedPriorities;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  String? get selectedCategory => _selectedCategory;

  // Filtrelenmiş todo'ları getir
  List<TodoData> _getFilteredTodos() {
    List<TodoData> filteredTodos = List.from(_todos);

    // Arama filtresi
    if (_searchQuery.isNotEmpty) {
      filteredTodos = filteredTodos.where((todo) {
        return todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (todo.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
               todo.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Tag filtresi
    if (_selectedTags.isNotEmpty) {
      filteredTodos = filteredTodos.where((todo) {
        return _selectedTags.every((tag) => todo.tags.contains(tag));
      }).toList();
    }

    // Durum filtresi
    if (_selectedStatuses.isNotEmpty) {
      filteredTodos = filteredTodos.where((todo) {
        return _selectedStatuses.contains(todo.status);
      }).toList();
    }

    // Öncelik filtresi
    if (_selectedPriorities.isNotEmpty) {
      filteredTodos = filteredTodos.where((todo) {
        return _selectedPriorities.contains(todo.priority);
      }).toList();
    }

    // Kategori filtresi
    if (_selectedCategory != null) {
      filteredTodos = filteredTodos.where((todo) {
        return todo.category == _selectedCategory;
      }).toList();
    }

    // Sıralama
    filteredTodos.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'dueDate':
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          comparison = a.dueDate!.compareTo(b.dueDate!);
          break;
        case 'priority':
          comparison = a.priority.index.compareTo(b.priority.index);
          break;
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filteredTodos;
  }

  // Todo ekleme
  void addTodo(TodoData todo) {
    _todos.add(todo);
    notifyListeners();
  }

  // Todo güncelleme
  void updateTodo(TodoData todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      notifyListeners();
    }
  }

  // Todo silme
  void deleteTodo(String todoId) {
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  // Todo durumu güncelleme
  void updateTodoStatus(String todoId, TodoStatus status) {
    final index = _todos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        status: status,
        completedAt: status == TodoStatus.completed ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  // Todo paylaşma
  void shareTodo(String todoId, String partnerId) {
    final index = _todos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isShared: true,
        assignedTo: partnerId,
      );
      notifyListeners();
    }
  }

  // Paylaşılan todo'yu kaldırma
  void unshareTodo(String todoId) {
    final index = _todos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isShared: false,
        assignedTo: null,
      );
      notifyListeners();
    }
  }

  // Filtreleri güncelleme
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSelectedTags(List<String> tags) {
    _selectedTags = tags;
    notifyListeners();
  }

  void updateSelectedStatuses(List<TodoStatus> statuses) {
    _selectedStatuses = statuses;
    notifyListeners();
  }

  void updateSelectedPriorities(List<TodoPriority> priorities) {
    _selectedPriorities = priorities;
    notifyListeners();
  }

  void updateSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSorting(String sortBy, bool ascending) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    notifyListeners();
  }

  // Tüm tag'leri getir
  List<String> getAllTags() {
    final allTags = <String>{};
    for (final todo in _todos) {
      allTags.addAll(todo.tags);
    }
    return allTags.toList()..sort();
  }

  // Tüm kategorileri getir
  List<String> getAllCategories() {
    final allCategories = <String>{};
    for (final todo in _todos) {
      if (todo.category != null) {
        allCategories.add(todo.category!);
      }
    }
    return allCategories.toList()..sort();
  }

  // İstatistikler
  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((t) => t.status == TodoStatus.completed).length;
  int get pendingTodos => _todos.where((t) => t.status == TodoStatus.pending).length;
  int get inProgressTodos => _todos.where((t) => t.status == TodoStatus.inProgress).length;
  int get overdueTodos => _todos.where((t) => t.isOverdue).length;
  int get sharedTodosCount => _todos.where((t) => t.isShared).length;

  // Tamamlanma yüzdesi
  double get completionPercentage {
    if (_todos.isEmpty) return 0.0;
    return (completedTodos / totalTodos) * 100;
  }

  // Bugünkü todo'lar
  List<TodoData> get todayTodos {
    final today = DateTime.now();
    return _todos.where((todo) {
      if (todo.dueDate == null) return false;
      return todo.dueDate!.year == today.year &&
             todo.dueDate!.month == today.month &&
             todo.dueDate!.day == today.day;
    }).toList();
  }

  // Bu haftaki todo'lar
  List<TodoData> get thisWeekTodos {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return _todos.where((todo) {
      if (todo.dueDate == null) return false;
      return todo.dueDate!.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
             todo.dueDate!.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }

  // Öncelik dağılımı
  Map<TodoPriority, int> get priorityDistribution {
    final distribution = <TodoPriority, int>{};
    for (final priority in TodoPriority.values) {
      distribution[priority] = _todos.where((t) => t.priority == priority).length;
    }
    return distribution;
  }

  // Durum dağılımı
  Map<TodoStatus, int> get statusDistribution {
    final distribution = <TodoStatus, int>{};
    for (final status in TodoStatus.values) {
      distribution[status] = _todos.where((t) => t.status == status).length;
    }
    return distribution;
  }

  // En çok kullanılan tag'ler
  List<MapEntry<String, int>> get mostUsedTags {
    final tagCounts = <String, int>{};
    for (final todo in _todos) {
      for (final tag in todo.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    final entries = tagCounts.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(10).toList();
  }

  // Todo'ları temizle
  void clearTodos() {
    _todos.clear();
    _sharedTodos.clear();
    notifyListeners();
  }

  // Todo'ları yükle (veritabanından)
  void loadTodos(List<TodoData> todos) {
    _todos = todos;
    notifyListeners();
  }

  // Todo'ları kaydet (veritabanına)
  List<TodoData> getTodosToSave() {
    return _todos;
  }
}
