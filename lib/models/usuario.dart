import 'package:team_mokup/models/comentario.dart';
import 'package:team_mokup/models/receta.dart';

class Usuario {
  static final Usuario _instance = Usuario._internal();

  String nombre;
  String correo;
  String contrasena;
  List<Receta> recetas;
  List<Receta> favoritos;
  List<Comentario> comentarios;

  // Constructor privado
  Usuario._internal({
    this.nombre = '',
    this.correo = '',
    this.contrasena = '',
    this.recetas = const [],
    this.favoritos = const [],
    this.comentarios = const [],
  });

  // Método para acceder a la instancia
  static Usuario get instance => _instance;

  // Método para inicializar o modificar los datos del usuario
  void inicializarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
    required List<Receta> recetas,
    required List<Receta> favoritos,
    required List<Comentario> comentarios
  }) {
    _instance.nombre = nombre;
    _instance.correo = correo;
    _instance.contrasena = contrasena;
    _instance.recetas = recetas;
    _instance.favoritos = favoritos;
    _instance.comentarios=comentarios;
  }

  void agregarFavorito(Receta receta) {
    favoritos.add(receta);
  }
  void agregarReceta(Receta receta) {
    recetas.add(receta);
  }
  void editarReceta(Receta recetaEditada) {
    // Busca la receta que deseas editar y actualiza sus valores
    final index = recetas.indexWhere((receta) => receta.nombre == recetaEditada.nombre);
    if (index != -1) {
      recetas[index] = recetaEditada; // Actualizar la receta
    }
  }
  void removerFavorito(Receta receta) {
    favoritos.remove(receta);
  }
  void agregarComentario(Comentario comentario) {
    comentarios.add(comentario);
  }

  // Método para acceder a los comentarios
  List<Comentario> obtenerComentarios() {
    return comentarios;
  }
}