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
  String get navCatalogo => 'Catalog';

  @override
  String get navSocios => 'Members';

  @override
  String get navPrestamosActivos => 'Active loans';

  @override
  String get navValoracion => 'Rating by gestures';

  @override
  String get navAjustes => 'Settings and permissions';

  @override
  String get proponerLibroAzar => 'Suggest a random book (shake / F2)';

  @override
  String get prestamosPorGenero => 'Loans by genre (COUNT)';

  @override
  String get prestamosVencidos => 'Overdue loans (JOIN)';

  @override
  String get ninguno => 'None';

  @override
  String socioAlias(String alias) {
    return 'Member: $alias';
  }

  @override
  String get ordenesVoz => 'Voice commands';

  @override
  String get escuchando => 'Listening… (tap to stop)';

  @override
  String get hablar => 'Speak';

  @override
  String hasDicho(String texto) {
    return 'You said: $texto';
  }

  @override
  String get escribeOrden => 'Or type a command';

  @override
  String get hintOrden => 'Search books about science fiction';

  @override
  String get enviar => 'Send';

  @override
  String get ejemplosOrdenes =>
      'Commands: “Search books about science fiction” · “Return the loan of the book Dune”';

  @override
  String get avisoPrivacidadInicio =>
      'Privacy: the microphone is only used when you press “Speak”. Speech recognition is done by the browser and may send the audio to its vendor’s service. Only the text of the command is saved in the database.';

  @override
  String get anadirLibro => 'Add book';

  @override
  String get buscarHint => 'Search by title, author or genre (Ctrl+F)';

  @override
  String get sinResultados => 'No results';

  @override
  String get libroBorrado => 'Book deleted';

  @override
  String get socioBorrado => 'Member deleted';

  @override
  String get noSePuedeBorrar => 'Cannot delete: it has loans';

  @override
  String get estadoPrestado => 'On loan';

  @override
  String get estadoDisponible => 'Available';

  @override
  String get prestar => 'Lend';

  @override
  String get pulgarAbajo => 'Thumbs down';

  @override
  String get pulgarArriba => 'Thumbs up';

  @override
  String get sinValorar => 'Not rated';

  @override
  String get editar => 'Edit';

  @override
  String get campoTitulo => 'Title';

  @override
  String get campoAutor => 'Author';

  @override
  String get campoIsbn => 'ISBN';

  @override
  String get campoGenero => 'Genre';

  @override
  String get campoEstado => 'Status';

  @override
  String get prestarEsteLibro => 'Lend this book';

  @override
  String get nuevoLibro => 'New book';

  @override
  String get editarLibro => 'Edit book';

  @override
  String get campoObligatorio => 'Required field';

  @override
  String get guardar => 'Save';

  @override
  String get cancelar => 'Cancel';

  @override
  String get anadirSocio => 'Add member';

  @override
  String get borrar => 'Delete';

  @override
  String get nuevoSocio => 'New member';

  @override
  String get editarSocio => 'Edit member';

  @override
  String get campoAlias => 'Alias';

  @override
  String get campoCurso => 'Course';

  @override
  String get nuevoPrestamoSocio => 'New loan for this member';

  @override
  String get historialPrestamos => 'Loan history (JOIN)';

  @override
  String get sinPrestamos => 'No loans';

  @override
  String salidaEl(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Borrowed on $fechaString';
  }

  @override
  String salidaFecha(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Borrowed $fechaString';
  }

  @override
  String get sinDevolver => 'not returned';

  @override
  String devueltoFecha(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMMMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'returned $fechaString';
  }

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
  String get noHayPrestamosActivos => 'There are no active loans';

  @override
  String get nuevoPrestamo => 'New loan';

  @override
  String get devolver => 'Return';

  @override
  String get libroSoloDisponibles => 'Book (available only)';

  @override
  String get eligeLibro => 'Choose a book';

  @override
  String get socio => 'Member';

  @override
  String get eligeSocio => 'Choose a member';

  @override
  String get guardarPrestamo => 'Save loan';

  @override
  String get libroYaPrestado => 'That book is already on loan';

  @override
  String get eligeLibroValorar =>
      'Choose the returned book and rate it with a thumb.';

  @override
  String get libroHint => 'Book';

  @override
  String get maquetaAR =>
      'Augmented reality (mock-up): turn on the camera and drag the card over your physical book.';

  @override
  String get ultimasValoraciones => 'Latest ratings (SQLite)';

  @override
  String get todaviaNoValoraciones => 'There are no ratings yet';

  @override
  String get sinValoraciones => 'No ratings';

  @override
  String get modoOscuro => 'Dark mode';

  @override
  String get idioma => 'Language';

  @override
  String get respuestasHabladas => 'Spoken answers';

  @override
  String get permisoMicrofono => 'Microphone permission';

  @override
  String get permisoCamara => 'Camera permission';

  @override
  String get comprobar => 'Check';

  @override
  String get sePideAlValorar => 'Requested when rating';

  @override
  String get avisoPrivacidadTitulo => 'Privacy notice';

  @override
  String get avisoPrivacidadAjustes =>
      'BiblioVoz uses the microphone only when you press “Speak” and the camera only when you press “Rate with the camera”. The camera image is processed in your browser and is neither sent nor saved. Speech recognition is done by the browser and may send the audio to its vendor’s service. Only the text of the commands, the shakes, the ratings and the placement of the AR card are saved in the database.';

  @override
  String get registroNui => 'Natural interface log (SQLite)';

  @override
  String get sinRegistros => 'No records';

  @override
  String get estadoSinComprobar => 'Not checked';

  @override
  String get micDisponible => 'Microphone available';

  @override
  String get noDisponiblePermiso => 'Unavailable or permission denied';

  @override
  String get camaraActiva => 'Camera on';

  @override
  String get camaraApagada => 'Camera off';

  @override
  String get valorarConCamara => 'Rate with the camera (thumb)';

  @override
  String get cargandoDetector => 'Loading detector…';

  @override
  String get desactivarCamara => 'Turn camera off';

  @override
  String get avisoCamara =>
      'The camera only turns on when you press the button. The image is processed in your browser and is neither sent nor saved.';

  @override
  String errorVoz(String error) {
    return 'Voice error: $error';
  }

  @override
  String get noPuedoMicrofono =>
      'I cannot use the microphone. Type the command in the box.';

  @override
  String encontradosLibros(int count, String tema) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'I found $count books about $tema',
      one: 'I found 1 book about $tema',
      zero: 'I found no books about $tema',
    );
    return '$_temp0';
  }

  @override
  String prestamoDevuelto(String titulo) {
    return 'Loan of $titulo returned';
  }

  @override
  String get noEncuentroPrestamo => 'I cannot find that active loan';

  @override
  String get noEntendido => 'I did not understand the command';

  @override
  String get sinLibrosDisponibles => 'No books available';

  @override
  String tePropongo(String titulo) {
    return 'How about: $titulo';
  }
}
