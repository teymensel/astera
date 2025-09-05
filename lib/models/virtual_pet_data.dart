enum PetType { cat, dog, bird, fish, bunny, custom }
enum PetMood { happy, sad, excited, tired, hungry, sick, playful, angry }
enum PetStage { egg, baby, child, teen, adult, elder }

class VirtualPetData {
  final String id;
  final String name;
  final PetType type;
  final PetStage stage;
  final PetMood mood;
  final int level;
  final int experience;
  final int health;
  final int hunger;
  final int happiness;
  final int energy;
  final DateTime birthDate;
  final DateTime lastFed;
  final DateTime lastPlayed;
  final DateTime lastSlept;
  final List<String> unlockedItems;
  final List<String> achievements;
  final String? customImageUrl;
  final Map<String, dynamic> stats;
  final bool isShared;

  VirtualPetData({
    required this.id,
    required this.name,
    required this.type,
    this.stage = PetStage.baby,
    this.mood = PetMood.happy,
    this.level = 1,
    this.experience = 0,
    this.health = 100,
    this.hunger = 100,
    this.happiness = 100,
    this.energy = 100,
    required this.birthDate,
    required this.lastFed,
    required this.lastPlayed,
    required this.lastSlept,
    this.unlockedItems = const [],
    this.achievements = const [],
    this.customImageUrl,
    this.stats = const {},
    this.isShared = false,
  });

  VirtualPetData copyWith({
    String? id,
    String? name,
    PetType? type,
    PetStage? stage,
    PetMood? mood,
    int? level,
    int? experience,
    int? health,
    int? hunger,
    int? happiness,
    int? energy,
    DateTime? birthDate,
    DateTime? lastFed,
    DateTime? lastPlayed,
    DateTime? lastSlept,
    List<String>? unlockedItems,
    List<String>? achievements,
    String? customImageUrl,
    Map<String, dynamic>? stats,
    bool? isShared,
  }) {
    return VirtualPetData(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      stage: stage ?? this.stage,
      mood: mood ?? this.mood,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      health: health ?? this.health,
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      birthDate: birthDate ?? this.birthDate,
      lastFed: lastFed ?? this.lastFed,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      lastSlept: lastSlept ?? this.lastSlept,
      unlockedItems: unlockedItems ?? this.unlockedItems,
      achievements: achievements ?? this.achievements,
      customImageUrl: customImageUrl ?? this.customImageUrl,
      stats: stats ?? this.stats,
      isShared: isShared ?? this.isShared,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'stage': stage.name,
      'mood': mood.name,
      'level': level,
      'experience': experience,
      'health': health,
      'hunger': hunger,
      'happiness': happiness,
      'energy': energy,
      'birthDate': birthDate.toIso8601String(),
      'lastFed': lastFed.toIso8601String(),
      'lastPlayed': lastPlayed.toIso8601String(),
      'lastSlept': lastSlept.toIso8601String(),
      'unlockedItems': unlockedItems,
      'achievements': achievements,
      'customImageUrl': customImageUrl,
      'stats': stats,
      'isShared': isShared,
    };
  }

  factory VirtualPetData.fromJson(Map<String, dynamic> json) {
    return VirtualPetData(
      id: json['id'] as String,
      name: json['name'] as String,
      type: PetType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PetType.cat,
      ),
      stage: PetStage.values.firstWhere(
        (e) => e.name == json['stage'],
        orElse: () => PetStage.baby,
      ),
      mood: PetMood.values.firstWhere(
        (e) => e.name == json['mood'],
        orElse: () => PetMood.happy,
      ),
      level: json['level'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      health: json['health'] as int? ?? 100,
      hunger: json['hunger'] as int? ?? 100,
      happiness: json['happiness'] as int? ?? 100,
      energy: json['energy'] as int? ?? 100,
      birthDate: DateTime.parse(json['birthDate'] as String),
      lastFed: DateTime.parse(json['lastFed'] as String),
      lastPlayed: DateTime.parse(json['lastPlayed'] as String),
      lastSlept: DateTime.parse(json['lastSlept'] as String),
      unlockedItems: (json['unlockedItems'] as List<dynamic>?)?.cast<String>() ?? [],
      achievements: (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
      customImageUrl: json['customImageUrl'] as String?,
      stats: Map<String, dynamic>.from(json['stats'] as Map? ?? {}),
      isShared: json['isShared'] as bool? ?? false,
    );
  }

  // Pet türü ikonu
  String get typeIcon {
    switch (type) {
      case PetType.cat:
        return '🐱';
      case PetType.dog:
        return '🐶';
      case PetType.bird:
        return '🐦';
      case PetType.fish:
        return '🐠';
      case PetType.bunny:
        return '🐰';
      case PetType.custom:
        return '🎭';
    }
  }

  // Ruh hali ikonu
  String get moodIcon {
    switch (mood) {
      case PetMood.happy:
        return '😊';
      case PetMood.sad:
        return '😢';
      case PetMood.excited:
        return '🤩';
      case PetMood.tired:
        return '😴';
      case PetMood.hungry:
        return '🤤';
      case PetMood.sick:
        return '🤒';
      case PetMood.playful:
        return '😄';
      case PetMood.angry:
        return '😠';
    }
  }

  // Yaş (gün)
  int get ageInDays => DateTime.now().difference(birthDate).inDays;

  // Genel sağlık durumu
  double get overallHealth {
    return (health + hunger + happiness + energy) / 4.0;
  }

  // Bir sonraki seviyeye kaç XP kaldı?
  int get experienceToNextLevel {
    return (level * 100) - experience;
  }

  // Seviye ilerlemesi (0-1 arası)
  double get levelProgress {
    final currentLevelExp = (level - 1) * 100;
    final nextLevelExp = level * 100;
    final currentExp = experience - currentLevelExp;
    final totalExpNeeded = nextLevelExp - currentLevelExp;
    return currentExp / totalExpNeeded;
  }

  // Acıktı mı?
  bool get isHungry => hunger < 30;

  // Yorgun mu?
  bool get isTired => energy < 20;

  // Mutlu mu?
  bool get isHappy => happiness > 70;

  // Hasta mı?
  bool get isSick => health < 30;

  // Bakım gerekli mi?
  bool get needsCare {
    return isHungry || isTired || !isHappy || isSick;
  }

  // Son beslenme zamanı
  Duration get timeSinceLastFed => DateTime.now().difference(lastFed);

  // Son oyun zamanı
  Duration get timeSinceLastPlayed => DateTime.now().difference(lastPlayed);

  // Son uyku zamanı
  Duration get timeSinceLastSlept => DateTime.now().difference(lastSlept);
}
