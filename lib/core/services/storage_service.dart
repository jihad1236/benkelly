import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'token';
  static const String _idKey = 'userId';
  static const String _refreshKey = 'refresh';
  static const String _emailKey = 'email';

  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool hasToken() {
    final token = _preferences?.getString(_tokenKey);
    return token != null;
  }

  static Future<void> saveToken(
    String token,
    String id, {
    required String refresh,
    required String email,
  }) async {
    await _preferences?.setString(_tokenKey, token);
    await _preferences?.setString(_idKey, id);
    await _preferences?.setString(_refreshKey, refresh);
    await _preferences?.setString(_emailKey, email);
  }

  static Future<void> logoutUser() async {
    await _preferences?.remove(_tokenKey);
    await _preferences?.remove(_idKey);
    await _preferences?.remove(_refreshKey);
    await _preferences?.remove(_emailKey);
  }

  static String? get userId => _preferences?.getString(_idKey);

  static String? get token => _preferences?.getString(_tokenKey);

  static String? get refresh => _preferences?.getString(_refreshKey);

  static String? get email => _preferences?.getString(_emailKey);
}
