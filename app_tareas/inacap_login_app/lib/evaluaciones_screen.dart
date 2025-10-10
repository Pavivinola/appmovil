import 'package:flutter/material.dart';
import 'models/evaluacion.dart';

class EvaluacionesScreen extends StatelessWidget {
  const EvaluacionesScreen({super.key});

  Color _colorEstado(String estado) {
    switch (estado) {
      case "Completada":
        return Colors.green.shade700;
      case "Vencida":
        return Colors.red.shade700;
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    const rojoInacap = Color(0xFFB71C1C);

    final evaluaciones = [
      Evaluacion(title: "Programación Móvil", dueDate: DateTime(2025, 10, 20)),
      Evaluacion(
          title: "Bases de Datos II",
          dueDate: DateTime(2025, 10, 25),
          isDone: true),
      Evaluacion(title: "Redes y Seguridad", dueDate: DateTime(2025, 9, 30)),
      Evaluacion(title: "Plan de Pruebas", dueDate: DateTime(2025, 11, 2)),
      Evaluacion(
          title: "Ingeniería de Software", dueDate: DateTime(2025, 11, 10)),
    ];

    evaluaciones.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Evaluaciones'),
        backgroundColor: rojoInacap,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.builder(
          itemCount: evaluaciones.length,
          itemBuilder: (context, index) {
            final e = evaluaciones[index];
            return Card(
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: rojoInacap.withOpacity(0.15),
                  child: Icon(
                    e.estado == "Completada"
                        ? Icons.check_circle
                        : e.estado == "Vencida"
                            ? Icons.error_outline
                            : Icons.pending_actions,
                    color: _colorEstado(e.estado),
                    size: 28,
                  ),
                ),
                title: Text(
                  e.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Fecha: ${e.dueDate.day}/${e.dueDate.month}/${e.dueDate.year}',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _colorEstado(e.estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _colorEstado(e.estado).withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    e.estado,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _colorEstado(e.estado),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
