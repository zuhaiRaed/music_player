import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import '/core/application.dart';

class AppLocalizations {
  final Locale locale;
  // static const String ar = 'ar';
  // static const String en = 'en';
  static const List<String> supportedLanguages = [
    'English',
    'العربية',
  ];

  static const List<String> supportedLanguagesCodes = ['en', 'ar'];

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates =
      [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  //returns the list of supported Locales
  static Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ''));

  AppLocalizations(this.locale);
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();
  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get currentLanguage => locale.languageCode;

  late Map<String, String> localizedStrings;

  Future<Map<String, dynamic>> load() async {
    // Load the language JSON file from the "lang" folder
    final String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;
    return localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    if (localizedStrings[key] == null) {
      debugPrint('>>>>>>>>>>> $key notFound <<<<<<<<<<<<');
    }
    return localizedStrings[key] ?? key;
  }

  String getLang() {
    if (currentLanguage == 'ar') {
      return '1';
    } else {
      return '2';
    }
  }

  String getName() {
    if (currentLanguage == 'ar') {
      return AppLocalizations.supportedLanguages[1];
    } else {
      return AppLocalizations.supportedLanguages[0];
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale? newLocale;

  const AppLocalizationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLanguagesCodes
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    final AppLocalizations localizations = AppLocalizations(locale);
    final _ = await localizations.load();

    application.notifyOnLocaleChanged(localizations);
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
