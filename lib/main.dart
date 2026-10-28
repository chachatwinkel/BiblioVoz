import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'controlador.dart';
import 'pantallas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SQLite en el navegador (necesita web/sqlite3.wasm y web/sqflite_sw.js).
  databaseFactory = databaseFactoryFfiWeb;
  await ctrl.cargar();
  runApp(const BiblioVozApp());
}

class BiblioVozApp extends StatelessWidget {
  const BiblioVozApp({super.key});

  ThemeData _tema(Brightness brillo) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: brillo,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: modoTema,
      builder: (context, modo, _) => MaterialApp(
        title: 'BiblioVoz',
        debugShowCheckedModeBanner: false,
        themeMode: modo,
        theme: _tema(Brightness.light),
        darkTheme: _tema(Brightness.dark),
        home: const PantallaInicio(),
      ),
    );
  }
}
