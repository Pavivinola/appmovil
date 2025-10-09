// lib/widgets/filter_menu_button.dart
import 'package:app_tareas/models/task.dart';
import 'package:flutter/material.dart';

class FilterMenuButton extends StatelessWidget {
  const FilterMenuButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskFilter value;
  final ValueChanged<TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskFilter>(
      tooltip: "Filtro",
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: TaskFilter.all,
          child: Text("Todas"),
        ),
        PopupMenuItem(
          value: TaskFilter.pending,
          child: Text("Pendientes"),
        ),
        PopupMenuItem(
          value: TaskFilter.done,
          child: Text("Realizadas"),
        ),
        PopupMenuItem(
          value: TaskFilter.overdue,
          child: Text("Vencidas"),
        ),
      ],
      icon: const Icon(Icons.filter_list),
    );
  }
}
