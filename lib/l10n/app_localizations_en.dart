// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BiblioVoz';

  @override
  String get idioma => 'Language';

  @override
  String prestamosActivosTitulo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active loans',
      one: '1 active loan',
      zero: 'No active loans',
    );
    return '$_temp0';
  }

  @override
  String salidaEl(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Borrowed on $fechaString';
  }
}
