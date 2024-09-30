class Receta {
  String nombre;
  String ingredientes;
  String preparacion;
  List<double> listaCalificaciones;
  bool favorito;
  int calificacionUsuario; // Calificación seleccionada por el usuario

  Receta({
    required this.nombre,
    required this.ingredientes,
    required this.preparacion,
    required this.listaCalificaciones,
    required this.favorito,
    required this.calificacionUsuario,
  });

  // Método para obtener el promedio de calificaciones
  double get calificacionPromedio {
    if (listaCalificaciones.isEmpty) {
      return 0;
    }
    double suma = listaCalificaciones.reduce((a, b) => a + b);
    if(calificacionUsuario!=0)
    return (suma+calificacionUsuario) / (listaCalificaciones.length+1);
    return (suma+calificacionUsuario) / (listaCalificaciones.length);
  }
  int get totalCalificaiones{

    if(calificacionUsuario!=0)
    return listaCalificaciones.length+1;
    return listaCalificaciones.length;
  }
  

}