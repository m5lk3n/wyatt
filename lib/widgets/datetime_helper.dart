import 'dart:ui';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String formatDateTime(Locale locale, DateTime dateTime) {
  initializeDateFormatting(locale.languageCode); // TODO: init once per locale
  return DateFormat.yMd(locale.languageCode).add_Hm().format(dateTime);
}

LocaleType fromLanguageCode(Locale locale) {
  initializeDateFormatting(locale.languageCode); // TODO: init once per locale
  // TODO: match supported app locales
  switch (locale.languageCode) {
    case 'DE':
      return LocaleType.de;
    default:
      return LocaleType.en;
  }
}
