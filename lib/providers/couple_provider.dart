import 'package:flutter/foundation.dart';
import '../models/couple_data.dart';
import '../models/fight_data.dart';
import '../models/anniversary_data.dart';

class CoupleProvider extends ChangeNotifier {
  CoupleData? _coupleData;
  List<FightData> _fights = [];
  List<AnniversaryData> _anniversaries = [];
  int _fightCount = 0;
  int _makeupCount = 0;
  DateTime? _lastFightDate;
  DateTime? _lastMakeupDate;

  // Getters
  CoupleData? get coupleData => _coupleData;
  List<FightData> get fights => _fights;
  List<AnniversaryData> get anniversaries => _anniversaries;
  int get fightCount => _fightCount;
  int get makeupCount => _makeupCount;
  DateTime? get lastFightDate => _lastFightDate;
  DateTime? get lastMakeupDate => _lastMakeupDate;

  // Çift verilerini güncelleme
  void updateCoupleData(CoupleData data) {
    _coupleData = data;
    notifyListeners();
  }

  // Tanışma tarihi güncelleme
  void updateMeetingDate(DateTime date) {
    if (_coupleData != null) {
      _coupleData = _coupleData!.copyWith(meetingDate: date);
      _calculateAnniversaries();
      notifyListeners();
    }
  }

  // Evlilik tarihi güncelleme
  void updateMarriageDate(DateTime? date) {
    if (_coupleData != null) {
      _coupleData = _coupleData!.copyWith(marriageDate: date);
      _calculateAnniversaries();
      notifyListeners();
    }
  }

  // Doğum günü güncelleme
  void updateBirthdays(DateTime userBirthday, DateTime partnerBirthday) {
    if (_coupleData != null) {
      _coupleData = _coupleData!.copyWith(
        userBirthday: userBirthday,
        partnerBirthday: partnerBirthday,
      );
      _calculateAnniversaries();
      notifyListeners();
    }
  }

  // Kavga ekleme
  void addFight(String reason, String description) {
    final fight = FightData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reason: reason,
      description: description,
      date: DateTime.now(),
      isResolved: false,
    );
    
    _fights.add(fight);
    _fightCount++;
    _lastFightDate = DateTime.now();
    notifyListeners();
  }

  // Barışma
  void makeUp(String fightId, String resolution) {
    final fightIndex = _fights.indexWhere((f) => f.id == fightId);
    if (fightIndex != -1) {
      _fights[fightIndex] = _fights[fightIndex].copyWith(
        isResolved: true,
        resolution: resolution,
        resolutionDate: DateTime.now(),
      );
      _makeupCount++;
      _lastMakeupDate = DateTime.now();
      notifyListeners();
    }
  }

  // Yıldönümlerini hesaplama
  void _calculateAnniversaries() {
    if (_coupleData == null) return;

    _anniversaries.clear();

    // Tanışma yıldönümü
    if (_coupleData!.meetingDate != null) {
      _anniversaries.add(AnniversaryData(
        id: 'meeting',
        title: 'Tanışma Yıldönümü',
        date: _coupleData!.meetingDate!,
        type: AnniversaryType.meeting,
      ));
    }

    // Evlilik yıldönümü
    if (_coupleData!.marriageDate != null) {
      _anniversaries.add(AnniversaryData(
        id: 'marriage',
        title: 'Evlilik Yıldönümü',
        date: _coupleData!.marriageDate!,
        type: AnniversaryType.marriage,
      ));
    }

    // Kullanıcı doğum günü
    if (_coupleData!.userBirthday != null) {
      _anniversaries.add(AnniversaryData(
        id: 'user_birthday',
        title: '${_coupleData!.userName} Doğum Günü',
        date: _coupleData!.userBirthday!,
        type: AnniversaryType.birthday,
      ));
    }

    // Partner doğum günü
    if (_coupleData!.partnerBirthday != null) {
      _anniversaries.add(AnniversaryData(
        id: 'partner_birthday',
        title: '${_coupleData!.partnerName} Doğum Günü',
        date: _coupleData!.partnerBirthday!,
        type: AnniversaryType.birthday,
      ));
    }

    // Yıldönümlerini tarihe göre sırala
    _anniversaries.sort((a, b) => a.date.compareTo(b.date));
  }

  // Sonraki yıldönümünü bulma
  AnniversaryData? getNextAnniversary() {
    final now = DateTime.now();
    final upcoming = _anniversaries.where((anniversary) {
      final anniversaryThisYear = DateTime(
        now.year,
        anniversary.date.month,
        anniversary.date.day,
      );
      return anniversaryThisYear.isAfter(now);
    }).toList();

    if (upcoming.isNotEmpty) {
      upcoming.sort((a, b) {
        final aThisYear = DateTime(now.year, a.date.month, a.date.day);
        final bThisYear = DateTime(now.year, b.date.month, b.date.day);
        return aThisYear.compareTo(bThisYear);
      });
      return upcoming.first;
    }

    // Bu yıl yoksa gelecek yılın ilk yıldönümü
    final nextYear = _anniversaries.where((anniversary) {
      final anniversaryNextYear = DateTime(
        now.year + 1,
        anniversary.date.month,
        anniversary.date.day,
      );
      return anniversaryNextYear.isAfter(now);
    }).toList();

    if (nextYear.isNotEmpty) {
      nextYear.sort((a, b) {
        final aNextYear = DateTime(now.year + 1, a.date.month, a.date.day);
        final bNextYear = DateTime(now.year + 1, b.date.month, b.date.day);
        return aNextYear.compareTo(bNextYear);
      });
      return nextYear.first;
    }

    return null;
  }

  // Birlikte geçirilen gün sayısı
  int getDaysTogether() {
    if (_coupleData?.meetingDate == null) return 0;
    return DateTime.now().difference(_coupleData!.meetingDate!).inDays;
  }
}
