import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show SynchronousFuture;
class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'App title',
      'googleLogin': 'Login with Google'
    },
    'de': {
      'title': 'Título de App',
      'googleLogin': 'Conectar con Google'
    },
  };
  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
  String get googleLogin {
    return _localizedValues[locale.languageCode]['googleLogin'];
  }
}
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return new SynchronousFuture<AppLocalizations>(new AppLocalizations(locale));
  }
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}