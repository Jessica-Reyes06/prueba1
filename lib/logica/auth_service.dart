//inicio de sesion y registro de estudiantes con supabase auth

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Singleton: una única instancia en toda la aplicación
  static final AuthService _instancia = AuthService._interno();
  
  factory AuthService() {
    return _instancia;
  }
  
  AuthService._interno();
  
  // Instancia del cliente nativo de Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // OBTENER EL USUARIO ACTUAL LOGUEADO
  User? get usuarioActual => _supabase.auth.currentUser;
  
  // OBTENER NOMBRE DE USUARIO (acceso directo)
  String? get nombreUsuario => usuarioActual?.userMetadata?['username'];
  
  // OBTENER EMAIL DEL USUARIO
  String? get emailUsuario => usuarioActual?.email;
  
  // OBTENER ID DEL USUARIO
  String? get usuarioId => usuarioActual?.id;
  
  // VERIFICAR SI ESTÁ LOGUEADO
  bool get estaLogueado => usuarioActual != null;

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
      print('Error en login: $e.message');
      rethrow;
    }
  }

  // REGISTRO DE NUEVO ESTUDIANTE
  //En la base de datos se valida el correo institucional
  Future<AuthResponse> registrarUsuario({
    required String email,
    required String password,
    String nombre = '',
  }) async {
    try {
      if (nombre.isEmpty) {
        return await _supabase.auth.signUp(
          email: email,
          password: password
        ); 
      }
      else {
        return await _supabase.auth.signUp(
         email: email,
         password: password,
          // Mandamos el nombre en los metadatos del usuario para que el trigger lo use
          data: {'username': nombre}
        ); 
      }
    } catch (e) {
      print('Error en registrarUsuario: $e.message');
      rethrow;
    }
  }

// Función para validar que la contraseña sea segura
bool contrasenaSegura(String contrasena) {
  RegExp expresion = RegExp(r'^(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,}$');
  return expresion.hasMatch(contrasena);
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
      print('Error en actualizarUsername: $e.message');
      rethrow;
    }
  }

  // CERRAR SESIÓN
  Future<void> cerrarSesion() async {
    await _supabase.auth.signOut();
  }
}