//inicio de sesion y registro de estudiantes con supabase auth

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Instancia del cliente nativo de Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // OBTENER EL USUARIO ACTUAL LOGUEADO
  User? get usuarioActual => _supabase.auth.currentUser;

  // INICIO DE SESIÓN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error en login: $e');
      rethrow;
    }
  }

  // REGISTRO DE NUEVO ESTUDIANTE
  //En la base de datos se valida el correo institucional
  Future<AuthResponse> registrarEstudiante({
    required String email,
    required String password,
    required String nombre,
  }) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        // Mandamos el nombre en los metadatos del usuario para que el trigger lo use
        data: {'username': nombre}, 
      );
    } catch (e) {
      print('Error en registrarEstudiante: $e');
      rethrow;
    }
  }

  // MODIFICAR NOMBRE DE USUARIO
  Future<void> actualizarUsername(String nuevoNombre) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {'username': nuevoNombre},
        ),
      );
    } catch (e) {
      print('Error en actualizarUsername: $e');
      rethrow;
    }
  }

  // CERRAR SESIÓN
  Future<void> cerrarSesion() async {
    await _supabase.auth.signOut();
  }
}