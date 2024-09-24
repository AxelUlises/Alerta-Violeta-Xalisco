import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  _LocationPermissionScreenState createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Controlador de la animación
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duración de cada ciclo de la animación
      vsync: this,
    )..repeat(reverse: true); // Repetir la animación de forma cíclica

    // Definir la animación de "bounce" (brinco)
    _animation = Tween<double>(begin: 0, end: 35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Limpia el controlador cuando el widget se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Mueve todo hacia arriba
          crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
          children: [
            const SizedBox(height: 35),

            // AnimatedBuilder para aplicar la animación
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value), // Mueve la imagen hacia arriba y abajo
                  child: child,
                );
              },
              child: Image.asset(
                'assets/Location.png',
                height: 190,
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              "Acceso a tu ubicación",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6F40CB),
              ),
            ),
            const SizedBox(height: 20),
            const Text.rich(
              TextSpan(
                text: "Para poder brindarte ayuda, ocupamos acceder a tu ubicación. ",
                style: TextStyle(
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "Solo obtendremos y usaremos tu ubicación en caso de que estés en peligro.\n\n",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  TextSpan(
                    text: "Necesitamos que el permiso sea ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "Permitir todo el tiempo,",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  TextSpan(
                    text: " de esta forma, si solicitas ayuda, podremos ubicarte no importa que te desplaces y bloquees la aplicación.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _requestLocationPermission(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Aumenta el tamaño del botón
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Conceder permiso"),
            ),
          ],
        ),
      ),
    );
  }

  // Función para solicitar permisos de ubicación
  Future<void> _requestLocationPermission(BuildContext context) async {
    var status = await Permission.locationAlways.request();
    if (status.isGranted) {
      _showAlert(
        context,
        "Permiso concedido",
        "Esta app recopila tu localización para ubicarte en caso de una emergencia.",
      );
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _showAlert(
        context,
        "Permiso denegado",
        "Es necesario conceder el permiso para que la app funcione correctamente.",
      );
    }
  }

  // Función para mostrar una alerta explicativa
  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
