import 'package:flutter/material.dart';
import 'package:team_mokup/pages/splashScreen.dart';

class ActivateAccount extends StatefulWidget {
  const ActivateAccount({super.key});

  @override
  State<ActivateAccount> createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o icono principal
              Icon(
                Icons.lock_outline_rounded,
                size: 80,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 30),

              // Título de inicio de sesión
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
              const SizedBox(height: 30),

              // Formulario de correo y contraseña
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de correo electrónico
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      
                    ),
                    const SizedBox(height: 20),

                    // Campo de contraseña
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Botón de inicio de sesión
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ), backgroundColor: Colors.blueGrey[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // Color del botón
                ),
                onPressed: () {
                  
                    // Navegar a la nueva pantalla
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashScreen(), // Cambiar por tu página de destino
                      ),
                    );
                  
                },
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18),
                  
                ),
              ),
              const SizedBox(height: 20),

              // Enlace para registrarse
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes una cuenta?'),
                  TextButton(
                    onPressed: () {
                      // Acción para ir a la pantalla de registro
                    },
                    child: const Text('Regístrate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}