class Receta {
  int? id;
  String nombre;
  String ingredientes;
  String? imagen;
  String preparacion;
  String productosAsociados;
  bool isMine;
  int conteo;

  Receta({
    this.id,
    required this.nombre,
    required this.ingredientes,
    this.imagen,
    required this.preparacion,
    required this.productosAsociados,
    required this.isMine,
    this.conteo = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'ingredientes': ingredientes,
      'imagen': imagen,
      'preparacion': preparacion,
      'productosAsociados': productosAsociados,
      'isMine': isMine ? 1 : 0, // Se almacena como 1 o 0 en la base de datos
      'conteo': conteo,
    };
  }
}