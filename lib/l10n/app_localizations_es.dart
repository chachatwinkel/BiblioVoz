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
  String get navCatalogo => 'Catálogo';

  @override
  String get navSocios => 'Socios';

  @override
  String get navPrestamosActivos => 'Préstamos activos';

  @override
  String get navValoracion => 'Valoración por gestos';

  @override
  String get navAjustes => 'Ajustes y permisos';

  @override
  String get proponerLibroAzar => 'Proponer libro al azar (sacudir / F2)';

  @override
  String get prestamosPorGenero => 'Préstamos por género (COUNT)';

  @override
  String get prestamosVencidos => 'Préstamos vencidos (JOIN)';

  @override
  String get ninguno => 'Ninguno';

  @override
  String socioAlias(String alias) {
    return 'Socio: $alias';
  }

  @override
  String get ordenesVoz => 'Órdenes de voz';

  @override
  String get escuchando => 'Escuchando… (pulsa para parar)';

  @override
  String get hablar => 'Hablar';

  @override
  String hasDicho(String texto) {
    return 'Has dicho: $texto';
  }

  @override
  String get escribeOrden => 'O escribe una orden';

  @override
  String get hintOrden => 'Busca libros de ciencia ficción';

  @override
  String get enviar => 'Enviar';

  @override
  String get ejemplosOrdenes =>
      'Órdenes: «Busca libros de ciencia ficción» · «Devuelve el préstamo del libro Dune»';

  @override
  String get avisoPrivacidadInicio =>
      'Privacidad: el micrófono solo se usa cuando pulsas «Hablar». El reconocimiento de voz lo hace el navegador y puede enviar el audio al servicio de su fabricante. En la base de datos solo se guarda el texto de la orden.';

  @override
  String get anadirLibro => 'Añadir libro';

  @override
  String get buscarHint => 'Buscar por título, autor o género (Ctrl+F)';

  @override
  String get sinResultados => 'Sin resultados';

  @override
  String get libroBorrado => 'Libro borrado';

  @override
  String get socioBorrado => 'Socio borrado';

  @override
  String get noSePuedeBorrar => 'No se puede borrar: tiene préstamos';

  @override
  String get estadoPrestado => 'Prestado';

  @override
  String get estadoDisponible => 'Disponible';

  @override
  String get prestar => 'Prestar';

  @override
  String get pulgarAbajo => 'Pulgar abajo';

  @override
  String get pulgarArriba => 'Pulgar arriba';

  @override
  String get sinValorar => 'Sin valorar';

  @override
  String get editar => 'Editar';

  @override
  String get campoTitulo => 'Título';

  @override
  String get campoAutor => 'Autor';

  @override
  String get campoIsbn => 'ISBN';

  @override
  String get campoGenero => 'Género';

  @override
  String get campoEstado => 'Estado';

  @override
  String get prestarEsteLibro => 'Prestar este libro';

  @override
  String get nuevoLibro => 'Nuevo libro';

  @override
  String get editarLibro => 'Editar libro';

  @override
  String get campoObligatorio => 'Campo obligatorio';

  @override
  String get guardar => 'Guardar';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get anadirSocio => 'Añadir socio';

  @override
  String get borrar => 'Borrar';

  @override
  String get nuevoSocio => 'Nuevo socio';

  @override
  String get editarSocio => 'Editar socio';

  @override
  String get campoAlias => 'Alias';

  @override
  String get campoCurso => 'Curso';

  @override
  String get nuevoPrestamoSocio => 'Nuevo préstamo para este socio';

  @override
  String get historialPrestamos => 'Historial de préstamos (JOIN)';

  @override
  String get sinPrestamos => 'Sin préstamos';

  @override
  String salidaEl(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Salida el $fechaString';
  }

  @override
  String salidaFecha(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Salida $fechaString';
  }

  @override
  String get sinDevolver => 'sin devolver';

  @override
  String devueltoFecha(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'devuelto $fechaString';
  }

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
  String get noHayPrestamosActivos => 'No hay préstamos activos';

  @override
  String get nuevoPrestamo => 'Nuevo préstamo';

  @override
  String get devolver => 'Devolver';

  @override
  String get libroSoloDisponibles => 'Libro (solo los disponibles)';

  @override
  String get eligeLibro => 'Elige un libro';

  @override
  String get socio => 'Socio';

  @override
  String get eligeSocio => 'Elige un socio';

  @override
  String get guardarPrestamo => 'Guardar préstamo';

  @override
  String get libroYaPrestado => 'Ese libro ya está prestado';

  @override
  String get eligeLibroValorar =>
      'Elige el libro devuelto y valóralo con el pulgar.';

  @override
  String get libroHint => 'Libro';

  @override
  String get maquetaAR =>
      'Realidad aumentada (maqueta): activa la cámara y arrastra la ficha sobre tu libro físico.';

  @override
  String get ultimasValoraciones => 'Últimas valoraciones (SQLite)';

  @override
  String get todaviaNoValoraciones => 'Todavía no hay valoraciones';

  @override
  String get sinValoraciones => 'Sin valoraciones';

  @override
  String get modoOscuro => 'Modo oscuro';

  @override
  String get idioma => 'Idioma';

  @override
  String get respuestasHabladas => 'Respuestas habladas';

  @override
  String get permisoMicrofono => 'Permiso de micrófono';

  @override
  String get permisoCamara => 'Permiso de cámara';

  @override
  String get comprobar => 'Comprobar';

  @override
  String get sePideAlValorar => 'Se pide al valorar';

  @override
  String get avisoPrivacidadTitulo => 'Aviso de privacidad';

  @override
  String get avisoPrivacidadAjustes =>
      'BiblioVoz usa el micrófono solo cuando pulsas «Hablar» y la cámara solo cuando pulsas «Valorar con la cámara». La imagen de la cámara se procesa en tu navegador y no se envía ni se guarda. El reconocimiento de voz lo hace el navegador y puede enviar el audio al servicio de su fabricante. En la base de datos solo se guarda el texto de las órdenes, las sacudidas, las valoraciones y la colocación de la ficha de AR.';

  @override
  String get registroNui => 'Registro de la interfaz natural (SQLite)';

  @override
  String get sinRegistros => 'Sin registros';

  @override
  String get estadoSinComprobar => 'Sin comprobar';

  @override
  String get micDisponible => 'Micrófono disponible';

  @override
  String get noDisponiblePermiso => 'No disponible o permiso denegado';

  @override
  String get camaraActiva => 'Cámara activa';

  @override
  String get camaraApagada => 'Cámara apagada';

  @override
  String get valorarConCamara => 'Valorar con la cámara (pulgar)';

  @override
  String get cargandoDetector => 'Cargando detector…';

  @override
  String get desactivarCamara => 'Desactivar cámara';

  @override
  String get avisoCamara =>
      'La cámara solo se enciende al pulsar el botón. La imagen se procesa en tu navegador y no se envía ni se guarda.';

  @override
  String errorVoz(String error) {
    return 'Error de voz: $error';
  }

  @override
  String get noPuedoMicrofono =>
      'No puedo usar el micrófono. Escribe la orden en el cuadro.';

  @override
  String encontradosLibros(int count, String tema) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'He encontrado $count libros de $tema',
      one: 'He encontrado 1 libro de $tema',
      zero: 'No he encontrado libros de $tema',
    );
    return '$_temp0';
  }

  @override
  String prestamoDevuelto(String titulo) {
    return 'Préstamo de $titulo devuelto';
  }

  @override
  String get noEncuentroPrestamo => 'No encuentro ese préstamo activo';

  @override
  String get noEntendido => 'No he entendido la orden';

  @override
  String get sinLibrosDisponibles => 'No hay libros disponibles';

  @override
  String tePropongo(String titulo) {
    return 'Te propongo: $titulo';
  }
}
