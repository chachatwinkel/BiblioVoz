import 'package:flutter/material.dart';

/// Colores de la paleta.
class Paleta {
  static const crema = Color(0xFFF2EFE9);
  static const lavanda = Color(0xFFC7C2D4);
  static const malva = Color(0xFF8D8AA8);
  static const ciruela = Color(0xFF6A5E6A);
  static const carbon = Color(0xFF3F3B41);

  /// Color de aviso (préstamos vencidos), cálido y apagado para que
  /// combine con la paleta.
  static const aviso = Color(0xFFC8834F);
}

const _esquemaClaro = ColorScheme(
  brightness: Brightness.light,
  primary: Paleta.ciruela,
  onPrimary: Colors.white,
  primaryContainer: Paleta.lavanda,
  onPrimaryContainer: Paleta.carbon,
  secondary: Paleta.malva,
  onSecondary: Color(0xFF1F1C21),
  secondaryContainer: Color(0xFFE3E0EA),
  onSecondaryContainer: Paleta.carbon,
  tertiary: Paleta.malva,
  onTertiary: Color(0xFF1F1C21),
  error: Color(0xFFB3261E),
  onError: Colors.white,
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),
  surface: Paleta.crema,
  onSurface: Paleta.carbon,
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: Color(0xFFFAF8F4),
  surfaceContainer: Color(0xFFECE8E2),
  surfaceContainerHigh: Color(0xFFE6E2E8),
  surfaceContainerHighest: Color(0xFFDEDAE4),
  onSurfaceVariant: Paleta.ciruela,
  outline: Paleta.malva,
  outlineVariant: Color(0xFFDDD9E2),
  inverseSurface: Paleta.carbon,
  onInverseSurface: Paleta.crema,
  inversePrimary: Paleta.lavanda,
  surfaceTint: Colors.transparent,
);

const _esquemaOscuro = ColorScheme(
  brightness: Brightness.dark,
  primary: Paleta.lavanda,
  onPrimary: Color(0xFF2B282D),
  primaryContainer: Paleta.ciruela,
  onPrimaryContainer: Paleta.crema,
  secondary: Paleta.malva,
  onSecondary: Color(0xFF1F1C21),
  secondaryContainer: Color(0xFF524C5E),
  onSecondaryContainer: Paleta.crema,
  tertiary: Paleta.malva,
  onTertiary: Color(0xFF1F1C21),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),
  surface: Color(0xFF2B282D),
  onSurface: Paleta.crema,
  surfaceContainerLowest: Color(0xFF242126),
  surfaceContainerLow: Color(0xFF353137),
  surfaceContainer: Paleta.carbon,
  surfaceContainerHigh: Color(0xFF47424A),
  surfaceContainerHighest: Color(0xFF524C55),
  onSurfaceVariant: Paleta.lavanda,
  outline: Paleta.malva,
  outlineVariant: Color(0xFF4E4952),
  inverseSurface: Paleta.crema,
  onInverseSurface: Paleta.carbon,
  inversePrimary: Paleta.ciruela,
  surfaceTint: Colors.transparent,
);

/// Tema de la app para modo claro u oscuro.
ThemeData temaBiblio(Brightness brillo) {
  final cs = brillo == Brightness.light ? _esquemaClaro : _esquemaOscuro;
  final redondeo12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    scaffoldBackgroundColor: cs.surface,
    visualDensity: VisualDensity.standard,

    // Barra superior: mismo fondo que la pantalla, sin sombra.
    appBarTheme: AppBarThemeData(
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: cs.onSurface,
        fontSize: 21,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),

    // Tarjetas: planas, con borde fino y esquinas redondeadas.
    cardTheme: CardThemeData(
      color: cs.surfaceContainerLow,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
    ),

    // Campos de texto rellenos con borde suave.
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: cs.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.error, width: 1.6),
      ),
      prefixIconColor: cs.onSurfaceVariant,
    ),

    // Botones con algo más de altura y esquinas redondeadas.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: redondeo12,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: redondeo12,
        foregroundColor: cs.primary,
        side: BorderSide(color: cs.outline),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: redondeo12,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      elevation: 2,
      highlightElevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: cs.primary,
      shape: redondeo12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    ),

    dividerTheme: DividerThemeData(
      color: cs.outlineVariant,
      thickness: 1,
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: cs.inverseSurface,
      contentTextStyle: TextStyle(color: cs.onInverseSurface),
      shape: redondeo12,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: cs.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: cs.primary,
      linearTrackColor: cs.primaryContainer,
    ),
  );

  // Tipografía: títulos de sección algo más marcados.
  final t = base.textTheme;
  return base.copyWith(
    textTheme: t.copyWith(
      titleLarge: t.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: t.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      bodyMedium: t.bodyMedium?.copyWith(height: 1.4),
    ),
  );
}
