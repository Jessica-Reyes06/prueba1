//Manejo de las tablas Edificio, Salon, favoritos y notificaciones

import 'package:supabase_flutter/supabase_flutter.dart';

class SalonService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // OBTENER TODOS LOS EDIFICIOS
  Future<List<Map<String, dynamic>>> obtenerEdificios() async {
    try {
      final data = await _supabase.from('edificio').select().order('nombre');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      rethrow;
    }
  }

  // OBTENER TODOS LOS SALONES
  Future<List<Map<String, dynamic>>> obtenerSalones() async {
    try {
      final data = await _supabase.from('salon').select('id, nombre, id_edificio, edificio(nombre)').order('nombre');
      return data.map((salon) {
      return {
        'id': salon['id'],
        'nombre': salon['nombre'],
        'id_edificio': salon['id_edificio'],
        'edificio_nombre': salon['edificio']['nombre'],
      };
    }).toList();
    } catch (e) {
      rethrow;
    }
  }
}