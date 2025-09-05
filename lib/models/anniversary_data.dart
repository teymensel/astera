enum AnniversaryType {
  meeting,
  marriage,
  birthday,
  custom,
}

class AnniversaryData {
  final String id;
  final String title;
  final DateTime date;
  final AnniversaryType type;
  final String? description;
  final String? imageUrl;
  final bool isRecurring;
  final int? reminderDays; // Kaç gün önceden hatırlatılacak

  AnniversaryData({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.description,
    this.imageUrl,
    this.isRecurring = true,
    this.reminderDays,
  });

  AnniversaryData copyWith({
    String? id,
    String? title,
    DateTime? date,
    AnniversaryType? type,
    String? description,
    String? imageUrl,
    bool? isRecurring,
    int? reminderDays,
  }) {
    return AnniversaryData(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isRecurring: isRecurring ?? this.isRecurring,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'type': type.name,
      'description': description,
      'imageUrl': imageUrl,
      'isRecurring': isRecurring,
      'reminderDays': reminderDays,
    };
  }

  factory AnniversaryData.fromJson(Map<String, dynamic> json) {
    return AnniversaryData(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      type: AnniversaryType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnniversaryType.custom,
      ),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? true,
      reminderDays: json['reminderDays'] as int?,
    );
  }

  // Bu yılki yıldönümü tarihi
  DateTime getThisYearAnniversary() {
    final now = DateTime.now();
    return DateTime(now.year, date.month, date.day);
  }

  // Gelecek yılki yıldönümü tarihi
  DateTime getNextYearAnniversary() {
    final now = DateTime.now();
    return DateTime(now.year + 1, date.month, date.day);
  }

  // Yıldönümüne kalan gün sayısı
  int getDaysUntilAnniversary() {
    final now = DateTime.now();
    final thisYear = getThisYearAnniversary();
    
    if (thisYear.isAfter(now)) {
      return thisYear.difference(now).inDays;
    } else {
      return getNextYearAnniversary().difference(now).inDays;
    }
  }

  // Yıldönümü geçti mi?
  bool get isPassedThisYear {
    final now = DateTime.now();
    final thisYear = getThisYearAnniversary();
    return thisYear.isBefore(now);
  }

  // Yıldönümü bugün mü?
  bool get isToday {
    final now = DateTime.now();
    final thisYear = getThisYearAnniversary();
    return thisYear.year == now.year &&
           thisYear.month == now.month &&
           thisYear.day == now.day;
  }

  // Yıldönümü yaklaşıyor mu? (7 gün içinde)
  bool get isApproaching {
    return getDaysUntilAnniversary() <= 7 && !isPassedThisYear;
  }

  // Yıldönümü türü ikonu
  String get typeIcon {
    switch (type) {
      case AnniversaryType.meeting:
        return '💕';
      case AnniversaryType.marriage:
        return '💍';
      case AnniversaryType.birthday:
        return '🎂';
      case AnniversaryType.custom:
        return '🎉';
    }
  }

  // Yıldönümü türü rengi
  String get typeColor {
    switch (type) {
      case AnniversaryType.meeting:
        return '#E91E63'; // Pembe
      case AnniversaryType.marriage:
        return '#9C27B0'; // Mor
      case AnniversaryType.birthday:
        return '#FF9800'; // Turuncu
      case AnniversaryType.custom:
        return '#2196F3'; // Mavi
    }
  }
}
