// Importa utilidades de Flutter (como ChangeNotifier)
import 'package:flutter/foundation.dart';
// Importa el modelo de datos de tareas
import '../models/task.dart';

// Controlador que maneja la lista de tareas y la lógica
class TaskController extends ChangeNotifier {
  // Lista privada de tareas iniciales (5 de ejemplo)
  final List<Task> _tasks = [
    // Pendiente con fecha futura
    Task(
      title: 'Revisar enunciado de evaluación',
      note: 'Sección B',
      due: DateTime.now().add(const Duration(days: 4)),
    ),
    // Pendiente sin fecha
    Task(
      title: 'Publicar fechas de rendición en Aula',
    ),
    // Realizada
    Task(
      title: 'Subir rúbrica a Aula',
      done: true,
    ),
    // Realizada
    Task(
      title: 'Cargar notas parciales',
      done: true,
    ),
    // Vencida (no hecha y con fecha en el pasado)
    Task(
      title: 'Responder correos de alumnos',
      due: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Texto para búsqueda
  String _query = '';
  // Filtro actual (todas, pendientes, completadas, vencidas)
  TaskFilter _filter = TaskFilter.all;

  // ----- Lecturas (getters) -----

  // Devuelve la lista de tareas, pero como lista de solo lectura
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Devuelve el texto de búsqueda actual
  String get query => _query;

  // Devuelve el filtro actual
  TaskFilter get filter => _filter;

  // Devuelve la lista de tareas filtradas por búsqueda y filtro
  List<Task> get filtered {
    final q = _query.trim().toLowerCase(); // texto de búsqueda en minúsculas
    return _tasks.where((t) {
      // Filtra por estado (switch expression exhaustivo)
      final byFilter = switch (_filter) {
        TaskFilter.all     => true,        // todas
        TaskFilter.pending => !t.done,     // solo no completadas
        TaskFilter.done    => t.done,      // solo completadas
        TaskFilter.overdue => t.isOverdue, // solo vencidas (getter en Task)
      };

      // Filtra por coincidencia con el texto
      final byQuery = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          (t.note?.toLowerCase().contains(q) ?? false);

      // La tarea pasa si cumple ambos filtros
      return byFilter && byQuery;
    }).toList();
  }

  // ----- Mutaciones (acciones que cambian datos) -----

  // Cambia el texto de búsqueda
  void setQuery(String value) {
    _query = value;
    notifyListeners(); // avisa a la UI que hubo un cambio
  }

  // Cambia el filtro de tareas
  void setFilter(TaskFilter f) {
    _filter = f;
    notifyListeners();
  }

  /// Intenta marcar/desmarcar una tarea como realizada.
  /// Si se intenta marcar como realizada una tarea vencida, se BLOQUEA y retorna false.
  bool toggle(Task t, bool v) {
    if (v && t.isOverdue) {
      // Bloquea completar si está vencida
      return false;
    }
    t.done = v;
    notifyListeners();
    return true;
  }

  // Agrega una nueva tarea al inicio de la lista
  void add(String title, {String? note, DateTime? due}) {
    _tasks.insert(0, Task(title: title, note: note, due: due));
    notifyListeners();
  }

  // Elimina una tarea de la lista
  void remove(Task t) {
    _tasks.remove(t);
    notifyListeners();
  }
}
