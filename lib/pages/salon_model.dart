class Salon {
  final String nombre; //final: una vez asignado el valor no puede cambiar
  final String edificio;
  final bool tieneClima;
  final int personas;
  final bool disponible;
  final bool favorito;

  const Salon({
    required this.nombre, //obliga a que cuando crees un objeto Salon le pases ese atributo obligatoriamente
    required this.edificio,
    required this.tieneClima,
    required this.personas,
    required this.disponible,
    required this.favorito,
  });

  factory Salon.fromMap(Map<String, dynamic> map) {
    return Salon(
      nombre: '${map['edificio_nombre'] ?? ''}-${map['salon_nombre'] ?? ''}',
      edificio: 'Edificio ${map['edificio_nombre'] ?? ''}',
      tieneClima: map['clima_funciona'] ?? false,
      personas: map['total_alumnos'] ?? 0,
      disponible: map['esta_vacio'] ?? true,
      favorito: map['es_favorito'] ?? false,
    );
  }//Convierte un mapa de datos en una instancia de la clase Salon.
}
