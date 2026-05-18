//Manejo del conteo de alumnos activos en un reporte

import 'package:supabase_flutter/supabase_flutter.dart';

class ActividadService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // SEÑALAR ACTIVIDAD (Unirse al reporte del salón)
  Future<void> unirseAActividad(int reporteId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('actividad').insert({
        'id_reporte': reporteId,
        'id_estudiante': userId,
        'activo': true, // Indicamos que entramos al salón
      });
    } catch (e) {
      print('Error en unirseAActividad: $e');
      rethrow;
    }
  }

  // QUITAR ACTIVIDAD (Desmarcar presencia)
  Future<void> salirDeActividad(int reporteId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Actualizar el registro más reciente para marcar como inactivo
      // Esto activa el trigger que actualiza el conteo automáticamente
      await _supabase
          .from('actividad')
          .update({'activo': false})
          .eq('id_reporte', reporteId)
          .eq('id_estudiante', userId)
          .order('fecha_hora', ascending: false)
          .limit(1);
    } catch (e) {
      print('Error en salirDeActividad: $e');
      rethrow;
    }
  }
}