# team_mokup

Este proyecto es una aplicación móvil desarrollada en Flutter para gestionar, crear, y explorar recetas de café. La aplicación está diseñada para proporcionar una experiencia fácil e intuitiva para aficionados al café y baristas, permitiéndoles interactuar con una comunidad que comparte y califica recetas.

## Funcionalidades Principales

*Explorar recetas de café: Acceso a una lista de recetas con diversas técnicas de preparación.

*Crear y editar recetas: Los usuarios pueden agregar nuevas recetas o editar las existentes, personalizando los ingredientes y pasos.

*Gestionar favoritos: Se puede guardar y consultar una lista de recetas favoritas.

*Comentarios y valoraciones: Posibilidad de comentar y calificar las recetas.

*Pantalla de inicio personalizada: La aplicación cuenta con una pantalla de carga personalizada para mejorar la experiencia del usuario.

## Instalación

1 Clona el repositorio: git clone https://github.com/tu_usuario/team_mokup.git

2 Navega al directorio del proyecto: cd team_mokup

3 Instala las dependencias de Flutter: flutter pub get

4 Ejecuta la aplicación: flutter run

## Dependencias Utilizadas

Este proyecto utiliza las siguientes dependencias principales:

*flutter_native_splash: Para configurar una pantalla de inicio personalizada.

*cupertino_icons: Para íconos con estilo iOS en la aplicación.

Puedes revisar más dependencias en el archivo pubspec.yaml.

## Configuración de Splash Screen

La pantalla de inicio de la aplicación se configura con la siguiente sección en el archivo pubspec.yaml:

flutter_native_splash:
  color: "#FFFFFF"
  color_dark: "#272727"
  image: assets/logos/logodos.png
  image_dark: assets/logos/logodos.png
  android_12:
    color: "#FFFFFF"
    color_dark: "#272727"
    image: assets/logos/logodos.png

Este archivo permite personalizar tanto la pantalla de inicio para temas claros como oscuros.

assets/
├── logos            # Contiene las imagenes en png de los logos
|
lib/
├── models/          # Contiene las clases para Receta, Usuario, Comentario
├── pages/           # Las pantallas principales de la aplicación (recetas, comentarios, etc.)


