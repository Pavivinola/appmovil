// Importa el paquete de Flutter con widgets Material
import 'package:app_tareas/utils/date_utils.dart';
import 'package:flutter/material.dart';

// Widget de formulario para crear una nueva tarea
class NewTaskSheet extends StatefulWidget {
  const NewTaskSheet({
    super.key,
    required this.onSubmit, // Callback final que recibe (title, note, due)
    this.initialTitle = '', // Título inicial (útil para editar)
    this.initialNote,       // Nota inicial (útil para editar)
    this.initialDue,        // Fecha inicial (útil para editar)
    this.submitLabel = 'Crear', // Texto del botón principal (p. ej. "Crear"/"Guardar")
    this.titleText = 'Nueva Evaluación', // Título del formulario
  });

  final void Function(String title, String? note, DateTime? due) onSubmit;
  final String initialTitle;
  final String? initialNote;
  final DateTime? initialDue;
  final String submitLabel;
  final String titleText;

  @override
  State<NewTaskSheet> createState() => _NewTaskSheetState();
}

// Estado del formulario de nueva tarea
class _NewTaskSheetState extends State<NewTaskSheet> {
  // Llave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores y focos
  late final TextEditingController _titleCtrl;
  late final TextEditingController _noteCtrl;
  final _titleFocus = FocusNode();
  final _noteFocus = FocusNode();

  DateTime? _due;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle);
    _noteCtrl = TextEditingController(text: widget.initialNote ?? "");
    _due = widget.initialDue;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: "Selecciona una fecha de rendición",
      cancelText: "Cancelar",
      confirmText: "Aceptar",
    );
    if (picked != null) {
      setState(() {
        _due = DateTime(picked.year, picked.month, picked.day, 23, 59);
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _noteFocus.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleCtrl.text.trim();
    final note = _noteCtrl.text.trim();
    // Puedes dejar esta línea por seguridad; el validador ya impide vacío.
    widget.onSubmit(title, note.isEmpty ? null : note, _due);
  }

  @override
  Widget build(BuildContext context) {
    // Widget que representa el formulario
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título del formulario
          Text(
            widget.titleText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // Campo para ingresar el título de la evaluación
          TextFormField(
            controller: _titleCtrl,
            autofocus: true,
            focusNode: _titleFocus,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Título de la evaluación',
              hintText: 'Ej: Evaluación 1 Aplicaciones Móviles',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(),
              filled: true,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ingrese un título' : null,
          ),
          const SizedBox(height: 12),

          // Campo para ingresar la unidad (OBLIGATORIA)
          TextFormField(
            controller: _noteCtrl,
            focusNode: _noteFocus,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              labelText: 'Unidad a evaluar',
              prefixIcon: Icon(Icons.note_outlined),
              border: OutlineInputBorder(),
              filled: true,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ingrese la unidad a evaluar'
                : null,
          ),
          const SizedBox(height: 16),

          // Fecha de rendición (OBLIGATORIA) usando FormField<DateTime>
          FormField<DateTime>(
            validator: (_) =>
                _due == null ? 'Seleccione una fecha de rendición' : null,
            builder: (state) {
              return InkWell(
                onTap: () async {
                  await _pickDueDate();
                  // Notifica al FormField del nuevo valor y revalida
                  state.didChange(_due);
                  state.validate();
                },
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Fecha de rendición",
                    border: const OutlineInputBorder(),
                    filled: true,
                    errorText: state.errorText, // Muestra error debajo
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _due == null ? "Sin fecha" : formatShortDate(_due!),
                        ),
                      ),
                      if (_due != null)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _due = null;
                            });
                            state.didChange(_due);
                            state.validate();
                          },
                          icon: const Icon(Icons.close),
                          label: const Text("Quitar"),
                        ),
                      TextButton.icon(
                        onPressed: () async {
                          await _pickDueDate();
                          state.didChange(_due);
                          state.validate();
                        },
                        icon: const Icon(Icons.edit_calendar),
                        label: Text(_due == null ? "Elegir" : "Cambiar"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Botón para crear/guardar
          SizedBox(
            height: 48,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.red,    // color de fondo
                  onPrimary: Colors.white, // color del texto/ícono
                ),
              ),
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: Text(widget.submitLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
