class NoteData {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final List<String> tags;
  final bool isShared;
  final String? sharedWith;

  NoteData({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.tags = const [],
    this.isShared = false,
    this.sharedWith,
  });

  NoteData copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    List<String>? tags,
    bool? isShared,
    String? sharedWith,
  }) {
    return NoteData(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isShared: isShared ?? this.isShared,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'tags': tags,
      'isShared': isShared,
      'sharedWith': sharedWith,
    };
  }

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isShared: json['isShared'] as bool? ?? false,
      sharedWith: json['sharedWith'] as String?,
    );
  }

  // Not uzunluğu
  int get contentLength => content.length;
  
  // Kelime sayısı
  int get wordCount => content.split(' ').where((word) => word.isNotEmpty).length;
  
  // Okuma süresi (dakika)
  int get readingTimeMinutes => (wordCount / 200).ceil(); // Ortalama 200 kelime/dakika
  
  // Son güncelleme zamanı
  Duration get timeSinceUpdate => DateTime.now().difference(updatedAt);
  
  // Güncel mi? (24 saat içinde güncellenmiş)
  bool get isRecent => timeSinceUpdate.inHours < 24;
}
