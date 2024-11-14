import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa la cámara
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(camera, ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {});
  }

  // Toma la foto y regresa la ruta del archivo
  Future<void> _takePicture() async {
    if (_cameraController?.value.isInitialized ?? false) {
      final image = await _cameraController?.takePicture();
      setState(() {
        _imagePath = image?.path; // Guardamos la ruta del archivo
      });
      Navigator.pop(context, _imagePath); // Regresamos la ruta a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomar Foto'),
        backgroundColor: Colors.black, // Fondo negro para el AppBar
        foregroundColor: Colors.white, // Texto en blanco para el AppBar
        
      ),
      body: Container(
        color: Colors.black, // Fondo negro para el cuerpo de la pantalla
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Vista previa de la cámara
              if (_cameraController?.value.isInitialized ?? false)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75, // Ajustamos la altura para que ocupe el 75% de la pantalla
                  width: MediaQuery.of(context).size.width, // Ancho completo de la pantalla
                  child: CameraPreview(_cameraController!),
                )
              else
                const Center(child: CircularProgressIndicator()),

              const SizedBox(height: 20), // Espaciado entre la cámara y el botón

              // Botón con ícono para tomar la foto
              IconButton(
                icon: const Icon(Icons.camera_alt, size: 60, color: Colors.white), // Ícono de cámara
                onPressed: _takePicture, // Función para tomar la foto
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Liberamos los recursos de la cámara al salir
    super.dispose();
  }
}