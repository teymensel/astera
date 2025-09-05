import 'package:flutter/foundation.dart';
import '../models/virtual_pet_data.dart';

class VirtualPetProvider extends ChangeNotifier {
  VirtualPetData? _pet;
  bool _isFeeding = false;
  bool _isPlaying = false;
  bool _isSleeping = false;
  DateTime? _lastUpdateTime;

  // Getters
  VirtualPetData? get pet => _pet;
  bool get isFeeding => _isFeeding;
  bool get isPlaying => _isPlaying;
  bool get isSleeping => _isSleeping;
  bool get hasPet => _pet != null;

  // Pet oluşturma
  void createPet({
    required String name,
    required PetType type,
    String? customImageUrl,
  }) {
    final now = DateTime.now();
    _pet = VirtualPetData(
      id: 'pet_${now.millisecondsSinceEpoch}',
      name: name,
      type: type,
      birthDate: now,
      lastFed: now,
      lastPlayed: now,
      lastSlept: now,
      customImageUrl: customImageUrl,
    );
    _lastUpdateTime = now;
    notifyListeners();
  }

  // Pet besleme
  Future<void> feedPet() async {
    if (_pet == null || _isFeeding) return;

    _isFeeding = true;
    notifyListeners();

    // Besleme animasyonu için bekle
    await Future.delayed(const Duration(seconds: 2));

    if (_pet != null) {
      _pet = _pet!.copyWith(
        hunger: (_pet!.hunger + 30).clamp(0, 100),
        happiness: (_pet!.happiness + 10).clamp(0, 100),
        lastFed: DateTime.now(),
        mood: _pet!.hunger < 30 ? PetMood.happy : _pet!.mood,
      );
      _updatePetStats();
    }

    _isFeeding = false;
    notifyListeners();
  }

  // Pet ile oynama
  Future<void> playWithPet() async {
    if (_pet == null || _isPlaying) return;

    _isPlaying = true;
    notifyListeners();

    // Oyun animasyonu için bekle
    await Future.delayed(const Duration(seconds: 3));

    if (_pet != null) {
      _pet = _pet!.copyWith(
        happiness: (_pet!.happiness + 20).clamp(0, 100),
        energy: (_pet!.energy - 15).clamp(0, 100),
        lastPlayed: DateTime.now(),
        mood: PetMood.playful,
      );
      _updatePetStats();
      _checkLevelUp();
    }

    _isPlaying = false;
    notifyListeners();
  }

  // Pet uyutma
  Future<void> putPetToSleep() async {
    if (_pet == null || _isSleeping) return;

    _isSleeping = true;
    notifyListeners();

    // Uyku animasyonu için bekle
    await Future.delayed(const Duration(seconds: 4));

    if (_pet != null) {
      _pet = _pet!.copyWith(
        energy: 100,
        health: (_pet!.health + 10).clamp(0, 100),
        lastSlept: DateTime.now(),
        mood: PetMood.tired,
      );
      _updatePetStats();
    }

    _isSleeping = false;
    notifyListeners();
  }

  // Pet bakımı
  Future<void> careForPet() async {
    if (_pet == null) return;

    _pet = _pet!.copyWith(
      health: 100,
      mood: PetMood.happy,
    );
    _updatePetStats();
    notifyListeners();
  }

  // Pet istatistiklerini güncelle
  void _updatePetStats() {
    if (_pet == null) return;

    final now = DateTime.now();
    final timeSinceLastUpdate = _lastUpdateTime != null 
        ? now.difference(_lastUpdateTime!).inHours 
        : 0;

    // Zaman geçtikçe değerler azalır
    if (timeSinceLastUpdate > 0) {
      final hungerDecrease = timeSinceLastUpdate * 2;
      final happinessDecrease = timeSinceLastUpdate;
      final energyDecrease = timeSinceLastUpdate * 1.5;

      _pet = _pet!.copyWith(
        hunger: (_pet!.hunger - hungerDecrease).clamp(0, 100),
        happiness: (_pet!.happiness - happinessDecrease).clamp(0, 100),
        energy: (_pet!.energy - energyDecrease).clamp(0, 100),
      );

      // Ruh halini güncelle
      _updatePetMood();
    }

    _lastUpdateTime = now;
  }

  // Pet ruh halini güncelle
  void _updatePetMood() {
    if (_pet == null) return;

    PetMood newMood = _pet!.mood;

    if (_pet!.isSick) {
      newMood = PetMood.sick;
    } else if (_pet!.isHungry) {
      newMood = PetMood.hungry;
    } else if (_pet!.isTired) {
      newMood = PetMood.tired;
    } else if (_pet!.isHappy) {
      newMood = PetMood.happy;
    } else if (_pet!.happiness < 30) {
      newMood = PetMood.sad;
    } else if (_pet!.energy > 80) {
      newMood = PetMood.excited;
    }

    _pet = _pet!.copyWith(mood: newMood);
  }

  // Seviye atlama kontrolü
  void _checkLevelUp() {
    if (_pet == null) return;

    final requiredExp = _pet!.level * 100;
    if (_pet!.experience >= requiredExp) {
      _pet = _pet!.copyWith(
        level: _pet!.level + 1,
        experience: _pet!.experience - requiredExp,
      );
      _checkStageUp();
    }
  }

  // Aşama geçişi kontrolü
  void _checkStageUp() {
    if (_pet == null) return;

    PetStage newStage = _pet!.stage;
    
    if (_pet!.level >= 5 && _pet!.stage == PetStage.baby) {
      newStage = PetStage.child;
    } else if (_pet!.level >= 10 && _pet!.stage == PetStage.child) {
      newStage = PetStage.teen;
    } else if (_pet!.level >= 20 && _pet!.stage == PetStage.teen) {
      newStage = PetStage.adult;
    } else if (_pet!.level >= 50 && _pet!.stage == PetStage.adult) {
      newStage = PetStage.elder;
    }

    if (newStage != _pet!.stage) {
      _pet = _pet!.copyWith(stage: newStage);
    }
  }

  // Pet deneyim puanı ekleme
  void addExperience(int amount) {
    if (_pet == null) return;

    _pet = _pet!.copyWith(
      experience: _pet!.experience + amount,
    );
    _checkLevelUp();
    notifyListeners();
  }

  // Pet eşyası ekleme
  void addItem(String item) {
    if (_pet == null) return;

    final newItems = List<String>.from(_pet!.unlockedItems);
    if (!newItems.contains(item)) {
      newItems.add(item);
      _pet = _pet!.copyWith(unlockedItems: newItems);
      notifyListeners();
    }
  }

  // Pet başarısı ekleme
  void addAchievement(String achievement) {
    if (_pet == null) return;

    final newAchievements = List<String>.from(_pet!.achievements);
    if (!newAchievements.contains(achievement)) {
      newAchievements.add(achievement);
      _pet = _pet!.copyWith(achievements: newAchievements);
      notifyListeners();
    }
  }

  // Pet paylaşma
  void sharePet(String partnerId) {
    if (_pet == null) return;

    _pet = _pet!.copyWith(isShared: true);
    notifyListeners();
  }

  // Pet paylaşımını kaldırma
  void unsharePet() {
    if (_pet == null) return;

    _pet = _pet!.copyWith(isShared: false);
    notifyListeners();
  }

  // Pet silme
  void deletePet() {
    _pet = null;
    _isFeeding = false;
    _isPlaying = false;
    _isSleeping = false;
    _lastUpdateTime = null;
    notifyListeners();
  }

  // Pet yükleme (veritabanından)
  void loadPet(VirtualPetData pet) {
    _pet = pet;
    _lastUpdateTime = DateTime.now();
    _updatePetStats();
    notifyListeners();
  }

  // Pet kaydetme (veritabanına)
  VirtualPetData? getPetToSave() {
    return _pet;
  }

  // Pet durumu kontrolü (periyodik olarak çağrılmalı)
  void checkPetStatus() {
    if (_pet == null) return;
    
    _updatePetStats();
    notifyListeners();
  }

  // Pet istatistikleri
  Map<String, dynamic> getPetStats() {
    if (_pet == null) return {};

    return {
      'level': _pet!.level,
      'experience': _pet!.experience,
      'health': _pet!.health,
      'hunger': _pet!.hunger,
      'happiness': _pet!.happiness,
      'energy': _pet!.energy,
      'ageInDays': _pet!.ageInDays,
      'overallHealth': _pet!.overallHealth,
      'needsCare': _pet!.needsCare,
      'unlockedItems': _pet!.unlockedItems.length,
      'achievements': _pet!.achievements.length,
    };
  }
}
