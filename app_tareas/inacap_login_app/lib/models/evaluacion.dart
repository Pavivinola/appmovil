class Evaluacion {
  final String title;
  final DateTime dueDate;
  final bool isDone;

  Evaluacion({
    required this.title,
    required this.dueDate,
    this.isDone = false,
  });

  String get estado {
    final now = DateTime.now();
    if (isDone) return "Completada";
    if (dueDate.isBefore(now)) return "Vencida";
    return "Pendiente";
  }
}
