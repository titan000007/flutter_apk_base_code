import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  //pref- value
  static const String isLoggedIn = 'is_logged_in';
  static const String userID = 'user_id';
  static const String userName = 'user_name';
  static const String userImage = 'user_image';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String accessToken = 'access_token';
  static const String deviceFcmToken = 'device_fcm_token';
  static const String languageCode = 'languageCode';
  static const String themeMode = 'theme_mode';
  static const String notificationTime = 'notification_time';
  static const String subscriptionStatus = 'subscription_status';
  static const String timeZone = 'time_zone';
  static const String notificationEnabled = 'notification_enabled';

  static SpUtil? _instance;

  static Future<SpUtil> get instance async {
    return await getInstance();
  }

  static SharedPreferences? _spf;

  SpUtil._();

  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<SpUtil> getInstance() async {
    _instance ??= SpUtil._();
    if (_spf == null) {
      await _instance!._init();
    }
    return _instance!;
  }

  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    return _spf!.getKeys();
  }

  get(String key) {
    return _spf!.get(key);
  }

  getString(String key) {
    return _spf!.getString(key);
  }

  Future<bool> putString(String key, String value) {
    return _spf!.setString(key, value);
  }

  bool? getBool(String key) {
    return _spf!.getBool(key);
  }

  Future<bool> putBool(String key, bool value) {
    return _spf!.setBool(key, value);
  }

  int? getInt(String key) {
    return _spf!.getInt(key);
  }

  Future<bool> putInt(String key, int value) {
    return _spf!.setInt(key, value);
  }

  double? getDouble(String key) {
    return _spf!.getDouble(key);
  }

  Future<bool> putDouble(String key, double value) {
    return _spf!.setDouble(key, value);
  }

  List<String>? getStringList(String key) {
    return _spf!.getStringList(key);
  }

  Future<bool> putStringList(String key, List<String> value) {
    return _spf!.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    return _spf!.get(key);
  }

  Future<bool> remove(String key) {
    return _spf!.remove(key);
  }

  Future<bool> clear() {
    return _spf!.clear();
  }
}
