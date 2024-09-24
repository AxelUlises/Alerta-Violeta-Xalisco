import 'package:flutter/material.dart';
import 'UI/location_permission_screen.dart'; // Asegúrate de tener este archivo creado

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alerta Violeta Xalisco',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Tema púrpura para la app
      ),
      home: const SplashScreen(), // Pantalla de inicio (Splash Screen)
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Inicializamos el AnimationController para la animación de zoom
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Duración de la animación
      vsync: this,
    )..forward(); // Iniciamos la animación inmediatamente

    // Definimos la animación que hará el "zoom in"
    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navegamos a la pantalla de permisos después de la duración del splash
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LocationPermissionScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Limpia el controlador cuando se destruye el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -35 * _controller.value), // Desplaza la imagen hacia arriba al final
              child: ScaleTransition(
                scale: _animation, // Aplicamos el "zoom"
                child: Image.asset(
                  'assets/Logo.png', // Asegúrate de tener el logo en assets
                  height: 300, // Tamaño inicial de la imagen
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
