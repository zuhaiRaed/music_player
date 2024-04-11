import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  late SharedPreferences prefs;

  Future<UserManager> initState() async {
    prefs = await SharedPreferences.getInstance();

    await getAppLanguage();
    await getAppTheme();

    return this;
  }

  late Locale appLang;
  late ThemeMode appTheme;

  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal() {
    initState();
  }

  Future<String> getAppLanguage() async {
    final lang = await getString('AppLang') ?? 'en';
    UserManager().appLang = Locale(lang);
    appLang = Locale(lang);
    Intl.defaultLocale = lang;
    return lang;
  }

  Future<String> getAppTheme() async {
    String? theme = await getString('AppTheme') ?? ' ';
    if (theme == 'dark') {
      appTheme = ThemeMode.dark;
    } else if (theme == 'light') {
      appTheme = ThemeMode.light;
    } else {
      appTheme = ThemeMode.light;
    }
    return theme;
  }

// ============== Set Functions ============== //

  void setUserEnv(String env) {
    setString('env', env);
  }

  void setAppLanguage(String lang) {
    appLang = Locale(lang);
    setString('AppLang', lang);
    Intl.defaultLocale = lang;
  }

  void setAppTheme(ThemeMode theme) {
    appTheme = theme;
    if (theme == ThemeMode.dark) {
      setString('AppTheme', 'dark');
    } else {
      setString('AppTheme', 'light');
    }
  }

  void setString(String key, String? value) {
    if (value == null) {
      prefs.remove(key);
      return;
    }
    prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }
}
