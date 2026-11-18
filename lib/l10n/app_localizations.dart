import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'BiblioVoz'**
  String get appTitle;

  /// No description provided for @navCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Catálogo'**
  String get navCatalogo;

  /// No description provided for @navSocios.
  ///
  /// In es, this message translates to:
  /// **'Socios'**
  String get navSocios;

  /// No description provided for @navPrestamosActivos.
  ///
  /// In es, this message translates to:
  /// **'Préstamos activos'**
  String get navPrestamosActivos;

  /// No description provided for @navValoracion.
  ///
  /// In es, this message translates to:
  /// **'Valoración por gestos'**
  String get navValoracion;

  /// No description provided for @navAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes y permisos'**
  String get navAjustes;

  /// No description provided for @proponerLibroAzar.
  ///
  /// In es, this message translates to:
  /// **'Proponer libro al azar (sacudir / F2)'**
  String get proponerLibroAzar;

  /// No description provided for @prestamosPorGenero.
  ///
  /// In es, this message translates to:
  /// **'Préstamos por género (COUNT)'**
  String get prestamosPorGenero;

  /// No description provided for @prestamosVencidos.
  ///
  /// In es, this message translates to:
  /// **'Préstamos vencidos (JOIN)'**
  String get prestamosVencidos;

  /// No description provided for @ninguno.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get ninguno;

  /// No description provided for @socioAlias.
  ///
  /// In es, this message translates to:
  /// **'Socio: {alias}'**
  String socioAlias(String alias);

  /// No description provided for @ordenesVoz.
  ///
  /// In es, this message translates to:
  /// **'Órdenes de voz'**
  String get ordenesVoz;

  /// No description provided for @escuchando.
  ///
  /// In es, this message translates to:
  /// **'Escuchando… (pulsa para parar)'**
  String get escuchando;

  /// No description provided for @hablar.
  ///
  /// In es, this message translates to:
  /// **'Hablar'**
  String get hablar;

  /// No description provided for @hasDicho.
  ///
  /// In es, this message translates to:
  /// **'Has dicho: {texto}'**
  String hasDicho(String texto);

  /// No description provided for @escribeOrden.
  ///
  /// In es, this message translates to:
  /// **'O escribe una orden'**
  String get escribeOrden;

  /// No description provided for @hintOrden.
  ///
  /// In es, this message translates to:
  /// **'Busca libros de ciencia ficción'**
  String get hintOrden;

  /// No description provided for @enviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get enviar;

  /// No description provided for @ejemplosOrdenes.
  ///
  /// In es, this message translates to:
  /// **'Órdenes: «Busca libros de ciencia ficción» · «Devuelve el préstamo del libro Dune»'**
  String get ejemplosOrdenes;

  /// No description provided for @avisoPrivacidadInicio.
  ///
  /// In es, this message translates to:
  /// **'Privacidad: el micrófono solo se usa cuando pulsas «Hablar». El reconocimiento de voz lo hace el navegador y puede enviar el audio al servicio de su fabricante. En la base de datos solo se guarda el texto de la orden.'**
  String get avisoPrivacidadInicio;

  /// No description provided for @anadirLibro.
  ///
  /// In es, this message translates to:
  /// **'Añadir libro'**
  String get anadirLibro;

  /// No description provided for @buscarHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por título, autor o género (Ctrl+F)'**
  String get buscarHint;

  /// No description provided for @sinResultados.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get sinResultados;

  /// No description provided for @libroBorrado.
  ///
  /// In es, this message translates to:
  /// **'Libro borrado'**
  String get libroBorrado;

  /// No description provided for @socioBorrado.
  ///
  /// In es, this message translates to:
  /// **'Socio borrado'**
  String get socioBorrado;

  /// No description provided for @noSePuedeBorrar.
  ///
  /// In es, this message translates to:
  /// **'No se puede borrar: tiene préstamos'**
  String get noSePuedeBorrar;

  /// No description provided for @estadoPrestado.
  ///
  /// In es, this message translates to:
  /// **'Prestado'**
  String get estadoPrestado;

  /// No description provided for @estadoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get estadoDisponible;

  /// No description provided for @prestar.
  ///
  /// In es, this message translates to:
  /// **'Prestar'**
  String get prestar;

  /// No description provided for @pulgarAbajo.
  ///
  /// In es, this message translates to:
  /// **'Pulgar abajo'**
  String get pulgarAbajo;

  /// No description provided for @pulgarArriba.
  ///
  /// In es, this message translates to:
  /// **'Pulgar arriba'**
  String get pulgarArriba;

  /// No description provided for @sinValorar.
  ///
  /// In es, this message translates to:
  /// **'Sin valorar'**
  String get sinValorar;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @campoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get campoTitulo;

  /// No description provided for @campoAutor.
  ///
  /// In es, this message translates to:
  /// **'Autor'**
  String get campoAutor;

  /// No description provided for @campoIsbn.
  ///
  /// In es, this message translates to:
  /// **'ISBN'**
  String get campoIsbn;

  /// No description provided for @campoGenero.
  ///
  /// In es, this message translates to:
  /// **'Género'**
  String get campoGenero;

  /// No description provided for @campoEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get campoEstado;

  /// No description provided for @prestarEsteLibro.
  ///
  /// In es, this message translates to:
  /// **'Prestar este libro'**
  String get prestarEsteLibro;

  /// No description provided for @nuevoLibro.
  ///
  /// In es, this message translates to:
  /// **'Nuevo libro'**
  String get nuevoLibro;

  /// No description provided for @editarLibro.
  ///
  /// In es, this message translates to:
  /// **'Editar libro'**
  String get editarLibro;

  /// No description provided for @campoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get campoObligatorio;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @anadirSocio.
  ///
  /// In es, this message translates to:
  /// **'Añadir socio'**
  String get anadirSocio;

  /// No description provided for @borrar.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get borrar;

  /// No description provided for @nuevoSocio.
  ///
  /// In es, this message translates to:
  /// **'Nuevo socio'**
  String get nuevoSocio;

  /// No description provided for @editarSocio.
  ///
  /// In es, this message translates to:
  /// **'Editar socio'**
  String get editarSocio;

  /// No description provided for @campoAlias.
  ///
  /// In es, this message translates to:
  /// **'Alias'**
  String get campoAlias;

  /// No description provided for @campoCurso.
  ///
  /// In es, this message translates to:
  /// **'Curso'**
  String get campoCurso;

  /// No description provided for @nuevoPrestamoSocio.
  ///
  /// In es, this message translates to:
  /// **'Nuevo préstamo para este socio'**
  String get nuevoPrestamoSocio;

  /// No description provided for @historialPrestamos.
  ///
  /// In es, this message translates to:
  /// **'Historial de préstamos (JOIN)'**
  String get historialPrestamos;

  /// No description provided for @sinPrestamos.
  ///
  /// In es, this message translates to:
  /// **'Sin préstamos'**
  String get sinPrestamos;

  /// No description provided for @salidaEl.
  ///
  /// In es, this message translates to:
  /// **'Salida el {fecha}'**
  String salidaEl(DateTime fecha);

  /// No description provided for @salidaFecha.
  ///
  /// In es, this message translates to:
  /// **'Salida {fecha}'**
  String salidaFecha(DateTime fecha);

  /// No description provided for @sinDevolver.
  ///
  /// In es, this message translates to:
  /// **'sin devolver'**
  String get sinDevolver;

  /// No description provided for @devueltoFecha.
  ///
  /// In es, this message translates to:
  /// **'devuelto {fecha}'**
  String devueltoFecha(DateTime fecha);

  /// No description provided for @prestamosActivosTitulo.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin préstamos activos} =1{1 préstamo activo} other{{count} préstamos activos}}'**
  String prestamosActivosTitulo(int count);

  /// No description provided for @noHayPrestamosActivos.
  ///
  /// In es, this message translates to:
  /// **'No hay préstamos activos'**
  String get noHayPrestamosActivos;

  /// No description provided for @nuevoPrestamo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo préstamo'**
  String get nuevoPrestamo;

  /// No description provided for @devolver.
  ///
  /// In es, this message translates to:
  /// **'Devolver'**
  String get devolver;

  /// No description provided for @libroSoloDisponibles.
  ///
  /// In es, this message translates to:
  /// **'Libro (solo los disponibles)'**
  String get libroSoloDisponibles;

  /// No description provided for @eligeLibro.
  ///
  /// In es, this message translates to:
  /// **'Elige un libro'**
  String get eligeLibro;

  /// No description provided for @socio.
  ///
  /// In es, this message translates to:
  /// **'Socio'**
  String get socio;

  /// No description provided for @eligeSocio.
  ///
  /// In es, this message translates to:
  /// **'Elige un socio'**
  String get eligeSocio;

  /// No description provided for @guardarPrestamo.
  ///
  /// In es, this message translates to:
  /// **'Guardar préstamo'**
  String get guardarPrestamo;

  /// No description provided for @libroYaPrestado.
  ///
  /// In es, this message translates to:
  /// **'Ese libro ya está prestado'**
  String get libroYaPrestado;

  /// No description provided for @eligeLibroValorar.
  ///
  /// In es, this message translates to:
  /// **'Elige el libro devuelto y valóralo con el pulgar.'**
  String get eligeLibroValorar;

  /// No description provided for @libroHint.
  ///
  /// In es, this message translates to:
  /// **'Libro'**
  String get libroHint;

  /// No description provided for @maquetaAR.
  ///
  /// In es, this message translates to:
  /// **'Realidad aumentada (maqueta): activa la cámara y arrastra la ficha sobre tu libro físico.'**
  String get maquetaAR;

  /// No description provided for @ultimasValoraciones.
  ///
  /// In es, this message translates to:
  /// **'Últimas valoraciones (SQLite)'**
  String get ultimasValoraciones;

  /// No description provided for @todaviaNoValoraciones.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay valoraciones'**
  String get todaviaNoValoraciones;

  /// No description provided for @sinValoraciones.
  ///
  /// In es, this message translates to:
  /// **'Sin valoraciones'**
  String get sinValoraciones;

  /// No description provided for @modoOscuro.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get modoOscuro;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @respuestasHabladas.
  ///
  /// In es, this message translates to:
  /// **'Respuestas habladas'**
  String get respuestasHabladas;

  /// No description provided for @permisoMicrofono.
  ///
  /// In es, this message translates to:
  /// **'Permiso de micrófono'**
  String get permisoMicrofono;

  /// No description provided for @permisoCamara.
  ///
  /// In es, this message translates to:
  /// **'Permiso de cámara'**
  String get permisoCamara;

  /// No description provided for @comprobar.
  ///
  /// In es, this message translates to:
  /// **'Comprobar'**
  String get comprobar;

  /// No description provided for @sePideAlValorar.
  ///
  /// In es, this message translates to:
  /// **'Se pide al valorar'**
  String get sePideAlValorar;

  /// No description provided for @avisoPrivacidadTitulo.
  ///
  /// In es, this message translates to:
  /// **'Aviso de privacidad'**
  String get avisoPrivacidadTitulo;

  /// No description provided for @avisoPrivacidadAjustes.
  ///
  /// In es, this message translates to:
  /// **'BiblioVoz usa el micrófono solo cuando pulsas «Hablar» y la cámara solo cuando pulsas «Valorar con la cámara». La imagen de la cámara se procesa en tu navegador y no se envía ni se guarda. El reconocimiento de voz lo hace el navegador y puede enviar el audio al servicio de su fabricante. En la base de datos solo se guarda el texto de las órdenes, las sacudidas, las valoraciones y la colocación de la ficha de AR.'**
  String get avisoPrivacidadAjustes;

  /// No description provided for @registroNui.
  ///
  /// In es, this message translates to:
  /// **'Registro de la interfaz natural (SQLite)'**
  String get registroNui;

  /// No description provided for @sinRegistros.
  ///
  /// In es, this message translates to:
  /// **'Sin registros'**
  String get sinRegistros;

  /// No description provided for @estadoSinComprobar.
  ///
  /// In es, this message translates to:
  /// **'Sin comprobar'**
  String get estadoSinComprobar;

  /// No description provided for @micDisponible.
  ///
  /// In es, this message translates to:
  /// **'Micrófono disponible'**
  String get micDisponible;

  /// No description provided for @noDisponiblePermiso.
  ///
  /// In es, this message translates to:
  /// **'No disponible o permiso denegado'**
  String get noDisponiblePermiso;

  /// No description provided for @camaraActiva.
  ///
  /// In es, this message translates to:
  /// **'Cámara activa'**
  String get camaraActiva;

  /// No description provided for @camaraApagada.
  ///
  /// In es, this message translates to:
  /// **'Cámara apagada'**
  String get camaraApagada;

  /// No description provided for @valorarConCamara.
  ///
  /// In es, this message translates to:
  /// **'Valorar con la cámara (pulgar)'**
  String get valorarConCamara;

  /// No description provided for @cargandoDetector.
  ///
  /// In es, this message translates to:
  /// **'Cargando detector…'**
  String get cargandoDetector;

  /// No description provided for @desactivarCamara.
  ///
  /// In es, this message translates to:
  /// **'Desactivar cámara'**
  String get desactivarCamara;

  /// No description provided for @avisoCamara.
  ///
  /// In es, this message translates to:
  /// **'La cámara solo se enciende al pulsar el botón. La imagen se procesa en tu navegador y no se envía ni se guarda.'**
  String get avisoCamara;

  /// No description provided for @errorVoz.
  ///
  /// In es, this message translates to:
  /// **'Error de voz: {error}'**
  String errorVoz(String error);

  /// No description provided for @noPuedoMicrofono.
  ///
  /// In es, this message translates to:
  /// **'No puedo usar el micrófono. Escribe la orden en el cuadro.'**
  String get noPuedoMicrofono;

  /// No description provided for @encontradosLibros.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{No he encontrado libros de {tema}} =1{He encontrado 1 libro de {tema}} other{He encontrado {count} libros de {tema}}}'**
  String encontradosLibros(int count, String tema);

  /// No description provided for @prestamoDevuelto.
  ///
  /// In es, this message translates to:
  /// **'Préstamo de {titulo} devuelto'**
  String prestamoDevuelto(String titulo);

  /// No description provided for @noEncuentroPrestamo.
  ///
  /// In es, this message translates to:
  /// **'No encuentro ese préstamo activo'**
  String get noEncuentroPrestamo;

  /// No description provided for @noEntendido.
  ///
  /// In es, this message translates to:
  /// **'No he entendido la orden'**
  String get noEntendido;

  /// No description provided for @sinLibrosDisponibles.
  ///
  /// In es, this message translates to:
  /// **'No hay libros disponibles'**
  String get sinLibrosDisponibles;

  /// No description provided for @tePropongo.
  ///
  /// In es, this message translates to:
  /// **'Te propongo: {titulo}'**
  String tePropongo(String titulo);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
