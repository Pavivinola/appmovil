import 'package:flutter/material.dart';
import 'models/evaluacion.dart';

class EvaluacionesScreen extends StatefulWidget {
  const EvaluacionesScreen({super.key});

  @override
  State<EvaluacionesScreen> createState() => _EvaluacionesScreenState();
}

class _EvaluacionesScreenState extends State<EvaluacionesScreen> {
  final rojoInacap = const Color(0xFFB71C1C);
  final TextEditingController _searchCtrl = TextEditingController();

  List<Evaluacion> evaluaciones = [
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

  String filtro = "Todas";

  // ============================
  // FILTRADO DE LISTA
  // ============================
  List<Evaluacion> get _evaluacionesFiltradas {
    final query = _searchCtrl.text.toLowerCase();
    var lista = evaluaciones.where((e) {
      final titulo = e.title.toLowerCase();
      return titulo.contains(query);
    }).toList();

    if (filtro == "Pendientes") {
      lista = lista.where((e) => !e.isDone && e.estado == "Pendiente").toList();
    } else if (filtro == "Completadas") {
      lista = lista.where((e) => e.isDone).toList();
    }

    lista.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return lista;
  }

  // ============================
  // CREAR NUEVA EVALUACIÓN
  // ============================
  void _nuevaEvaluacion() {
    final tituloCtrl = TextEditingController();
    final notaCtrl = TextEditingController();
    DateTime? fechaSeleccionada;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Nueva Evaluación",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: rojoInacap)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: tituloCtrl,
                    decoration: const InputDecoration(
                      labelText: "Título *",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notaCtrl,
                    decoration: const InputDecoration(
                      labelText: "Notas (opcional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(fechaSeleccionada == null
                            ? "Sin fecha seleccionada"
                            : "Fecha: ${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}"),
                      ),
                      TextButton(
                        onPressed: () async {
                          final seleccion = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                            initialDate: DateTime.now(),
                          );
                          if (seleccion != null) {
                            setModalState(() {
                              fechaSeleccionada = seleccion;
                            });
                          }
                        },
                        child: const Text("Elegir fecha"),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: rojoInacap,
                        minimumSize: const Size.fromHeight(45)),
                    onPressed: () {
                      if (tituloCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("El título es obligatorio")),
                        );
                        return;
                      }
                      setState(() {
                        evaluaciones.add(Evaluacion(
                          title: tituloCtrl.text,
                          dueDate: fechaSeleccionada ?? DateTime.now(),
                        ));
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Crear"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ============================
  // ELIMINAR EVALUACIÓN
  // ============================
  void _eliminarEvaluacion(Evaluacion e) {
    setState(() {
      evaluaciones.remove(e);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Evaluación eliminada"),
        action: SnackBarAction(
          label: "Deshacer",
          onPressed: () {
            setState(() {
              evaluaciones.add(e);
            });
          },
        ),
      ),
    );
  }

  // ============================
  // ESTILOS VISUALES
  // ============================
  Color _colorEstado(Evaluacion e) {
    switch (e.estado) {
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: rojoInacap,
        foregroundColor: Colors.white,
        title: const Text("Evaluaciones"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojoInacap,
        onPressed: _nuevaEvaluacion,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ========================
            // BARRA DE BÚSQUEDA
            // ========================
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Buscar evaluación...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ========================
            // CHIPS DE FILTRO
            // ========================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ["Todas", "Pendientes", "Completadas"].map((f) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: filtro == f,
                    selectedColor: rojoInacap.withOpacity(0.9),
                    backgroundColor: Colors.grey.shade300,
                    labelStyle: TextStyle(
                        color: filtro == f ? Colors.white : Colors.black87),
                    onSelected: (_) => setState(() => filtro = f),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // ========================
            // LISTADO
            // ========================
            Expanded(
              child: _evaluacionesFiltradas.isEmpty
                  ? const Center(
                      child: Text("No hay evaluaciones disponibles"),
                    )
                  : ListView.builder(
                      itemCount: _evaluacionesFiltradas.length,
                      itemBuilder: (context, index) {
                        final e = _evaluacionesFiltradas[index];
                        return Dismissible(
                          key: Key(e.title + e.dueDate.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red.shade400,
                            child: const Icon(Icons.delete,
                                color: Colors.white, size: 30),
                          ),
                          onDismissed: (_) => _eliminarEvaluacion(e),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: e.isDone,
                                activeColor: rojoInacap,
                                onChanged: (v) {
                                  setState(() {
                                    e.isDone = v!;
                                  });
                                },
                              ),
                              title: Text(
                                e.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: e.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                "Fecha: ${e.dueDate.day}/${e.dueDate.month}/${e.dueDate.year}",
                              ),
                              trailing: Text(
                                e.estado,
                                style: TextStyle(
                                  color: _colorEstado(e),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
