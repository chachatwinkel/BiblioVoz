// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BiblioVoz';

  @override
  String get idioma => 'Idioma';

  @override
  String prestamosActivosTitulo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count préstamos activos',
      one: '1 préstamo activo',
      zero: 'Sin préstamos activos',
    );
    return '$_temp0';
  }

  @override
  String salidaEl(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Salida el $fechaString';
  }
}
