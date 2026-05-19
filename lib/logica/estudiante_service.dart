import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class EstudianteService {
  static final EstudianteService _instancia = EstudianteService._interno();
  
  factory EstudianteService() {
    return _instancia;
  }
  
  EstudianteService._interno();
  
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _auth = AuthService();
  
  // Obtener datos del estudiante desde la tabla
  Future<Map<String, dynamic>?> obtenerDatosEstudiante() async {
    try {
      final usuarioId = _auth.usuarioId;
      if (usuarioId == null) return null;
      
      final response = await _supabase
          .from('estudiante')
          .select()
          .eq('id', usuarioId)
          .single();
      return response;
    } catch (e) {
      print('ERROR obteniendo estudiante: $e');
      return null;
    }
  }
  // Obtener nombre del estudiante
  Future<String?> obtenerUsername() async {
    final datos = await obtenerDatosEstudiante();
    final username = datos?['username'] as String?;
    return username;
  }
  
  // Actualizar nombre del estudiante
  Future<void> actualizarUsername(String nuevoUsername) async { 
    try {
      final usuarioId = _auth.usuarioId;
      if (usuarioId == null) return;
      
      await _supabase
          .from('estudiante')
          .update({'username': nuevoUsername})
          .eq('id', usuarioId);
    } catch (e) {
      print('ERROR actualizando username: $e');
      rethrow;
    }
  }
  
  // Obtener salones favoritos
  Future<List<Map<String, dynamic>>> obtenerSalonesFavoritos() async {
    try {
      final usuarioId = _auth.usuarioId;
      if (usuarioId == null) return [];

      final response = await _supabase
          .from('salon_favorito')
          .select('id_salon, salon(nombre, id_edificio, edificio(nombre))')
          .eq('id_estudiante', usuarioId);
      
      return List<Map<String, dynamic>>.from(response.map((item) {
        return {
          'id': item['id_salon'],
          'nombre': item['salon']['nombre'] as String,
          'edificio_id': item['salon']['id_edificio'] as int,
          'edificio_nombre': item['salon']['edificio']['nombre'] as String,
        };
      }));
    } catch (e) {
      print('Error obteniendo favoritos: $e');
      return [];
    }
  }

  //Obtener edificios favoritos
  Future<List<Map<String, dynamic>>> obtenerEdificiosFavoritos() async {
    try {
      final usuarioId = _auth.usuarioId;
      if (usuarioId == null) return [];
      
      final response = await _supabase
          .from('edificio_favorito')
          .select('id_edificio, edificio(nombre)')
          .eq('id_estudiante', usuarioId);
      
      return List<Map<String, dynamic>>.from(response.map((item) => {
        'id': item['id_edificio'],
        'nombre': item['edificio']['nombre'] as String,
      }));
    } catch (e) {
      print('Error obteniendo favoritos: $e');
      return [];
    }
  }

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

/*
  // Agregar salón favorito
  Future<void> agregarFavorito(String idSalon) async {
    try {
      final usuarioId = _auth.usuarioId;
      if (usuarioId == null) return;
      
      await _supabase
          .from('salon_favorito')
          .insert({'id_estudiante': usuarioId, 'id_salon': idSalon});
    } catch (e) {
      print('Error agregando favorito: $e');
      rethrow;
    }
  }

  // Eliminar salón favorito
  Future<void> eliminarFavorito(String idSalon) async {
    try {
      final usuarioId = _auth.usuarioId;
      if (usuarioId == null) return;
      
      await _supabase
          .from('favoritos')
          .delete()
          .eq('id_usuario', usuarioId)
          .eq('id_salon', idSalon);
    } catch (e) {
      print('Error eliminando favorito: $e');
      rethrow;
    }
  }
}*/