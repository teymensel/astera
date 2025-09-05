class FightData {
  final String id;
  final String reason;
  final String description;
  final DateTime date;
  final bool isResolved;
  final String? resolution;
  final DateTime? resolutionDate;
  final String? whoWasRight;
  final String? solution;
  final int severity; // 1-5 arası şiddet seviyesi
  final List<String> tags;

  FightData({
    required this.id,
    required this.reason,
    required this.description,
    required this.date,
    this.isResolved = false,
    this.resolution,
    this.resolutionDate,
    this.whoWasRight,
    this.solution,
    this.severity = 1,
    this.tags = const [],
  });

  FightData copyWith({
    String? id,
    String? reason,
    String? description,
    DateTime? date,
    bool? isResolved,
    String? resolution,
    DateTime? resolutionDate,
    String? whoWasRight,
    String? solution,
    int? severity,
    List<String>? tags,
  }) {
    return FightData(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      date: date ?? this.date,
      isResolved: isResolved ?? this.isResolved,
      resolution: resolution ?? this.resolution,
      resolutionDate: resolutionDate ?? this.resolutionDate,
      whoWasRight: whoWasRight ?? this.whoWasRight,
      solution: solution ?? this.solution,
      severity: severity ?? this.severity,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'description': description,
      'date': date.toIso8601String(),
      'isResolved': isResolved,
      'resolution': resolution,
      'resolutionDate': resolutionDate?.toIso8601String(),
      'whoWasRight': whoWasRight,
      'solution': solution,
      'severity': severity,
      'tags': tags,
    };
  }

  factory FightData.fromJson(Map<String, dynamic> json) {
    return FightData(
      id: json['id'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      isResolved: json['isResolved'] as bool? ?? false,
      resolution: json['resolution'] as String?,
      resolutionDate: json['resolutionDate'] != null 
          ? DateTime.parse(json['resolutionDate'] as String)
          : null,
      whoWasRight: json['whoWasRight'] as String?,
      solution: json['solution'] as String?,
      severity: json['severity'] as int? ?? 1,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  // Kavga süresini hesaplama (çözüldüyse)
  Duration? get fightDuration {
    if (!isResolved || resolutionDate == null) return null;
    return resolutionDate!.difference(date);
  }

  // Kavga süresini gün olarak hesaplama
  int? get fightDurationInDays {
    final duration = fightDuration;
    return duration?.inDays;
  }

  // Şiddet seviyesi metni
  String get severityText {
    switch (severity) {
      case 1:
        return 'Çok Hafif';
      case 2:
        return 'Hafif';
      case 3:
        return 'Orta';
      case 4:
        return 'Şiddetli';
      case 5:
        return 'Çok Şiddetli';
      default:
        return 'Bilinmiyor';
    }
  }

  // Şiddet seviyesi rengi
  String get severityColor {
    switch (severity) {
      case 1:
        return '#2ECC71'; // Yeşil
      case 2:
        return '#F39C12'; // Turuncu
      case 3:
        return '#E67E22'; // Koyu turuncu
      case 4:
        return '#E74C3C'; // Kırmızı
      case 5:
        return '#8E44AD'; // Mor
      default:
        return '#95A5A6'; // Gri
    }
  }
}
