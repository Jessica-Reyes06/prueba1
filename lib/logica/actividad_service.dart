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
      rethrow;
    }
  }

  // QUITAR ACTIVIDAD (Desmarcar presencia)
  Future<void> salirDeActividad(int reporteId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Primero obtener el ID del registro más reciente
      final response = await _supabase
          .from('actividad')
          .select('id')
          .eq('id_reporte', reporteId)
          .eq('id_estudiante', userId)
          .order('fecha_hora', ascending: false)
          .limit(1)
          .maybeSingle(); 

      if (response == null) {
        throw Exception('No hay registro de actividad para este usuario en este reporte');
      }

      final recordId = response['id'];

      // Luego actualizar ese registro específico
      await _supabase
          .from('actividad')
          .update({'activo': false})
          .eq('id', recordId);
    } catch (e) {
      rethrow;
    }
  }

  //MOSTRAR ACTIVIDAD
  Future<bool> mostrarActividad(int reporteId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final response = await _supabase
          .from('actividad')
          .select('activo')
          .eq('id_reporte', reporteId)
          .eq('id_estudiante', userId)
          .order('fecha_hora', ascending: false)
          .limit(1)
          .maybeSingle(); // Usa maybeSingle() en lugar de single()

      if (response == null) return false; // Si no hay registro, retorna false

      return response['activo'] ?? false;
    } catch (e) {
      return false;
    }
  }
}