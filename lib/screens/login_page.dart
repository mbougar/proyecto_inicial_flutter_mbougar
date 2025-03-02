import 'package:flutter/material.dart';
import 'package:flutter_first_app/screens/product_list_page.dart';

// Página de inicio de sesión
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// La separación entre `LoginPage` y `_LoginPageState` se debe al patrón de diseño de Flutter para widgets con estado.
// `LoginPage` es un StatelessWidget que define la estructura general del widget, 
// mientras que `_LoginPageState` maneja el estado mutable de la pantalla (como los datos de los campos de texto y las interacciones del usuario).
// Sería como un viewmodel en compose, pero en Flutter.

class _LoginPageState extends State<LoginPage> {
  // Controladores para capturar la entrada del usuario en los campos de texto
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Función que maneja el proceso de inicio de sesión
  void _login() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Exitoso'),
        content: const Text('¡Te has logueado correctamente!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo emergente
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProductListPage()), // Navega a la pantalla de productos
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Agrega margen alrededor del contenido
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido al mínimo necesario
            children: [
            
              const SizedBox(height: 20), // Espaciado entre elementos

              // Campo de texto para el nombre de usuario
              TextField(
                controller: _usernameController, // Asigna el controlador para capturar la entrada
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              const SizedBox(height: 10),

              // Campo de texto para la contraseña
              TextField(
                controller: _passwordController, // Asigna el controlador para capturar la entrada
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true, // Oculta la contraseña al escribir
              ),
              const SizedBox(height: 20),

              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: _login, // Llama a la función _login cuando se presiona
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color de fondo del botón
                  foregroundColor: Colors.white, // Color del texto del botón
                ),
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
