//import 'dart:math';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueba1/logica/estudiante_service.dart';
import 'package:prueba1/main.dart';
import 'package:prueba1/logica/auth_service.dart';
import 'package:prueba1/logica/salon_service.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() {
    return _PerfilPageState();
  }
}

class _PerfilPageState extends State<PerfilPage> {
  final AuthService auth = AuthService();
  final EstudianteService estudiante = EstudianteService();
  final SalonService salon = SalonService();

  String nombreUsuario = '';
  String correoUsuario = '';
  List<Map<String, dynamic>> edificiosSeleccionados = [];
  List<Map<String, dynamic>> todosLosEdificios = [];
  List<Map<String, dynamic>> salonesFavoritos = [];
  List<Map<String, dynamic>> todosLosSalones = [];


  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }
  
  // Cargar los datos del usuario desde la sesión activa
  Future<void> _cargarDatos() async {
    final nombre = await estudiante.obtenerUsername();
    final edificiosFavoritos = await estudiante.obtenerEdificiosFavoritos();
    final edificios = await salon.obtenerEdificios();
    final salones = await salon.obtenerSalones();
    final salonesFav = await estudiante.obtenerSalonesFavoritos();
    if (mounted) {
      setState(() {
        nombreUsuario = nombre ?? 'Usuario';
        correoUsuario = auth.emailUsuario!;
        edificiosSeleccionados = edificiosFavoritos;
        salonesFavoritos = salonesFav;
        todosLosSalones = salones;
        todosLosEdificios = edificios;
      });
    }
  }

  // OBTENER FECHA DE REGISTRO DEL USUARIO
  String? get fechaRegistro {
    final fecha = auth.usuarioActual?.createdAt;
    if (fecha == null) return null;
    
    final parsedDate = DateTime.parse(fecha);
    final meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
                    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    
    return '${parsedDate.day} de ${meses[parsedDate.month - 1]} de ${parsedDate.year}';
  } 

  // Obtener la primera letra del nombre para el icono del perfil
  String obtenerPrimeraLetra(String nombre) {
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : 'L';
  }

  Widget _botonEdificioNotificacion(Map<String, dynamic> edificio) {
    final nombre = 'Edificio ${edificio['nombre'] as String}';
    final id = edificio['id'] as int;
    bool seleccionado = edificiosSeleccionados.any((e) => e['id'] == id);
    return GestureDetector(
      onTap: () async {
        await estudiante.toggleEdificioFavorito(id, !seleccionado);
        if (mounted) {
          setState(() {
            if (seleccionado) {
              edificiosSeleccionados.removeWhere((e) => e['id'] == id);
            } else {
              edificiosSeleccionados.add(edificio);
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: seleccionado ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          nombre,
          style: TextStyle(
            color: seleccionado ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _itemFavorito(Map<String, dynamic> salon) {
    final String nombre = "${salon['edificio_nombre']}-${salon['nombre']}";
    final int idSalon = salon['id'] as int;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nombre, style: const TextStyle(fontWeight: FontWeight.w500)),
          GestureDetector(
            onTap: () async {
              await estudiante.toggleSalonFavorito(idSalon, false);
              if (mounted) {
                setState(() {
                  salonesFavoritos.removeWhere((e) => e['id'] == idSalon);
                });
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fecha=fechaRegistro ?? 'Desconocida';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perfil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          // widget que muestra una imagen o texto dentro de un círcul
                          radius: 35,
                          backgroundColor: const Color.fromARGB(
                            255,
                            17,
                            82,
                            135,
                          ),
                          child: Text(
                            //como no tenemos foto todavía, mostramos la primera letra del nombre del usuario
                            obtenerPrimeraLetra(nombreUsuario),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    nombreUsuario,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        //muestra una ventana emergente para editar el nombre del usuario
                                        context: context,
                                        builder: (context) {
                                          TextEditingController controller =
                                              /* es una clase que controla un campo de texto TextField. Le permite a tu código leer y escribir el valor del campo. 
Aquí lo inicializamos con text: nombreUsuario para que el campo ya tenga el nombre actual escrito.*/
                                              TextEditingController(
                                                text: nombreUsuario,
                                              );
                                          return AlertDialog(
                                            //es el widget que muestra la ventana emergente
                                            title: const Text('Editar nombre'),
                                            content: TextField(
                                              controller: controller,
                                              decoration: const InputDecoration(
                                                hintText: 'Escribe tu nombre',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                ), //cierra la pantalla y regresa a la anterior
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    nombreUsuario =
                                                        controller.text;
                                                  });
                                                  auth.actualizarUsername(controller.text);
                                                  estudiante.actualizarUsername(controller.text);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Guardar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                correoUsuario,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Miembro desde',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      fecha,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Notificaciones',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Recibir alertas cuando haya salones disponibles en estos edificios:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      //Wrap — es como Row pero inteligente.
                      //Cuando los elementos no caben en una línea, automáticamente los mueve a la siguiente
                      spacing: 8, //espacio horizontal entre botones
                      runSpacing: 8, // espacio vertical entre filas
                      children: todosLosEdificios
                          .map(
                            (edificio) =>
                                _botonEdificioNotificacion(edificio),
                          )
                          .toList(),
                      //Itera sobre los edificios favoritos de la BD
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //distribuye los hijos del Row dejando todo el espacio disponible entre ellos.
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 8),
                            const Text(
                              'Favoritos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String busqueda = '';
                                todosLosSalones;
                                return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                    List<Map<String, dynamic>> salonesFiltrados =
                                        todosLosSalones
                                            .where(
                                              (s) {
                                                final nombre = "${s['edificio_nombre']}-${s['nombre']}";
                                                return nombre.toLowerCase().contains(busqueda.toLowerCase());
                                              },
                                            )
                                            .toList();
                                    return AlertDialog(
                                      title: const Text('Agregar favorito'),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        height: 300,
                                        child: Column(
                                          children: [
                                            TextField(
                                              onChanged: (valor) {
                                                setStateDialog(() {
                                                  busqueda = valor;
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                hintText: 'Buscar salón...',
                                                prefixIcon: Icon(Icons.search),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: salonesFiltrados.length,
                                                itemBuilder: (context, index) {
                                                  final salon = salonesFiltrados[index];
                                                  final nombreSalon = "${salon['edificio_nombre']}-${salon['nombre']}";
                                                  final idSalon = salon['id'] as int;
                                                  
                                                  final yaEsFavorito = salonesFavoritos.any((s) => s['id'] == idSalon);
                                                  
                                                  return ListTile(
                                                    title: Text(nombreSalon),
                                                    trailing: Icon(
                                                      yaEsFavorito ? Icons.check : Icons.add,
                                                      color: yaEsFavorito ? Colors.green : Colors.blue,
                                                    ),
                                                    enabled: !yaEsFavorito,
                                                    onTap: yaEsFavorito ? null : () async {
                                                      await estudiante.toggleSalonFavorito(idSalon, true);
                                                      setState(() {
                                                        salonesFavoritos.add(salon);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cerrar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.add, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...salonesFavoritos.map((salon) => _itemFavorito(salon)).toList(),

                    //los ... Toma una lista anidada y la aplana para que todo quede en un solo nivel.
                    //ya que se espera una sola lista de widgets, pero favoritos.map() devuelve una lista de listas de widgets, entonces los ... se encargan de aplanar esa estructura.
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  TextEditingController mensajeController =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Contactar administrador'),
                        content: TextField(
                          controller: mensajeController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Escribe tu mensaje...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Mensaje enviado al administrador',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text('Enviar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined, color: Colors.blue),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contactar administrador',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '¿Tienes sugerencias o reportes?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Cerrar sesión'),
                        content: const Text(
                          '¿Estás segura de que quieres cerrar sesión?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              auth.cerrarSesion();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 12),
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
