class PrivacyModel {
  final int? id;
  final bool conData;
  final bool savePhoto;
  final bool stripMetaData;
  final int? user;

  PrivacyModel({
    this.id,
    required this.conData,
    required this.savePhoto,
    required this.stripMetaData,
    this.user,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      id: json['id'] is int
          ? json['id']
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      conData: json['con_data'] == true,
      savePhoto: json['save_photo'] == true,
      stripMetaData: json['strip_meta_data'] == true,
      user: json['user'] is int
          ? json['user']
          : (json['user'] != null
                ? int.tryParse(json['user'].toString())
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'con_data': conData,
      'save_photo': savePhoto,
      'strip_meta_data': stripMetaData,
      'user': user,
    };
  }
}
