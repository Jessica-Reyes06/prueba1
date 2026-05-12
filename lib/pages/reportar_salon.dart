import 'package:flutter/material.dart';

class ReportarSalonSheet extends StatefulWidget {
  const ReportarSalonSheet({super.key});

  @override
  State<ReportarSalonSheet> createState() {
    return _ReportarSalonSheetState();
  }
}

class _ReportarSalonSheetState extends State<ReportarSalonSheet> {
  String? edificioSeleccionado;
  String? salonSeleccionado;
  bool? climaFunciona;
  String horarioSeleccionado = '20:00-21:00';
  final TextEditingController comentarioController = TextEditingController();

  final List<String> edificios = [
    'Edificio A',
    'Edificio E',
    'Edificio B',
    'Edificio J',
    'Edificio K',
  ];
  final Map<String, List<String>> salonesPorEdificio = {
    'Edificio A': ['A-101', 'A-201', 'A-301'],
    'Edificio E': ['E-105', 'E-108', 'E-205'],
    'Edificio B': ['B-101', 'B-304'],
    'Edificio J': ['J-205', 'J-301'],
    'Edificio K': ['K-101', 'K-202'],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
            const Text(
              'Edificio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: edificioSeleccionado,
              hint: const Text('Seleccionar edificio'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: edificios
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  edificioSeleccionado = valor;
                  salonSeleccionado = null;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Salón', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: salonSeleccionado,
              hint: const Text('Seleccionar salón'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: edificioSeleccionado == null
                  ? []
                  : salonesPorEdificio[edificioSeleccionado]!
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
              onChanged: (valor) {
                setState(() {
                  salonSeleccionado = valor;
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
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: climaFunciona == true
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_outline),
                          SizedBox(width: 8),
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
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: climaFunciona == false
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.cancel_outlined),
                          SizedBox(width: 8),
                          Text('No funciona'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Text(
              'Fecha y hora',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
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
                              '20:00-21:00',
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
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
