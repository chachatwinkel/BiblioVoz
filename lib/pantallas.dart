import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit_biblio/ui_kit_biblio.dart';

import 'camara_manos.dart';
import 'controlador.dart';
import 'db.dart';
import 'l10n/app_localizations.dart';
import 'nui.dart';

// ---------- Utilidades ----------

void ir(BuildContext context, Widget pantalla) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));

void aviso(BuildContext context, String mensaje) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));

String soloFecha(Object? iso) => (iso as String).substring(0, 10);

/// Estado del micrófono traducido al idioma actual.
String textoMic(AppLocalizations t, EstadoMic e) => switch (e) {
      EstadoMic.sinComprobar => t.estadoSinComprobar,
      EstadoMic.disponible => t.micDisponible,
      EstadoMic.noDisponible => t.noDisponiblePermiso,
    };

/// Estado de la cámara traducido al idioma actual.
String textoCamara(AppLocalizations t, EstadoCamara e) => switch (e) {
      EstadoCamara.sinComprobar => t.estadoSinComprobar,
      EstadoCamara.activa => t.camaraActiva,
      EstadoCamara.apagada => t.camaraApagada,
      EstadoCamara.noDisponible => t.noDisponiblePermiso,
    };

/// BookCard alimentado con un libro de SQLite.
BookCard tarjetaLibro(BuildContext context, Libro l) {
  final t = AppLocalizations.of(context)!;
  return BookCard(
    title: l.titulo,
    author: l.autor,
    borrowed: ctrl.librosPrestados.contains(l.id),
    borrowedLabel: t.estadoPrestado,
    availableLabel: t.estadoDisponible,
    loanTooltip: t.prestar,
    onTap: () => ir(context, PantallaFichaLibro(l)),
    onLoan: () => ir(context, PantallaNuevoPrestamo(libro: l)),
  );
}

/// ThumbRating con los textos en el idioma actual.
ThumbRating pulgares(
  BuildContext context, {
  Key? key,
  int inicial = 0,
  required ValueChanged<int> onChanged,
}) {
  final t = AppLocalizations.of(context)!;
  return ThumbRating(
    key: key,
    initialValue: inicial,
    onChanged: onChanged,
    downTooltip: t.pulgarAbajo,
    upTooltip: t.pulgarArriba,
  );
}

// =====================================================================
// 1. INICIO
// =====================================================================
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final _orden = TextEditingController();

  @override
  void initState() {
    super.initState();
    nui.iniciarSacudida();
  }

  @override
  void dispose() {
    _orden.dispose();
    nui.liberar();
    super.dispose();
  }

  void _enviar(String texto) {
    if (texto.trim().isEmpty) return;
    nui.ejecutar(texto);
    _orden.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return CallbackShortcuts(
      // F2 simula la sacudida del móvil en el ordenador.
      bindings: {const SingleActivator(LogicalKeyboardKey.f2): nui.sacudir},
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: Text(t.appTitle)),
          body: ListenableBuilder(
            listenable: Listenable.merge([ctrl, nui]),
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const AvisoPrivacidad(),
                const SizedBox(height: 16),
                PanelVoz(orden: _orden, enviar: _enviar),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: nui.sacudir,
                  icon: const Icon(Icons.vibration),
                  label: Text(t.proponerLibroAzar),
                ),
                if (nui.sugerencia != null)
                  tarjetaLibro(context, nui.sugerencia!),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(t.navCatalogo),
                  onTap: () => ir(context, const PantallaCatalogo()),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: Text(t.navSocios),
                  onTap: () => ir(context, const PantallaSocios()),
                ),
                ListTile(
                  leading: const Icon(Icons.outbox),
                  title: Text(t.navPrestamosActivos),
                  onTap: () => ir(context, const PantallaPrestamos()),
                ),
                ListTile(
                  leading: const Icon(Icons.thumbs_up_down),
                  title: Text(t.navValoracion),
                  onTap: () => ir(context, const PantallaValoracion()),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(t.navAjustes),
                  onTap: () => ir(context, const PantallaAjustes()),
                ),
                const Divider(height: 32),
                const ListaVencidos(),
                const SizedBox(height: 16),
                const ResumenGenero(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResumenGenero extends StatelessWidget {
  const ResumenGenero({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          t.prestamosPorGenero,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ...ctrl.porGenero.entries.map(
          (e) => ListTile(
            dense: true,
            title: Text(e.key),
            trailing: Text('${e.value}'),
          ),
        ),
      ],
    );
  }
}

class ListaVencidos extends StatelessWidget {
  const ListaVencidos({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          t.prestamosVencidos,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (ctrl.vencidos.isEmpty) Text(t.ninguno),
        ...ctrl.vencidos.map(
          (v) => ListTile(
            dense: true,
            leading: const Icon(Icons.warning_amber, color: Colors.orange),
            title: Text('${v['titulo']}'),
            subtitle: Text(
              '${t.socioAlias(v['alias'] as String)} · '
              '${t.salidaEl(DateTime.parse(v['fecha_salida'] as String))}',
            ),
          ),
        ),
      ],
    );
  }
}

class PanelVoz extends StatelessWidget {
  const PanelVoz({super.key, required this.orden, required this.enviar});

  final TextEditingController orden;
  final void Function(String texto) enviar;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.ordenesVoz, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: nui.escuchando ? nui.detener : nui.escuchar,
          icon: Icon(nui.escuchando ? Icons.mic : Icons.mic_none),
          label: Text(nui.escuchando ? t.escuchando : t.hablar),
        ),
        if (nui.escuchando) const LinearProgressIndicator(),
        if (nui.ultimoTexto.isNotEmpty) Text(t.hasDicho(nui.ultimoTexto)),
        if (nui.respuesta.isNotEmpty)
          Text(
            nui.respuesta,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: orden,
                decoration: InputDecoration(
                  labelText: t.escribeOrden,
                  hintText: t.hintOrden,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: enviar,
              ),
            ),
            IconButton(
              tooltip: t.enviar,
              icon: const Icon(Icons.send),
              onPressed: () => enviar(orden.text),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(t.ejemplosOrdenes),
      ],
    );
  }
}

class AvisoPrivacidad extends StatelessWidget {
  const AvisoPrivacidad({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(t.avisoPrivacidadInicio),
      ),
    );
  }
}

// =====================================================================
// 2. CATÁLOGO (buscador en vivo + Ctrl+F + deslizar para borrar)
// =====================================================================
class PantallaCatalogo extends StatefulWidget {
  const PantallaCatalogo({super.key});

  @override
  State<PantallaCatalogo> createState() => _PantallaCatalogoState();
}

class _PantallaCatalogoState extends State<PantallaCatalogo> {
  final _busqueda = TextEditingController(text: ctrl.filtro);
  final _foco = FocusNode();

  @override
  void dispose() {
    _busqueda.dispose();
    _foco.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            _foco.requestFocus,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: Text(t.navCatalogo)),
          floatingActionButton: FloatingActionButton(
            tooltip: t.anadirLibro,
            onPressed: () => ir(context, const PantallaAltaLibro()),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _busqueda,
                  focusNode: _foco,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: t.buscarHint,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: ctrl.buscar,
                ),
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: ctrl,
                  builder: (context, _) {
                    final libros = ctrl.libros;
                    if (libros.isEmpty) {
                      return Center(child: Text(t.sinResultados));
                    }
                    return ListView.builder(
                      itemCount: libros.length,
                      itemBuilder: (context, i) {
                        final l = libros[i];
                        return Dismissible(
                          key: ValueKey(l.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            final ok = await ctrl.borrarLibro(l.id!);
                            if (context.mounted) {
                              aviso(
                                context,
                                ok ? t.libroBorrado : t.noSePuedeBorrar,
                              );
                            }
                            return false; // la lista ya se recarga sola
                          },
                          child: tarjetaLibro(context, l),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// 3. FICHA DE LIBRO
// =====================================================================
class PantallaFichaLibro extends StatelessWidget {
  final Libro libro;
  const PantallaFichaLibro(this.libro, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        final l = ctrl.todos.firstWhere(
          (x) => x.id == libro.id,
          orElse: () => libro,
        );
        final prestado = ctrl.librosPrestados.contains(l.id);
        return Scaffold(
          appBar: AppBar(
            title: Text(l.titulo),
            actions: [
              IconButton(
                tooltip: t.editar,
                icon: const Icon(Icons.edit),
                onPressed: () => ir(context, PantallaAltaLibro(libro: l)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Icon(Icons.menu_book, size: 96),
              ListTile(title: Text(t.campoTitulo), subtitle: Text(l.titulo)),
              ListTile(title: Text(t.campoAutor), subtitle: Text(l.autor)),
              ListTile(title: Text(t.campoIsbn), subtitle: Text(l.isbn)),
              ListTile(title: Text(t.campoGenero), subtitle: Text(l.genero)),
              ListTile(
                title: Text(t.campoEstado),
                subtitle: Text(
                  prestado ? t.estadoPrestado : t.estadoDisponible,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: pulgares(
                  context,
                  onChanged: (v) => ctrl.valorar(l, v),
                ),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.outbox),
                label: Text(t.prestarEsteLibro),
                onPressed: prestado
                    ? null
                    : () => ir(context, PantallaNuevoPrestamo(libro: l)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================================
// 4. ALTA Y EDICIÓN DE LIBRO
// =====================================================================
class PantallaAltaLibro extends StatefulWidget {
  final Libro? libro; // null = alta nueva
  const PantallaAltaLibro({super.key, this.libro});

  @override
  State<PantallaAltaLibro> createState() => _PantallaAltaLibroState();
}

class _PantallaAltaLibroState extends State<PantallaAltaLibro> {
  final _clave = GlobalKey<FormState>();
  late final TextEditingController _titulo, _autor, _isbn, _genero;

  @override
  void initState() {
    super.initState();
    final l = widget.libro;
    _titulo = TextEditingController(text: l?.titulo ?? '');
    _autor = TextEditingController(text: l?.autor ?? '');
    _isbn = TextEditingController(text: l?.isbn ?? '');
    _genero = TextEditingController(text: l?.genero ?? '');
  }

  @override
  void dispose() {
    _titulo.dispose();
    _autor.dispose();
    _isbn.dispose();
    _genero.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_clave.currentState!.validate()) return;
    await ctrl.guardarLibro(
      Libro(
        id: widget.libro?.id,
        titulo: _titulo.text.trim(),
        autor: _autor.text.trim(),
        isbn: _isbn.text.trim(),
        genero: _genero.text.trim(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    String? obligatorio(String? v) =>
        (v == null || v.trim().isEmpty) ? t.campoObligatorio : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.libro == null ? t.nuevoLibro : t.editarLibro),
      ),
      body: Form(
        key: _clave,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              decoration: InputDecoration(labelText: t.campoTitulo),
              validator: obligatorio,
            ),
            TextFormField(
              controller: _autor,
              decoration: InputDecoration(labelText: t.campoAutor),
              validator: obligatorio,
            ),
            TextFormField(
              controller: _isbn,
              decoration: InputDecoration(labelText: t.campoIsbn),
            ),
            TextFormField(
              controller: _genero,
              decoration: InputDecoration(labelText: t.campoGenero),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _guardar, child: Text(t.guardar)),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// 5. SOCIOS
// =====================================================================

/// Diálogo para crear o editar un socio.
Future<void> dialogoSocio(BuildContext context, [Socio? s]) async {
  final t = AppLocalizations.of(context)!;
  final alias = TextEditingController(text: s?.alias ?? '');
  final curso = TextEditingController(text: s?.curso ?? '');
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(s == null ? t.nuevoSocio : t.editarSocio),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: alias,
            decoration: InputDecoration(labelText: t.campoAlias),
          ),
          TextField(
            controller: curso,
            decoration: InputDecoration(labelText: t.campoCurso),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: Text(t.cancelar),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: Text(t.guardar),
        ),
      ],
    ),
  );
  if (ok == true && alias.text.trim().isNotEmpty) {
    await ctrl.guardarSocio(
      Socio(id: s?.id, alias: alias.text.trim(), curso: curso.text.trim()),
    );
  }
}

class PantallaSocios extends StatelessWidget {
  const PantallaSocios({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.navSocios)),
      floatingActionButton: FloatingActionButton(
        tooltip: t.anadirSocio,
        onPressed: () => dialogoSocio(context),
        child: const Icon(Icons.person_add),
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) => ListView(
          children: [
            for (final s in ctrl.socios)
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(s.alias),
                subtitle: Text(s.curso),
                onTap: () => ir(context, PantallaFichaSocio(s)),
                trailing: IconButton(
                  tooltip: t.borrar,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final ok = await ctrl.borrarSocio(s.id!);
                    if (context.mounted) {
                      aviso(
                        context,
                        ok ? t.socioBorrado : t.noSePuedeBorrar,
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// 6. FICHA DE SOCIO
// =====================================================================
class PantallaFichaSocio extends StatelessWidget {
  final Socio socio;
  const PantallaFichaSocio(this.socio, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        final s = ctrl.socios.firstWhere(
          (x) => x.id == socio.id,
          orElse: () => socio,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(s.alias),
            actions: [
              IconButton(
                tooltip: t.editar,
                icon: const Icon(Icons.edit),
                onPressed: () => dialogoSocio(context, s),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(title: Text(t.campoAlias), subtitle: Text(s.alias)),
              ListTile(title: Text(t.campoCurso), subtitle: Text(s.curso)),
              FilledButton.icon(
                icon: const Icon(Icons.outbox),
                label: Text(t.nuevoPrestamoSocio),
                onPressed: () => ir(context, PantallaNuevoPrestamo(socio: s)),
              ),
              const Divider(height: 32),
              Text(
                t.historialPrestamos,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FutureBuilder<List<Map<String, Object?>>>(
                future: ctrl.prestamosDeSocio(s.id!),
                builder: (context, snap) {
                  if (!snap.hasData) return const LinearProgressIndicator();
                  if (snap.data!.isEmpty) return Text(t.sinPrestamos);
                  return Column(
                    children: [
                      for (final p in snap.data!)
                        ListTile(
                          dense: true,
                          title: Text('${p['titulo']}'),
                          subtitle: Text(
                            '${t.salidaFecha(DateTime.parse(p['fecha_salida'] as String))} · '
                            '${p['fecha_devolucion'] == null ? t.sinDevolver : t.devueltoFecha(DateTime.parse(p['fecha_devolucion'] as String))}',
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================================
// 7. PRÉSTAMOS ACTIVOS
// =====================================================================
class PantallaPrestamos extends StatelessWidget {
  const PantallaPrestamos({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: ctrl,
          builder: (context, _) => Text(
            t.prestamosActivosTitulo(ctrl.activos.length),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.nuevoPrestamo,
        onPressed: () => ir(context, const PantallaNuevoPrestamo()),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          if (ctrl.activos.isEmpty) {
            return Center(child: Text(t.noHayPrestamosActivos));
          }
          final vencidos = ctrl.vencidos.map((v) => v['prestamo_id']).toSet();
          return ListView(
            children: [
              for (final p in ctrl.activos)
                ListTile(
                  leading: Icon(
                    vencidos.contains(p['prestamo_id'])
                        ? Icons.warning_amber
                        : Icons.book,
                    color: vencidos.contains(p['prestamo_id'])
                        ? Colors.orange
                        : null,
                  ),
                  title: Text('${p['titulo']}'),
                  subtitle: Text(
                    '${t.socioAlias(p['alias'] as String)} · '
                    '${t.salidaEl(DateTime.parse(p['fecha_salida'] as String))}',
                  ),
                  trailing: TextButton(
                    child: Text(t.devolver),
                    onPressed: () async {
                      final libroId = p['libro_id'] as int;
                      await ctrl.devolver(p['prestamo_id'] as int);
                      if (context.mounted) {
                        ir(context, PantallaValoracion(libroId: libroId));
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================================
// 8. NUEVO PRÉSTAMO
// =====================================================================
class PantallaNuevoPrestamo extends StatefulWidget {
  final Libro? libro;
  final Socio? socio;
  const PantallaNuevoPrestamo({super.key, this.libro, this.socio});

  @override
  State<PantallaNuevoPrestamo> createState() => _PantallaNuevoPrestamoState();
}

class _PantallaNuevoPrestamoState extends State<PantallaNuevoPrestamo> {
  int? _libroId;
  int? _socioId;

  @override
  void initState() {
    super.initState();
    _libroId = widget.libro?.id;
    _socioId = widget.socio?.id;
  }

  Future<void> _guardar() async {
    final mensaje = await ctrl.nuevoPrestamo(_libroId!, _socioId!);
    if (!mounted) return;
    if (mensaje != null) {
      aviso(context, mensaje);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final disponibles = ctrl.todos
        .where((l) => !ctrl.librosPrestados.contains(l.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(t.nuevoPrestamo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.libroSoloDisponibles),
          DropdownButton<int>(
            isExpanded: true,
            hint: Text(t.eligeLibro),
            value: disponibles.any((l) => l.id == _libroId) ? _libroId : null,
            items: [
              for (final l in disponibles)
                DropdownMenuItem(value: l.id!, child: Text(l.titulo)),
            ],
            onChanged: (v) => setState(() => _libroId = v),
          ),
          const SizedBox(height: 16),
          Text(t.socio),
          DropdownButton<int>(
            isExpanded: true,
            hint: Text(t.eligeSocio),
            value: ctrl.socios.any((s) => s.id == _socioId) ? _socioId : null,
            items: [
              for (final s in ctrl.socios)
                DropdownMenuItem(
                  value: s.id!,
                  child: Text('${s.alias} (${s.curso})'),
                ),
            ],
            onChanged: (v) => setState(() => _socioId = v),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: (_libroId == null || _socioId == null) ? null : _guardar,
            child: Text(t.guardarPrestamo),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// 9. VALORACIÓN POR GESTOS
// =====================================================================
class PantallaValoracion extends StatefulWidget {
  final int? libroId;
  const PantallaValoracion({super.key, this.libroId});

  @override
  State<PantallaValoracion> createState() => _PantallaValoracionState();
}

class _PantallaValoracionState extends State<PantallaValoracion> {
  int? _libroId;
  String _feedback = '';
  int _valor = 0;
  int _version = 0; // fuerza a ThumbRating a reflejar el gesto de la cámara

  @override
  void initState() {
    super.initState();
    _libroId = widget.libroId;
  }

  String _textoValor(AppLocalizations t, int v) =>
      v == 1 ? t.pulgarArriba : (v == -1 ? t.pulgarAbajo : t.sinValorar);

  /// Valoración recibida de los botones (táctil) o de la cámara (gesto).
  void _valorar(int v, String origen) {
    final t = AppLocalizations.of(context)!;
    final libro = ctrl.todos.firstWhere((l) => l.id == _libroId);
    setState(() {
      _valor = v;
      _feedback = _textoValor(t, v);
      if (origen == 'cámara') _version++;
    });
    ctrl.valorar(libro, v, origen: origen);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.navValoracion)),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          final existe = ctrl.todos.any((l) => l.id == _libroId);
          final historial = ctrl.registrosNui
              .where((r) => r['tipo'] == 'gesto')
              .take(5);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(t.eligeLibroValorar),
              const SizedBox(height: 8),
              DropdownButton<int>(
                isExpanded: true,
                hint: Text(t.libroHint),
                value: existe ? _libroId : null,
                items: [
                  for (final l in ctrl.todos)
                    DropdownMenuItem(
                      value: l.id!,
                      child: Text(
                        l.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() {
                  _libroId = v;
                  _feedback = '';
                  _valor = 0;
                }),
              ),
              const SizedBox(height: 24),
              if (existe)
                Center(
                  child: pulgares(
                    context,
                    key: ValueKey('$_libroId-$_version'),
                    inicial: _valor,
                    onChanged: (v) => _valorar(v, 'táctil'),
                  ),
                ),
              if (existe) ...[
                const SizedBox(height: 16),
                Text(t.maquetaAR),
                VistaManos(
                  onGesto: (v) => _valorar(v, 'cámara'),
                  superposicion: FichaFlotante(
                    libro: ctrl.todos.firstWhere((l) => l.id == _libroId),
                  ),
                ),
              ],
              if (_feedback.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _feedback,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              const Divider(height: 32),
              Text(
                t.ultimasValoraciones,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (historial.isEmpty) Text(t.todaviaNoValoraciones),
              for (final r in historial)
                ListTile(dense: true, title: Text('${r['detalle']}')),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================================
// 10. AJUSTES Y PERMISOS
// =====================================================================
class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.navAjustes)),
      body: ListenableBuilder(
        listenable: Listenable.merge([ctrl, nui]),
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: modoTema,
              builder: (context, modo, _) => SwitchListTile(
                title: Text(t.modoOscuro),
                value: modo == ThemeMode.dark,
                onChanged: (v) =>
                    modoTema.value = v ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
            ValueListenableBuilder<Locale>(
              valueListenable: idioma,
              builder: (context, loc, _) => ListTile(
                leading: const Icon(Icons.language),
                title: Text(t.idioma),
                trailing: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'es', label: Text('ES')),
                    ButtonSegment(value: 'en', label: Text('EN')),
                  ],
                  selected: {loc.languageCode},
                  onSelectionChanged: (s) => idioma.value = Locale(s.first),
                ),
              ),
            ),
            SwitchListTile(
              title: Text(t.respuestasHabladas),
              value: nui.hablar,
              onChanged: nui.cambiarHablar,
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: Text(t.permisoMicrofono),
              subtitle: Text(textoMic(t, nui.estadoMic)),
              trailing: TextButton(
                onPressed: nui.iniciarVoz,
                child: Text(t.comprobar),
              ),
            ),
            ValueListenableBuilder<EstadoCamara>(
              valueListenable: estadoCamara,
              builder: (context, estado, _) => ListTile(
                leading: const Icon(Icons.videocam),
                title: Text(t.permisoCamara),
                subtitle: Text(textoCamara(t, estado)),
                trailing: Text(t.sePideAlValorar),
              ),
            ),
            const Divider(height: 32),
            Text(
              t.avisoPrivacidadTitulo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(t.avisoPrivacidadAjustes),
            const Divider(height: 32),
            Text(
              t.registroNui,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (ctrl.registrosNui.isEmpty) Text(t.sinRegistros),
            for (final r in ctrl.registrosNui.take(10))
              ListTile(
                dense: true,
                title: Text('${r['detalle']}'),
                subtitle: Text('${r['tipo']} · ${soloFecha(r['fecha'])}'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Ficha flotante de realidad aumentada (maqueta 2D): se dibuja sobre la imagen
/// de la cámara y se arrastra hasta colocarla sobre el libro físico.
class FichaFlotante extends StatefulWidget {
  final Libro libro;
  const FichaFlotante({super.key, required this.libro});

  @override
  State<FichaFlotante> createState() => _FichaFlotanteState();
}

class _FichaFlotanteState extends State<FichaFlotante> {
  Offset _pos = const Offset(16, 16);
  double? _nota;
  int _votos = 0;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(_cargar); // se actualiza al cambiar las valoraciones
    _cargar();
  }

  @override
  void didUpdateWidget(FichaFlotante old) {
    super.didUpdateWidget(old);
    if (old.libro.id != widget.libro.id) _cargar();
  }

  @override
  void dispose() {
    ctrl.removeListener(_cargar);
    super.dispose();
  }

  Future<void> _cargar() async {
    final m = await ctrl.mediaValoracion(widget.libro.id!);
    if (!mounted) return;
    setState(() {
      _nota = m.nota;
      _votos = m.votos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Positioned(
          left: _pos.dx,
          top: _pos.dy,
          child: GestureDetector(
            onPanUpdate: (d) => setState(() => _pos += d.delta),
            onPanEnd: (_) => ctrl.registrarNui(
              'ar',
              'Ficha de "${widget.libro.titulo}" colocada sobre el libro',
            ),
            child: Card(
              color: const Color(0xB3000000),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.libro.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.libro.autor,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _nota == null
                                ? t.sinValoraciones
                                : '${_nota!.toStringAsFixed(1)} / 5 · $_votos',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
