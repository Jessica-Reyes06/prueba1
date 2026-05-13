import 'package:flutter/material.dart';
import 'package:prueba1/main.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() {
    return _PerfilPageState();
  }
}

class _PerfilPageState extends State<PerfilPage> {
  String nombreUsuario = 'Usuario';
  List<String> edificiosSeleccionados = ['Edificio A', 'Edificio E'];
  List<String> favoritos = ['E-105', 'A-201'];

  Widget _botonEdificioNotificacion(String edificio) {
    bool seleccionado = edificiosSeleccionados.contains(edificio);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (seleccionado) {
            edificiosSeleccionados.remove(edificio);
          } else {
            edificiosSeleccionados.add(edificio);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: seleccionado ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          edificio,
          style: TextStyle(
            color: seleccionado ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _itemFavorito(String salon) {
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
          Text(salon, style: const TextStyle(fontWeight: FontWeight.w500)),
          GestureDetector(
            onTap: () {
              setState(() {
                favoritos.remove(salon);
              });
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
                            nombreUsuario[0].toUpperCase(),
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
                              const Text(
                                'L24020369@veracruz.tecnm.mx',
                                style: TextStyle(color: Colors.grey),
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
                    const Text(
                      'Enero 2026',
                      style: TextStyle(
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
                      children:
                          [
                                'Edificio A',
                                'Edificio E',
                                'Edificio B',
                                'Edificio J',
                                'Edificio K',
                                'Edificio F',
                                'Edificio T',
                                'Edificio W',
                                'Edificio X',
                              ]
                              .map(
                                (edificio) =>
                                    _botonEdificioNotificacion(edificio),
                              )
                              .toList(),
                      //map es un método de las listas que transforma cada elemento en otra cosa.
                      //Aquí toma cada nombre de edificio y lo convierte en un botón
                      //.toList() — al final convierte el resultado de .map() de nuevo en una lista porque Wrap necesita una lista de widgets.
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
                                List<String> salonesDisponibles = [
                                  'E-105',
                                  'A-201',
                                  'B-304',
                                  'J-205',
                                  'K-101',
                                ];
                                return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                    List<String> salonesFiltrados =
                                        salonesDisponibles
                                            .where(
                                              (s) => s.toLowerCase().contains(
                                                busqueda.toLowerCase(),
                                              ),
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
                                                itemCount:
                                                    salonesFiltrados.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                      salonesFiltrados[index],
                                                    ),
                                                    trailing: const Icon(
                                                      Icons.add,
                                                      color: Colors.blue,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        if (!favoritos.contains(
                                                          salonesFiltrados[index],
                                                        )) {
                                                          favoritos.add(
                                                            salonesFiltrados[index],
                                                          );
                                                        }
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
                    ...favoritos.map((salon) => _itemFavorito(salon)).toList(),

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
