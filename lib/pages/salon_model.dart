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
}
