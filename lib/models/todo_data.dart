enum TodoPriority { low, medium, high, urgent }
enum TodoStatus { pending, inProgress, completed, cancelled }

class TodoData {
  final String id;
  final String title;
  final String? description;
  final TodoPriority priority;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<String> tags;
  final bool isShared;
  final String? assignedTo;
  final String? createdBy;
  final List<String> subtasks;
  final String? category;

  TodoData({
    required this.id,
    required this.title,
    this.description,
    this.priority = TodoPriority.medium,
    this.status = TodoStatus.pending,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
    this.isShared = false,
    this.assignedTo,
    this.createdBy,
    this.subtasks = const [],
    this.category,
  });

  TodoData copyWith({
    String? id,
    String? title,
    String? description,
    TodoPriority? priority,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
    bool? isShared,
    String? assignedTo,
    String? createdBy,
    List<String>? subtasks,
    String? category,
  }) {
    return TodoData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      isShared: isShared ?? this.isShared,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      subtasks: subtasks ?? this.subtasks,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'tags': tags,
      'isShared': isShared,
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'subtasks': subtasks,
      'category': category,
    };
  }

  factory TodoData.fromJson(Map<String, dynamic> json) {
    return TodoData(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: TodoPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TodoPriority.medium,
      ),
      status: TodoStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TodoStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isShared: json['isShared'] as bool? ?? false,
      assignedTo: json['assignedTo'] as String?,
      createdBy: json['createdBy'] as String?,
      subtasks: (json['subtasks'] as List<dynamic>?)?.cast<String>() ?? [],
      category: json['category'] as String?,
    );
  }

  // Öncelik rengi
  String get priorityColor {
    switch (priority) {
      case TodoPriority.low:
        return '#4CAF50'; // Yeşil
      case TodoPriority.medium:
        return '#FF9800'; // Turuncu
      case TodoPriority.high:
        return '#F44336'; // Kırmızı
      case TodoPriority.urgent:
        return '#9C27B0'; // Mor
    }
  }

  // Öncelik ikonu
  String get priorityIcon {
    switch (priority) {
      case TodoPriority.low:
        return '🟢';
      case TodoPriority.medium:
        return '🟡';
      case TodoPriority.high:
        return '🟠';
      case TodoPriority.urgent:
        return '🔴';
    }
  }

  // Durum rengi
  String get statusColor {
    switch (status) {
      case TodoStatus.pending:
        return '#757575'; // Gri
      case TodoStatus.inProgress:
        return '#2196F3'; // Mavi
      case TodoStatus.completed:
        return '#4CAF50'; // Yeşil
      case TodoStatus.cancelled:
        return '#F44336'; // Kırmızı
    }
  }

  // Durum ikonu
  String get statusIcon {
    switch (status) {
      case TodoStatus.pending:
        return '⏳';
      case TodoStatus.inProgress:
        return '🔄';
      case TodoStatus.completed:
        return '✅';
      case TodoStatus.cancelled:
        return '❌';
    }
  }

  // Süre doldu mu?
  bool get isOverdue {
    if (dueDate == null || status == TodoStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  // Kaç gün kaldı?
  int? get daysUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  // Tamamlanma yüzdesi (alt görevler dahil)
  double get completionPercentage {
    if (subtasks.isEmpty) {
      return status == TodoStatus.completed ? 100.0 : 0.0;
    }
    // Alt görevlerin tamamlanma oranı hesaplanacak
    return 0.0; // Şimdilik basit implementasyon
  }
}
