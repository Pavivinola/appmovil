class Evaluacion {
  String title;
  String? note;
  DateTime dueDate;
  bool isDone;

  Evaluacion({
    required this.title,
    this.note,
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
