import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'camara_manos.dart';
import 'controlador.dart';
import 'db.dart';
import 'nui.dart';
import 'widgets.dart';

// ---------- Utilidades ----------

void ir(BuildContext context, Widget pantalla) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));

void aviso(BuildContext context, String mensaje) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));

String soloFecha(Object? iso) => (iso as String).substring(0, 10);

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
    final orden = _orden;
    final enviar = _enviar;
    return CallbackShortcuts(
      // F2 simula la sacudida del móvil en el ordenador.
      bindings: {const SingleActivator(LogicalKeyboardKey.f2): nui.sacudir},
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text('BiblioVoz')),
          body: ListenableBuilder(
            listenable: Listenable.merge([ctrl, nui]),
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AvisoPrivacidad(),
                const SizedBox(height: 16),
                PanelVoz(orden: orden, enviar: enviar),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: nui.sacudir,
                  icon: const Icon(Icons.vibration),
                  label: const Text('Proponer libro al azar (sacudir / F2)'),
                ),
                if (nui.sugerencia != null)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.auto_awesome),
                      title: Text(nui.sugerencia!.titulo),
                      subtitle: Text(nui.sugerencia!.autor),
                      onTap: () =>
                          ir(context, PantallaFichaLibro(nui.sugerencia!)),
                    ),
                  ),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: const Text('Catálogo'),
                  onTap: () => ir(context, const PantallaCatalogo()),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Socios'),
                  onTap: () => ir(context, const PantallaSocios()),
                ),
                ListTile(
                  leading: const Icon(Icons.outbox),
                  title: const Text('Préstamos activos'),
                  onTap: () => ir(context, const PantallaPrestamos()),
                ),
                ListTile(
                  leading: const Icon(Icons.thumbs_up_down),
                  title: const Text('Valoración por gestos'),
                  onTap: () => ir(context, const PantallaValoracion()),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Ajustes y permisos'),
                  onTap: () => ir(context, const PantallaAjustes()),
                ),
                const Divider(height: 32),
                Text(
                  'Préstamos vencidos (JOIN)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (ctrl.vencidos.isEmpty) const Text('Ninguno'),
                ...ctrl.vencidos.map(
                  (v) => ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                    ),
                    title: Text('${v['titulo']}'),
                    subtitle: Text(
                      'Socio: ${v['alias']} · salida ${soloFecha(v['fecha_salida'])}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Préstamos por género (COUNT)',
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
            ),
          ),
        ),
      ),
    );
  }
}

class PanelVoz extends StatelessWidget {
  const PanelVoz({
    super.key,
    required this.orden,
    required this.enviar,
  });

  final TextEditingController orden;
  final void Function(String texto) enviar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Órdenes de voz',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: nui.escuchando ? nui.detener : nui.escuchar,
          icon: Icon(nui.escuchando ? Icons.mic : Icons.mic_none),
          label: Text(
            nui.escuchando
                ? 'Escuchando… (pulsa para parar)'
                : 'Hablar',
          ),
        ),
        if (nui.escuchando) const LinearProgressIndicator(),
        if (nui.ultimoTexto.isNotEmpty)
          Text('Has dicho: ${nui.ultimoTexto}'),
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
                decoration: const InputDecoration(
                  labelText: 'O escribe una orden',
                  hintText: 'Busca libros de ciencia ficción',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: enviar,
              ),
            ),
            IconButton(
              tooltip: 'Enviar',
              icon: const Icon(Icons.send),
              onPressed: () => enviar(orden.text),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Órdenes: «Busca libros de ciencia ficción» · «Devuelve el préstamo del libro Dune»',
        ),
      ],
    );
  }
}

class AvisoPrivacidad extends StatelessWidget {
  const AvisoPrivacidad({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Privacidad: el micrófono solo se usa para tus órdenes de voz. '
            'El navegador procesa el audio y no se guarda; en la base de '
            'datos solo se guarda el texto de la orden.',
          ),
        ),
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
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            _foco.requestFocus,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text('Catálogo')),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Añadir libro',
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
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar por título, autor o género (Ctrl+F)',
                    border: OutlineInputBorder(),
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
                      return const Center(child: Text('Sin resultados'));
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
                                ok
                                    ? 'Libro borrado'
                                    : 'No se puede borrar: tiene préstamos',
                              );
                            }
                            return false; // la lista ya se recarga sola
                          },
                          child: BookCard(
                            libro: l,
                            prestado: ctrl.librosPrestados.contains(l.id),
                            onTap: () => ir(context, PantallaFichaLibro(l)),
                            onLoan: () =>
                                ir(context, PantallaNuevoPrestamo(libro: l)),
                          ),
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
                tooltip: 'Editar',
                icon: const Icon(Icons.edit),
                onPressed: () => ir(context, PantallaAltaLibro(libro: l)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Icon(Icons.menu_book, size: 96),
              ListTile(title: const Text('Título'), subtitle: Text(l.titulo)),
              ListTile(title: const Text('Autor'), subtitle: Text(l.autor)),
              ListTile(title: const Text('ISBN'), subtitle: Text(l.isbn)),
              ListTile(title: const Text('Género'), subtitle: Text(l.genero)),
              ListTile(
                title: const Text('Estado'),
                subtitle: Text(prestado ? 'Prestado' : 'Disponible'),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.outbox),
                label: const Text('Prestar este libro'),
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

  String? _obligatorio(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.libro == null ? 'Nuevo libro' : 'Editar libro'),
      ),
      body: Form(
        key: _clave,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: _obligatorio,
            ),
            TextFormField(
              controller: _autor,
              decoration: const InputDecoration(labelText: 'Autor'),
              validator: _obligatorio,
            ),
            TextFormField(
              controller: _isbn,
              decoration: const InputDecoration(labelText: 'ISBN'),
            ),
            TextFormField(
              controller: _genero,
              decoration: const InputDecoration(labelText: 'Género'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _guardar, child: const Text('Guardar')),
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
  final alias = TextEditingController(text: s?.alias ?? '');
  final curso = TextEditingController(text: s?.curso ?? '');
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(s == null ? 'Nuevo socio' : 'Editar socio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: alias,
            decoration: const InputDecoration(labelText: 'Alias'),
          ),
          TextField(
            controller: curso,
            decoration: const InputDecoration(labelText: 'Curso'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Guardar'),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Socios')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Añadir socio',
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
                  tooltip: 'Borrar',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final ok = await ctrl.borrarSocio(s.id!);
                    if (context.mounted) {
                      aviso(
                        context,
                        ok
                            ? 'Socio borrado'
                            : 'No se puede borrar: tiene préstamos',
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
                tooltip: 'Editar',
                icon: const Icon(Icons.edit),
                onPressed: () => dialogoSocio(context, s),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(title: const Text('Alias'), subtitle: Text(s.alias)),
              ListTile(title: const Text('Curso'), subtitle: Text(s.curso)),
              FilledButton.icon(
                icon: const Icon(Icons.outbox),
                label: const Text('Nuevo préstamo para este socio'),
                onPressed: () => ir(context, PantallaNuevoPrestamo(socio: s)),
              ),
              const Divider(height: 32),
              Text(
                'Historial de préstamos (JOIN)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FutureBuilder<List<Map<String, Object?>>>(
                future: ctrl.prestamosDeSocio(s.id!),
                builder: (context, snap) {
                  if (!snap.hasData) return const LinearProgressIndicator();
                  if (snap.data!.isEmpty) return const Text('Sin préstamos');
                  return Column(
                    children: [
                      for (final p in snap.data!)
                        ListTile(
                          dense: true,
                          title: Text('${p['titulo']}'),
                          subtitle: Text(
                            'Salida ${soloFecha(p['fecha_salida'])} · ${p['fecha_devolucion'] == null ? 'sin devolver' : 'devuelto ${soloFecha(p['fecha_devolucion'])}'}',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Préstamos activos')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nuevo préstamo',
        onPressed: () => ir(context, const PantallaNuevoPrestamo()),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          if (ctrl.activos.isEmpty) {
            return const Center(child: Text('No hay préstamos activos'));
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
                    'Socio: ${p['alias']} · salida ${soloFecha(p['fecha_salida'])}',
                  ),
                  trailing: TextButton(
                    child: const Text('Devolver'),
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
    final disponibles = ctrl.todos
        .where((l) => !ctrl.librosPrestados.contains(l.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo préstamo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Libro (solo los disponibles)'),
          DropdownButton<int>(
            isExpanded: true,
            hint: const Text('Elige un libro'),
            value: disponibles.any((l) => l.id == _libroId) ? _libroId : null,
            items: [
              for (final l in disponibles)
                DropdownMenuItem(value: l.id!, child: Text(l.titulo)),
            ],
            onChanged: (v) => setState(() => _libroId = v),
          ),
          const SizedBox(height: 16),
          const Text('Socio'),
          DropdownButton<int>(
            isExpanded: true,
            hint: const Text('Elige un socio'),
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
            child: const Text('Guardar préstamo'),
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

  String _textoValor(int v) =>
      v == 1 ? 'Pulgar arriba' : (v == -1 ? 'Pulgar abajo' : 'Sin valorar');

  /// Valoración recibida de los botones (táctil) o de la cámara (gesto).
  void _valorar(int v, String origen) {
    final libro = ctrl.todos.firstWhere((l) => l.id == _libroId);
    setState(() {
      _valor = v;
      _feedback = _textoValor(v);
      if (origen == 'cámara') _version++;
    });
    ctrl.valorar(libro, v, origen: origen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Valoración por gestos')),
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
              const Text('Elige el libro devuelto y valóralo con el pulgar.'),
              const SizedBox(height: 8),
              DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Libro'),
                value: existe ? _libroId : null,
                items: [
                  for (final l in ctrl.todos)
                    DropdownMenuItem(value: l.id!, child: Text(l.titulo)),
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
                  child: ThumbRating(
                    key: ValueKey('$_libroId-$_version'),
                    initialValue: _valor,
                    onChanged: (v) => _valorar(v, 'táctil'),
                  ),
                ),
              if (existe) ...[
                const SizedBox(height: 16),
                const Text(
                  'Realidad aumentada (maqueta): activa la cámara y arrastra '
                  'la ficha sobre tu libro físico.',
                ),
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
                'Últimas valoraciones (SQLite)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (historial.isEmpty) const Text('Todavía no hay valoraciones'),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes y permisos')),
      body: ListenableBuilder(
        listenable: Listenable.merge([ctrl, nui]),
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: modoTema,
              builder: (context, modo, _) => SwitchListTile(
                title: const Text('Modo oscuro'),
                value: modo == ThemeMode.dark,
                onChanged: (v) =>
                    modoTema.value = v ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
            SwitchListTile(
              title: const Text('Respuestas habladas'),
              value: nui.hablar,
              onChanged: nui.cambiarHablar,
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Permiso de micrófono'),
              subtitle: Text(nui.estadoMic),
              trailing: TextButton(
                onPressed: nui.iniciarVoz,
                child: const Text('Comprobar'),
              ),
            ),
            ValueListenableBuilder<String>(
              valueListenable: estadoCamara,
              builder: (context, estado, _) => ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Permiso de cámara'),
                subtitle: Text(estado),
                trailing: const Text('Se pide al valorar'),
              ),
            ),
            const Divider(height: 32),
            Text(
              'Aviso de privacidad',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text(
              'BiblioVoz usa el micrófono solo cuando pulsas «Hablar» y la cámara '
              'solo cuando pulsas «Valorar con la cámara». El audio y la imagen los '
              'procesa el navegador: no se envían ni se almacenan. En la base de '
              'datos solo se guarda el texto de las órdenes, las sacudidas y las '
              'valoraciones.',
            ),
            const Divider(height: 32),
            Text(
              'Registro de la interfaz natural (SQLite)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (ctrl.registrosNui.isEmpty) const Text('Sin registros'),
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
                                ? 'Sin valoraciones'
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
