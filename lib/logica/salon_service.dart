//Manejo de las tablas Edificio, Salon, favoritos y notificaciones

import 'package:supabase_flutter/supabase_flutter.dart';

class AulaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // OBTENER TODOS LOS EDIFICIOS
  Future<List<Map<String, dynamic>>> obtenerEdificios() async {
    try {
      final data = await _supabase.from('edificio').select().order('nombre');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error en obtenerEdificios: $e');
      rethrow;
    }
  }

  // OBTENER TODOS LOS SALONES
  Future<List<Map<String, dynamic>>> obtenerSalones() async {
    try {
      final data = await _supabase.from('salon').select('id, nombre, id_edificio, edificio(nombre)').order('nombre');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error en obtenerSalones: $e');
      rethrow;
    }
  }

  // OBTENER SALONES FILTRADOS POR EDIFICIO
  /*Future<List<Map<String, dynamic>>> obtenerSalonesPorEdificio(int edificioId) async {
    try {
      final data = await _supabase
          .from('salon')
          .select('id, nombre, id_edificio, edificio(nombre)')
          .eq('id_edificio', edificioId)
          .order('nombre');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error en obtenerSalonesPorEdificio: $e');
      rethrow;
    }
  }*/

  // MARCAR EDIFICIO COMO FAVORITO
  Future<void> toggleEdificioFavorito(int edificioId, bool esFavorito) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      if (esFavorito) {
        // Guardar en favoritos
        await _supabase.from('edificio_favorito').insert({
          'id_estudiante': userId,
          'id_edificio': edificioId,
        });
      } else {
        // Eliminar de favoritos
        await _supabase
            .from('edificio_favorito')
            .delete()
            .eq('id_estudiante', userId)
            .eq('id_edificio', edificioId);
      }
    } catch (e) {
      print('Error en toggleEdificioFavorito: $e');
      rethrow;
    }
  }

  // MARCAR SALON COMO FAVORITO
  Future<void> toggleSalonFavorito(int salonId, bool esFavorito) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      if (esFavorito) {
        // Guardar en favoritos
        await _supabase.from('salon_favorito').insert({
          'id_estudiante': userId,
          'id_salon': salonId,
        });
      } else {
        // Eliminar de favoritos
        await _supabase
            .from('salon_favorito')
            .delete()
            .eq('id_estudiante', userId)
            .eq('id_salon', salonId);
      }
    } catch (e) {
      print('Error en toggleSalonFavorito: $e');
      rethrow;
    }
  }
}