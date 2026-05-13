class Autenticacion {
  bool iniciarSesion(String usuario, String contrasena) {
    if (usuario.isEmpty || contrasena.isEmpty) {
      return true;
    }
    return false;
  }

  void cerrarSesion() {
    // Lógica para cerrar sesión
  }
  bool validarCorreo(String usuario) {
    return usuario.endsWith('@veracruz.tecnm.mx');
  }

  bool contrasenaSegura(String contrasena) {
    RegExp expresion = RegExp(r'^(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,}$');
    return expresion.hasMatch(contrasena);
  }
}
