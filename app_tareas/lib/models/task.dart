// lib/models/task.dart
class Task {
  Task({
    required this.title,
    this.done = false,
    this.note,
    this.due,
  });

  String title;      // título de la evaluación
  bool done;         // true si está completada
  String? note;      // unidad / nota opcional
  DateTime? due;     // fecha de rendición

  /// Vencida = tiene fecha, no está hecha y la fecha (sin hora) es anterior a hoy.
  bool get isOverdue {
    if (done || due == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(due!.year, due!.month, due!.day);
    return d.isBefore(today);
  }

  // Opcional: útil si trabajas con inmutabilidad
  Task copyWith({
    String? title,
    bool? done,
    String? note,
    DateTime? due,
  }) {
    return Task(
      title: title ?? this.title,
      done: done ?? this.done,
      note: note ?? this.note,
      due: due ?? this.due,
    );
  }
}

/// Filtros posibles para la lista de evaluaciones
enum TaskFilter {
  all,      // todas
  pending,  // pendientes (no hechas)
  done,     // Realizadas
  overdue,  // vencidas (no hechas y con fecha anterior a hoy)
}
