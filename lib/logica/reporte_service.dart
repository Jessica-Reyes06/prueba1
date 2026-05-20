// Manejo de reportes y comentarios

import 'package:supabase_flutter/supabase_flutter.dart';

class ReporteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _formatearHoraComoTimestamp(String hora) {
    final partes = hora.trim().split(':');
    final ahora = DateTime.now();

    final int horas = partes.isNotEmpty ? int.parse(partes[0]) : ahora.hour;
    final int minutos = partes.length > 1 ? int.parse(partes[1]) : ahora.minute;

    final fechaHora = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
      horas,
      minutos,
    );

    return fechaHora.toIso8601String();
  }

  // CREAR UN REPORTE NUEVO
  Future<void> crearReporte({
    required int idSalon,
    required bool climaFunciona,
    //required DateTime fecha,
    required String horaInicio,
    required String horaFin,
    String? comentario,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Debes iniciar sesión para publicar un reporte');
    }

    final fechaHoy = DateTime.now().toIso8601String().split('T')[0];
    final horaInicioTimestamp = _formatearHoraComoTimestamp(horaInicio);
    final horaFinTimestamp = _formatearHoraComoTimestamp(horaFin);

    try {
      final responseReporte = await _supabase.from('reporte').insert({
        'id_salon': idSalon,
        'id_estudiante': userId,
        'clima_funciona': climaFunciona,
        'fecha': fechaHoy,
        'hora_inicio': horaInicioTimestamp,
        'hora_fin': horaFinTimestamp,
        'esta_vacio': true,
        'total_alumnos': 0, // El trigger lo actualizará
      }).select();

      final reporteId = responseReporte[0]['id'] as int;
      if (comentario != null && comentario.trim().isNotEmpty) {
        await _supabase.from('comentario').insert({
          'id_reporte': reporteId,
          'id_estudiante': userId,
          'comentario': comentario,
        });
      }
    } catch (e) {
      print('Error en crearReporte: $e');
      rethrow;
    }
  }

  // ESCUCHAR REPORTES ACTIVOS EN TIEMPO REAL
  // Solo muestra reportes que: esta_vacio=true y estén en el rango de hora actual
  // Solo un reporte por salón (el primero creado)
  Stream<List<Map<String, dynamic>>> escucharReportesActivos(int? idEdificio) {
    final userId = _supabase.auth.currentUser?.id;

    return _supabase
        .from('reporte')
        .stream(primaryKey: ['id'])
        .eq('esta_vacio', true)
        .asyncMap((listaReportes) async {
          //Obtener salones favoritos del usuario
          List<int> salonesFavoritosIds = [];
          if (userId != null) {
            final favoritosData = await _supabase
                .from('salones_favoritos')
                .select('id_salon')
                .eq('id_estudiante', userId);

            salonesFavoritosIds = favoritosData
                .map((f) => f['id_salon'] as int)
                .toList();
          }

          // Filtrar por fecha de hoy
          final hoy = DateTime.now();
          final diaActual = hoy.toIso8601String().split('T')[0];

          // Filtrar reportes de hoy que estén en el rango de hora
          final reportesHoy = listaReportes.where((r) {
            final fecha = r['fecha'] as String?;
            if (fecha != diaActual) return false;

            final horaActual =
                '${hoy.hour.toString().padLeft(2, '0')}:${hoy.minute.toString().padLeft(2, '0')}';
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
              final salonMap = reporte['salon'] as Map<String, dynamic>?;
              final edificioMap =
                  salonMap?['edificio'] as Map<String, dynamic>?;
              final idEdificioReporte = salonMap?['id_edificio'] as int?;

              final esFavorito = salonesFavoritosIds.contains(idSalon);

              if (idEdificio != null && idEdificioReporte != idEdificio) {
                continue; // Se salta este reporte y va al siguiente
              }

              //Vista salon
              reportesPorSalon[idSalon] = {
                'id': reporte['id'],
                'id_salon': idSalon,
                'clima_funciona': reporte['clima_funciona'],
                //'fecha': reporte['fecha'],
                'hora_inicio': reporte['hora_inicio'],
                'hora_fin': reporte['hora_fin'],
                'esta_vacio': reporte['esta_vacio'],
                'total_alumnos': reporte['total_alumnos'],
                'salon_nombre': salonMap?['nombre'] ?? 'S/N',
                'edificio_nombre': edificioMap?['nombre'] ?? 'S/E',

                // INYECCIÓN DEL BOOLEANO
                'es_favorito': esFavorito,
              };
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
        .order('fecha_hora', ascending: true)
        .map((listaComentarios) {
          // Mapeamos la lista para asegurarnos de que la estructura sea idéntica
          return listaComentarios.map((comentario) {
            // Supabase por defecto anida las tablas relacionadas en un Map interno.
            final datosEstudiante =
                comentario['estudiante'] as Map<String, dynamic>?;

            return {
              'id': comentario['id'],
              'id_reporte': comentario['id_reporte'],
              'id_estudiante': comentario['id_estudiante'],
              'comentario': comentario['comentario'],
              'fecha_hora': comentario['fecha_hora'],
              'nombre_usuario':
                  datosEstudiante?['nombre'] ?? 'Usuario Desconocido',
            };
          }).toList();
        });
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
