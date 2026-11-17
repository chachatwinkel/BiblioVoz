import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'controlador.dart';
import 'pantallas.dart';
import 'tema.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SQLite en el navegador (necesita web/sqlite3.wasm y web/sqflite_sw.js).
  databaseFactory = databaseFactoryFfiWeb;
  await ctrl.cargar();
  runApp(const BiblioVozApp());
}

class BiblioVozApp extends StatelessWidget {
  const BiblioVozApp({super.key});

    ThemeData _tema(Brightness brillo) => temaBiblio(brillo);

   @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([modoTema, idioma]),
      builder: (context, _) => MaterialApp(
        title: 'BiblioVoz',
        debugShowCheckedModeBanner: false,
        themeMode: modoTema.value,
        theme: _tema(Brightness.light),
        darkTheme: _tema(Brightness.dark),
        locale: idioma.value,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PantallaInicio(),
      ),
    );
  }
}
