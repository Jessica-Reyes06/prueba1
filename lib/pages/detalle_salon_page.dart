import 'package:flutter/material.dart';
import 'package:prueba1/logica/actividad_service.dart';
import 'package:prueba1/logica/reporte_service.dart';
import 'salon_model.dart';
import 'dart:async';

class DetalleSalonPage extends StatefulWidget {
  final Salon salon;
  const DetalleSalonPage({super.key, required this.salon});

  @override
  State<DetalleSalonPage> createState() {
    return _DetalleSalonPageState();
  }

}

class _DetalleSalonPageState extends State<DetalleSalonPage> {
  final TextEditingController comentarioController = TextEditingController();
  final ReporteService reporte = ReporteService();
  final ActividadService actividad = ActividadService();
  
  late int reporteId;
  late int conteoPersonas;
  bool estoyAqui = false;
  List<Map<String, dynamic>> comentarios = [];
  late StreamSubscription<List<Map<String, dynamic>>> _comentariosSubscription;
  late StreamSubscription<int> _conteoSubscription; // Nuevo atributo para el conteo de personas

  @override
    void initState() {
      super.initState();
      reporteId = widget.salon.reporteId;
      conteoPersonas = widget.salon.personas;
      cargarDatos(); // Carga los datos cuando se abre la pantalla
  }

  @override
  void dispose() {
    _comentariosSubscription.cancel(); // Cancelar suscripción al salir
    _conteoSubscription.cancel(); // Cancelar suscripción al salir
    super.dispose();
  }

  Future<void> cargarDatos() async {

    try {
      final yaPresente = await actividad.mostrarActividad(reporteId);
      setState(() {
        estoyAqui = yaPresente;
      });
      // Escuchar comentarios en tiempo real del reporte específico
      _comentariosSubscription = reporte.escucharComentarios(reporteId).listen((listaComentarios) {
      print('🔍 Comentarios del reporte $reporteId: $listaComentarios');
      print('📊 Cantidad de comentarios: ${listaComentarios.length}');
      if (mounted) {
        setState(() {
          comentarios = listaComentarios;
        });
      }
      }, onError: (error) {
        print('Error escuchando comentarios: $error');
      });
    } catch (e) {
      print('Error cargando datos: $e');
    }
    // Escuchar conteo de personas en tiempo real 
    _conteoSubscription = reporte.actualizarConteoActividad(reporteId).listen((conteo) {
    print('👥 Conteo de personas en el reporte $reporteId: $conteo');
    if (mounted) {
        setState(() {
          conteoPersonas = conteo;
        });
      }
    }, onError: (error) {
      print('Error escuchando conteo de personas: $error');
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Devolver el salon actualizado con el conteo actual
                        final salonActualizado = widget.salon.copyWith(personas: conteoPersonas);
                        Navigator.pop(context, salonActualizado);
                      },
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.salon.nombre,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.salon.edificio,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: widget.salon.disponible
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.salon.disponible
                                    ? 'Disponible ahora'
                                    : 'No disponible',
                                style: TextStyle(
                                  color: widget.salon.disponible
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade600,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.group,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Personas',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Text(
                                    '$conteoPersonas',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: widget.salon.tieneClima
                                          ? Colors.blueAccent
                                          : Colors.red.shade700,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.ac_unit,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Clima',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Text(
                                    widget.salon.tieneClima
                                        ? 'Funciona'
                                        : 'No funciona',
                                    style: TextStyle(
                                      color: widget.salon.tieneClima
                                          ? Colors.green
                                          : Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: widget.salon.disponible ? () async {
                              setState(() => estoyAqui = !estoyAqui);
                              if (estoyAqui) {
                                await actividad.unirseAActividad(reporteId);
                              } else {
                                await actividad.salirDeActividad(reporteId);
                              }
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.salon.disponible 
                                ? (estoyAqui
                                  ? Colors.green.shade600
                                  : Colors.blue) 
                                : Colors.grey.shade700,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: estoyAqui
                                ? const Text(
                                    'Estoy aquí',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const Text(
                                    'Marcar que estoy aquí',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: widget.salon.disponible ? () async {
                              reporte.marcarSalonOcupado(reporteId);
                              final salonActualizado = widget.salon.copyWith(disponible: false);
                              Navigator.pop(context, salonActualizado);
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.salon.disponible ? Colors.red.shade600 : Colors.grey.shade700,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text(
                              'Ya se ocupó',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comentarios',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...comentarios
                              .map(
                                (comentario) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(comentario['comentario']!),
                                      Text(
                                        comentario['fecha_hora']!.split('T')[1].substring(0, 5),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: comentarioController,
                                  decoration: const InputDecoration(
                                    hintText: 'Agregar comentario...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              FloatingActionButton(
                                onPressed: () async {
                                  if (comentarioController.text.isNotEmpty) {
                                    try {
                                      await reporte.agregarComentario(
                                        reporteId,
                                        comentarioController.text,
                                      );
                                      comentarioController.clear();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Error al agregar comentario'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                backgroundColor: Colors.blue,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
