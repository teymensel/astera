class CoupleData {
  final String id;
  final String userId;
  final String partnerId;
  final String userName;
  final String partnerName;
  final DateTime? meetingDate;
  final DateTime? marriageDate;
  final DateTime? userBirthday;
  final DateTime? partnerBirthday;
  final String? userProfileImage;
  final String? partnerProfileImage;
  final String? relationshipStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoupleData({
    required this.id,
    required this.userId,
    required this.partnerId,
    required this.userName,
    required this.partnerName,
    this.meetingDate,
    this.marriageDate,
    this.userBirthday,
    this.partnerBirthday,
    this.userProfileImage,
    this.partnerProfileImage,
    this.relationshipStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  CoupleData copyWith({
    String? id,
    String? userId,
    String? partnerId,
    String? userName,
    String? partnerName,
    DateTime? meetingDate,
    DateTime? marriageDate,
    DateTime? userBirthday,
    DateTime? partnerBirthday,
    String? userProfileImage,
    String? partnerProfileImage,
    String? relationshipStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoupleData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      partnerId: partnerId ?? this.partnerId,
      userName: userName ?? this.userName,
      partnerName: partnerName ?? this.partnerName,
      meetingDate: meetingDate ?? this.meetingDate,
      marriageDate: marriageDate ?? this.marriageDate,
      userBirthday: userBirthday ?? this.userBirthday,
      partnerBirthday: partnerBirthday ?? this.partnerBirthday,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      partnerProfileImage: partnerProfileImage ?? this.partnerProfileImage,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'partnerId': partnerId,
      'userName': userName,
      'partnerName': partnerName,
      'meetingDate': meetingDate?.toIso8601String(),
      'marriageDate': marriageDate?.toIso8601String(),
      'userBirthday': userBirthday?.toIso8601String(),
      'partnerBirthday': partnerBirthday?.toIso8601String(),
      'userProfileImage': userProfileImage,
      'partnerProfileImage': partnerProfileImage,
      'relationshipStatus': relationshipStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CoupleData.fromJson(Map<String, dynamic> json) {
    return CoupleData(
      id: json['id'] as String,
      userId: json['userId'] as String,
      partnerId: json['partnerId'] as String,
      userName: json['userName'] as String,
      partnerName: json['partnerName'] as String,
      meetingDate: json['meetingDate'] != null 
          ? DateTime.parse(json['meetingDate'] as String)
          : null,
      marriageDate: json['marriageDate'] != null 
          ? DateTime.parse(json['marriageDate'] as String)
          : null,
      userBirthday: json['userBirthday'] != null 
          ? DateTime.parse(json['userBirthday'] as String)
          : null,
      partnerBirthday: json['partnerBirthday'] != null 
          ? DateTime.parse(json['partnerBirthday'] as String)
          : null,
      userProfileImage: json['userProfileImage'] as String?,
      partnerProfileImage: json['partnerProfileImage'] as String?,
      relationshipStatus: json['relationshipStatus'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
