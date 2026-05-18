// Manejo de reportes y comentarios

import 'package:supabase_flutter/supabase_flutter.dart';

class ReporteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // CREAR UN REPORTE NUEVO
  Future<void> crearReporte({
    required int idSalon,
    required bool climaFunciona,
    //required DateTime fecha,
    required String horaInicio,
    required String horaFin,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('reporte').insert({
        'id_salon': idSalon,
        'id_estudiante': userId,
        'clima_funciona': climaFunciona,
        //'fecha': fecha.toIso8601String().split('T')[0], // Formato: YYYY-MM-DD
        'hora_inicio': horaInicio,
        'hora_fin': horaFin,
        'esta_vacio': true,
        'total_alumnos': 0, // El trigger lo actualizará
      });
    } catch (e) {
      print('Error en crearReporte: $e');
      rethrow;
    }
  }

  // ESCUCHAR REPORTES ACTIVOS EN TIEMPO REAL
  // Solo muestra reportes que: esta_vacio=true y estén en el rango de hora actual
  // Solo un reporte por salón (el primero creado)
  Stream<List<Map<String, dynamic>>> escucharReportesActivos() {
    return _supabase
        .from('reporte')
        .stream(primaryKey: ['id'])
        .eq('esta_vacio', true)
        .map((listaReportes) {
          // Filtrar por fecha de hoy
          final hoy = DateTime.now();
          final diaActual = hoy.toIso8601String().split('T')[0];

          // Filtrar reportes de hoy que estén en el rango de hora
          final reportesHoy = listaReportes.where((r) {
            final fecha = r['fecha'] as String?;
            if (fecha != diaActual) return false;

            final horaActual = '${hoy.hour.toString().padLeft(2, '0')}:${hoy.minute.toString().padLeft(2, '0')}';
            final horaInicio = r['hora_inicio'] as String?;
            final horaFin = r['hora_fin'] as String?;

            return horaActual.compareTo(horaInicio ?? '') >= 0 &&
                horaActual.compareTo(horaFin ?? '') <= 0;
          }).toList();

          // Agrupar por salón y tomar solo el primero (más antiguo)
          final Map<int, Map<String, dynamic>> reportesPorSalon = {};
          for (var reporte in reportesHoy) {
            final idSalon = reporte['id_salon'] as int;
            if (!reportesPorSalon.containsKey(idSalon)) {
              reportesPorSalon[idSalon] = reporte;
            }
          }

          return reportesPorSalon.values.toList();
        });
  }

  // MARCAR SALÓN COMO OCUPADO (esta_vacio = false)
  Future<void> marcarSalonOcupado(int reporteId) async {
    try {
      await _supabase
          .from('reporte')
          .update({'esta_vacio': false})
          .eq('id', reporteId);
    } catch (e) {
      print('Error en marcarSalonOcupado: $e');
      rethrow;
    }
  }

  // AGREGAR COMENTARIO A UN REPORTE
  Future<void> agregarComentario(int reporteId, String textoComentario) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    
    try {
      await _supabase.from('comentario').insert({
        'id_reporte': reporteId,
        'id_estudiante': userId,
        'comentario': textoComentario,
      });
    } catch (e) {
      print('Error en agregarComentario: $e');
      rethrow;
    }
  }

  // ESCUCHAR COMENTARIOS EN VIVO DE UN REPORTE ESPECÍFICO
  Stream<List<Map<String, dynamic>>> escucharComentarios(int reporteId) {
    return _supabase
        .from('comentario')
        .stream(primaryKey: ['id'])
        .eq('id_reporte', reporteId)
        .order('fecha_hora', ascending: true);
  }

   // ESCUCHAR CONTEO DE ALUMNOS EN TIEMPO REAL
  // Lee el conteo que el trigger conteo_actividad mantiene actualizado en la tabla reporte
  Stream<int> actualizarConteoActividad(int reporteId) {
    return _supabase
        .from('reporte')
        .stream(primaryKey: ['id'])
        .eq('id', reporteId)
        .map((data) {
          if (data.isEmpty) return 0;
          // El trigger mantiene actualizado este conteo automáticamente
          return data.first['total_alumnos'] as int? ?? 0;
        });
  }
}