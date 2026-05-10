import 'package:flutter/material.dart';
import 'package:prueba1/pages/home_page.dart'; //se importa el paquete de material design para usar widgets y temas predefinidos

void main() {
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
      //estudiar poliorfismo
      title: 'AulaLibre',
      debugShowCheckedModeBanner:
          false, //esto es para quitar el banner de debug en la esquina superior derecha
      home: const LoginPage(),
    );
  }

  //widget es el tipo de retorno (objeto de la clase Widget)
  //buil es el metodo que se sobreescribe
  //context es un objeto que contiene información sobre el árbol de widgets y se utiliza para acceder a temas, tamaños de pantalla, etc.
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
                            TextField(
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
                                onTap: () {},
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

                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  //administra navegación entre pantallas y permite cambiar de una pantalla a otra al pulsar el botón
                                  //push es un metodo estatico de la clase Navigator
                                  context,
                                  MaterialPageRoute(
                                    //clase que define la transición entre pantallas
                                    builder: (context) =>
                                        const HomePage(), // => indica retorno
                                  ),
                                );
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

                            ElevatedButton(
                              onPressed: () {},
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
