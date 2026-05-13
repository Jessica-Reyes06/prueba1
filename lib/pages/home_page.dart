import 'package:flutter/material.dart';
import 'mapa_file.dart'; //para ir a la pantalla del mapa
import 'perfil_page.dart'; //para ir a la pantalla del perfil
import 'detalle_salon_page.dart'; //para ir a la pantalla del detalle del salón
import 'salon_model.dart'; //para usar la clase Salon y crear objetos de salón
import 'reportar_salon.dart';

class HomePage extends StatefulWidget {
  // apariencia fija
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    //método que conecta ambas clases
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // el estado que cambia y los atributos que cambian
  String edificioSeleccionado = 'Todos';
  int paginaActual = 0;

  //SALONES ESTÁTICOS PARA VISUALIZAR DISEÑO
  final List<Salon> salones = [
    const Salon(
      nombre: 'E-105',
      edificio: 'Edificio E',
      tieneClima: true,
      personas: 0,
      disponible: true,
      favorito: true,
    ),
    const Salon(
      nombre: 'A-201',
      edificio: 'Edificio A',
      tieneClima: false,
      personas: 2,
      disponible: true,
      favorito: false,
    ),
  ];

  List<Salon> get salonesFiltrados {
    if (edificioSeleccionado == 'Todos') {
      return salones;
    }

    return salones.where((salon) {
      return salon.edificio == 'Edificio $edificioSeleccionado' ||
          salon.edificio.contains('Edificio $edificioSeleccionado');
    }).toList();
  }

  Widget _botonEdificio(String nombre) {
    return GestureDetector(
      onTap: () {
        setState(() {
          //setState le dice a Flutter que algo cambió y que debe redibujar la pantalla
          edificioSeleccionado = nombre;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: edificioSeleccionado == nombre
              ? const Color.fromARGB(255, 8, 73, 126)
              : Colors
                    .white, //operador ternario para cambiar el color del botón seleccionado
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            nombre,
            style: TextStyle(
              color: edificioSeleccionado == nombre
                  ? Colors.white
                  : Colors
                        .black, //operador ternario para cambiar el color del texto
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tarjetaSalon(BuildContext context, Salon salon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleSalonPage(salon: salon),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(salon.edificio),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.ac_unit,
                        color: salon.tieneClima
                            ? Colors.blue
                            : Colors
                                  .red, //operador ternario para cambiar el color del icono
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Clima',
                        style: TextStyle(
                          color: salon.tieneClima
                              ? Colors.blue
                              : Colors
                                    .red, //operador ternario para cambiar el color del texto
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.group, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${salon.personas}',
                      ), //interpolación de strings para mostrar el valor del atributo
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end, //alinea los hijos hacia la derecha
              children: [
                Text(
                  salon.disponible
                      ? 'Disponible ahora'
                      : 'No disponible', //operador ternario para mostrar el estado del salón
                  style: TextStyle(
                    color: salon.disponible ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  salon.favorito
                      ? Icons.star
                      : Icons
                            .star_border, //operador ternario para mostrar la estrella
                  color: salon.favorito ? Colors.amber : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paginaSalones() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .start, //alinea todos los hijos de la Column hacia la izquierda
        children: [
          const Text(
            'AulaLibre',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar edificio o salón...',
              prefixIcon: const Icon(Icons.search),
              filled:
                  true, //bool que le dice a Flutter si debe aplicar o no el fillColor
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, //sin borde visible
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView(
              // lista de widgets con scroll
              scrollDirection: Axis.horizontal, //scroll horizontal
              children: [
                _botonEdificio('Todos'),
                _botonEdificio('A'),
                _botonEdificio('E'),
                _botonEdificio('B'),
                _botonEdificio('J'),
                _botonEdificio('K'),
                _botonEdificio('W'),
                _botonEdificio('X'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: salonesFiltrados.isEmpty
                ? const Center(
                    child: Text(
                      'No hay salones disponibles para este edificio.',
                    ),
                  )
                : ListView.builder(
                    itemCount: salonesFiltrados.length,
                    itemBuilder: (context, index) {
                      return _tarjetaSalon(context, salonesFiltrados[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _paginaActiva() {
    switch (paginaActual) {
      case 0:
        return _paginaSalones();
      case 1:
        return const MapaPage();
      case 2:
        return const PerfilPage();
      default:
        return _paginaSalones();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const ReportarSalonSheet(),
          );
        },
        backgroundColor: const Color.fromARGB(255, 8, 73, 126),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaActual, //indica qué página está activa
        onTap: (index) {
          setState(() {
            paginaActual = index; //cambia la página activa
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Salones'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(child: _paginaActiva()),
    );
  }
}
