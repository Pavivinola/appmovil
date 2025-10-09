import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/widgets/taskWidgets/swipe_bg.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDismissed,
    required this.swipeColor,
    this.dateText,
    this.itemKey,
  });

  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDismissed;
  final Color swipeColor;
  final String? dateText;
  final Object? itemKey;

  @override
  Widget build(BuildContext context) {
    final k = itemKey ?? '${task.title}-${task.hashCode}';
    final isOverdue = task.isOverdue;

    // Trailing según estado: check verde / X roja / handle
    final Widget trailingIcon = task.done
        ? const Icon(Icons.check, color: Colors.green)
        : (isOverdue
            ? const Icon(Icons.close, color: Colors.red) // X roja
            : const Icon(Icons.drag_handle));

    return Dismissible(
      key: ValueKey(k),
      // Si está vencida, no se puede deslizar
      direction: isOverdue ? DismissDirection.none : DismissDirection.horizontal,
      background: SwipeBg(alineacion: Alignment.centerLeft, color: swipeColor),
      secondaryBackground: SwipeBg(
        alineacion: Alignment.centerRight,
        color: swipeColor,
      ),
      confirmDismiss: (dir) async {
        if (isOverdue) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No puedes completar/eliminar una evaluación vencida.'),
            ),
          );
          return false;
        }
        return true;
      },
      onDismissed: (_) => onDismissed(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: CheckboxListTile(
          value: task.done,
          // Deshabilita el checkbox si está vencida
          onChanged: isOverdue ? null : (v) => onToggle(v ?? false),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.note != null && task.note!.isNotEmpty) Text(task.note!),
              if (dateText != null)
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 16,
                      // Si está vencida, pinta el ícono rojo también
                      color: isOverdue ? Colors.red : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dateText!,
                      // Si está vencida, pinta la fecha en rojo
                      style: TextStyle(color: isOverdue ? Colors.red : null),
                    ),
                  ],
                ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          secondary: trailingIcon,
        ),
      ),
    );
  }
}
