class SettingsModel {
  final int? id;
  final bool twoFactor;
  final bool biometric;
  final bool pushNotification;
  final bool emailNotification;
  final bool darkMode;
  final String language;
  final int? user;

  SettingsModel({
    this.id,
    required this.twoFactor,
    required this.biometric,
    required this.pushNotification,
    required this.emailNotification,
    required this.darkMode,
    required this.language,
    this.user,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      twoFactor: json['two_factor'] == true,
      biometric: json['biometric'] == true,
      pushNotification: json['push_notification'] == true,
      emailNotification: json['email_notification'] == true,
      darkMode: json['dark_mode'] == true,
      language: json['language']?.toString() ?? 'English',
      user: json['user'] is int
          ? json['user'] as int
          : int.tryParse('${json['user']}'),
    );
  }
}
