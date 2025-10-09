// lib/utils/filters.dart
import 'package:app_tareas/models/task.dart';

/// Aplica el filtro seleccionado a la colección de tareas/evaluaciones.
Iterable<Task> applyFilter(Iterable<Task> tasks, TaskFilter filter) {
  switch (filter) {
    case TaskFilter.all:
      return tasks;
    case TaskFilter.pending:
      return tasks.where((t) => !t.done);
    case TaskFilter.done:
      return tasks.where((t) => t.done);
    case TaskFilter.overdue:
      return tasks.where((t) => t.isOverdue);
  }
}
