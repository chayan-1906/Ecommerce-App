import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'demo_localizations.dart';

String getTranslated(BuildContext context, String key) {
  return DemoLocalizations.of(context)!.translate(key);
}

const String LANGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String HINDI = 'hi';
const String SPANISH = 'es';
const String FARSI = 'fa';
const String ARABIC = 'ar';
const String URDU = 'ur';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  await _sharedPreferences.setString(LANGUAGE_CODE, languageCode);
  print('23: language set to $languageCode');
  return locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  String languageCode = _sharedPreferences.getString(LANGUAGE_CODE) ?? ENGLISH;
  print('22: language fetched $languageCode');
  return locale(languageCode);
}

Locale locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case HINDI:
      return const Locale(HINDI, "IN");
    case SPANISH:
      return const Locale(SPANISH, "ES");
    case FARSI:
      return const Locale(FARSI, "IR");
    case ARABIC:
      return const Locale(ARABIC, "SA");
    case URDU:
      return const Locale(URDU, "PK");
    default:
      return const Locale(ENGLISH, 'US');
  }
}
