import 'package:flutter/material.dart';

import 'package:prueba1/pages/home_page.dart'; //se importa el paquete de material design para usar widgets y temas predefinidos
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prueba1/logica/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  ); // Inicializa la conexión con Supabase 

  runApp(const MyApp());
} // La función main es el punto de entrada de la aplicación. Aquí se llama a runApp para iniciar la aplicación y se pasa una instancia de MyApp como argumento.

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //StatelessWidget es una clase abstracta
  //super.key es para que el constructor implemente el atributo key
  // y MyApp es como en constructor de la clase que cuando le ponemos const este crea objetos constantes

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AulaLibre',
      debugShowCheckedModeBanner: false,
      home: _verificarSesion(), //LoginPage(),
    );
  }

  // Widget que verifica si hay sesión activa
  Widget _verificarSesion() {
    final AuthService auth = AuthService();
    
    // Si hay usuario logueado, va a HomePage
    // Si no, va a LoginPage
    if (auth.estaLogueado) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  int pestanaSeleccionada = 0;
  bool contrasenaVisible = false;
  
  final AuthService auth = AuthService();
  final TextEditingController controladorCorreo = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();
  final TextEditingController controladorConfirmarContrasena =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 37, 116),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, //columna que se estira a lo ancho de la pantalla
              children: [
                const SizedBox(height: 150),
                const Text(
                  'AulaLibre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encuentra salones disponibles al instante',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70, //70 es la opacidad del color
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    //clase qie le da estilo al contenedor
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      //para mostrar los botones de iniciar sesión y registrarse en una fila
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //funcion anonima que se ejecuta cuando se toca el widget
                            setState(() {
                              pestanaSeleccionada = 0;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: pestanaSeleccionada == 0
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Iniciar sesión',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //funcion anonima que se ejecuta cuando se toca el widget
                            setState(() {
                              pestanaSeleccionada = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: pestanaSeleccionada == 1
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Registrarse',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: pestanaSeleccionada == 0
                      ? Column(
                          children: [
                            //CAMPO DE CORREO
                            TextField(
                              controller: controladorCorreo,
                              decoration: InputDecoration(
                                hintText: 'Correo institucional',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            //CAMPO DE CONTRASEÑA
                            TextField(
                              controller: controladorContrasena,
                              //“este TextField será administrado por este TextEditingController”
                              obscureText: !contrasenaVisible,
                              decoration: InputDecoration(
                                hintText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      contrasenaVisible = !contrasenaVisible;
                                    });
                                  },
                                  child: Icon(
                                    contrasenaVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {}, //Función para recuperar contraseña  
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            //BOTÓN DE INICIAR SESIÓN
                            ElevatedButton(
                              onPressed: () {
                                String correo = controladorCorreo.text;
                                String contrasena = controladorContrasena.text;
                                
                                if (correo.isEmpty || contrasena.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Campos vacíos. Por favor, ingresa tu correo y contraseña.',
                                      ),
                                    ),
                                  );
                                } 
                                else {
                                  auth.login(email: correo, password: contrasena).then((response) {
                                    if (response.session != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('¡Inicio de sesión exitoso!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const HomePage(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Error en inicio de sesión. Verifica tus credenciales.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error en inicio de sesión: ${error.message}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(double.infinity, 50),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            TextField(
                              controller: controladorCorreo,
                              decoration: InputDecoration(
                                hintText: 'Correo institucional',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            TextField(
                              controller: controladorContrasena,
                              obscureText: !contrasenaVisible,
                              decoration: InputDecoration(
                                hintText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      contrasenaVisible = !contrasenaVisible;
                                    });
                                  },
                                  child: Icon(
                                    contrasenaVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            TextField(
                              controller: controladorConfirmarContrasena,
                              obscureText: !contrasenaVisible,
                              decoration: InputDecoration(
                                hintText: 'Confirmar contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      contrasenaVisible = !contrasenaVisible;
                                    });
                                  },
                                  child: Icon(
                                    contrasenaVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            //°°°°°°°BOTÓN DE REGISTRARSE°°°°°°°°°|
                            ElevatedButton(
                              onPressed: () {
                                String contrasena = controladorContrasena.text;
                                String correo = controladorCorreo.text;
                                String confirmarContrasena = controladorConfirmarContrasena.text;

                                if (!auth.contrasenaSegura(contrasena)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'La contraseña debe tener al menos 8 caracteres, una letra mayúscula y un número.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (contrasena != confirmarContrasena) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Las contraseñas no coinciden',
                                      ),
                                    ),
                                  );

                                  return;
                                }
                                auth.registrarUsuario(email: correo, password: contrasena).then((response) {
                                  if (response.user != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('¡Cuenta creada correctamente!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Error en registro. Verifica tus datos.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error en registro: ${error.message}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(double.infinity, 50),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),

                              child: const Text(
                                'Crear cuenta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                ), //aquí termina el cuadrado blanco
              ],
            ),
          ),
        ), //Scaffold es un widget que proporciona una estructura básica para la aplicación, como una barra de aplicaciones, un cuerpo, etc.
      ), //Aquí se establece el color de fondo y se define el cuerpo de la página de inicio de sesión.
    );
  }
}
