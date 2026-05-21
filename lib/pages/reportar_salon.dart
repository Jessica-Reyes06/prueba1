import 'package:flutter/material.dart';
import '../logica/reporte_service.dart';
import '../logica/salon_service.dart';

class ReportarSalonSheet extends StatefulWidget {
  const ReportarSalonSheet({super.key});

  @override
  State<ReportarSalonSheet> createState() {
    return _ReportarSalonSheetState();
  }
}

class _ReportarSalonSheetState extends State<ReportarSalonSheet> {
  int? edificioSeleccionadoId;
  int? salonSeleccionadoId;
  bool? climaFunciona;
  String horarioSeleccionado = '19:00-20:00';
  final TextEditingController comentarioController = TextEditingController();
  final SalonService salonService = SalonService();
  List<Map<String, dynamic>> edificios = [];
  List<Map<String, dynamic>> salones = [];
  bool cargandoDatos = true;
  String? errorCarga;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        salonService.obtenerEdificios(),
        salonService.obtenerSalones(),
      ]);

      if (!mounted) return;
      setState(() {
        edificios = resultados[0];
        salones = resultados[1];
        cargandoDatos = false;
        errorCarga = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        cargandoDatos = false;
        errorCarga = 'No se pudieron cargar los datos desde la base de datos';
      });
    }
  }

  List<Map<String, dynamic>> get salonesFiltrados {
    if (edificioSeleccionadoId == null) return [];
    return salones
        .where((salon) => salon['id_edificio'] == edificioSeleccionadoId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          48 + MediaQuery.of(context).padding.top,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reportar salón disponible',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 24),
            if (cargandoDatos)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (errorCarga != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  errorCarga!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const Text(
              'Edificio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: edificioSeleccionadoId,
              hint: const Text('Seleccionar edificio'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: edificios
                  .map(
                    (edificio) => DropdownMenuItem<int>(
                      value: edificio['id'] as int,
                      child: Text(
                        edificio['nombre']?.toString() ?? 'Sin nombre',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  edificioSeleccionadoId = valor;
                  salonSeleccionadoId = null;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Salón', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: salonSeleccionadoId,
              hint: const Text('Seleccionar salón'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: edificioSeleccionadoId == null
                  ? []
                  : salonesFiltrados
                        .map(
                          (salon) => DropdownMenuItem<int>(
                            value: salon['id'] as int,
                            child: Text(
                              salon['nombre']?.toString() ?? 'Sin nombre',
                            ),
                          ),
                        )
                        .toList(),
              onChanged: (valor) {
                setState(() {
                  salonSeleccionadoId = valor;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Clima', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        climaFunciona = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: climaFunciona == true
                            ? Colors.blue.shade50
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: climaFunciona == true
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Colors.green,
                          ),
                          SizedBox(width: 6),
                          Text('Funciona'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        climaFunciona = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: climaFunciona == false
                            ? Colors.blue.shade50
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: climaFunciona == false
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 6),
                          Text('No funciona'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Fecha y hora',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Hoy',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: horarioSeleccionado,
                    underline: const SizedBox(),
                    items:
                        [
                              '07:00-08:00',
                              '08:00-09:00',
                              '09:00-10:00',
                              '10:00-11:00',
                              '11:00-12:00',
                              '12:00-13:00',
                              '13:00-14:00',
                              '14:00-15:00',
                              '15:00-16:00',
                              '16:00-17:00',
                              '17:00-18:00',
                              '18:00-19:00',
                              '19:00-20:00',
                            ]
                            .map(
                              (h) => DropdownMenuItem(value: h, child: Text(h)),
                            )
                            .toList(),
                    onChanged: (valor) {
                      setState(() {
                        horarioSeleccionado = valor!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Se registrará para este horario',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Text(
              'Comentario (opcional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: comentarioController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ej. Está vacío, hay 3 personas...',
                hintStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (edificioSeleccionadoId == null ||
                    salonSeleccionadoId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecciona edificio y salón'),
                    ),
                  );
                  return;
                }

                try {
                  final reporteService = ReporteService();
                  final parts = horarioSeleccionado.split('-');
                  final horaInicio = parts.isNotEmpty
                      ? parts[0].trim()
                      : horarioSeleccionado;
                  final horaFin = parts.length > 1
                      ? parts[1].trim()
                      : horarioSeleccionado;

                  // Tomamos la hora de fin del bloque y la convertimos a una
                  // fecha de hoy para compararla con la hora actual.
                  try {
                    final ahora = DateTime.now();
                    final partesHoraFin = horaFin.split(':');
                    final int horaFinEntera = partesHoraFin.isNotEmpty
                        ? int.parse(partesHoraFin[0])
                        : ahora.hour;
                    final int minutoFinEntero = partesHoraFin.length > 1
                        ? int.parse(partesHoraFin[1])
                        : 0;

                    final horaFinDelBloque = DateTime(
                      ahora.year,
                      ahora.month,
                      ahora.day,
                      horaFinEntera,
                      minutoFinEntero,
                    );

                    // Si la hora de fin ya pasó o es exactamente la misma,
                    // entonces el bloque ya no está disponible.
                    if (horaFinDelBloque.isBefore(ahora) ||
                        horaFinDelBloque.isAtSameMomentAs(ahora)) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No puedes reportar un aula fuera del horario actual',
                          ),
                        ),
                      );
                      return;
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Horario inválido')),
                    );
                    return;
                  }

                  await reporteService.crearReporte(
                    idSalon: salonSeleccionadoId!,
                    climaFunciona: climaFunciona ?? true,
                    horaInicio: horaInicio,
                    horaFin: horaFin,
                    comentario: comentarioController.text,
                  );

                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reporte publicado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al publicar: ${e.toString()}'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Publicar',
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
    );
  }
}
