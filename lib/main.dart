import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Act. 3.5 - Home Screen',
          style: TextStyle(
            fontSize: 30.0,                   // Tamaño de fuente
            fontWeight: FontWeight.bold,      // Grosor (negrita)
            color: Colors.white,              // Color del texto
            shadows: [                        // Sombras (igual que el texto del body)
              Shadow(blurRadius: 15.0, color: Colors.black, offset: Offset(4.0, 4.0),)
            ],
          ),
        ),
        backgroundColor: Colors.transparent, // Barra transparente
        elevation: 0, // Sin sombra
      ),
        // Hacemos que la barra sea transparente y que el body
        // se extienda detrás de ella.
        extendBodyBehindAppBar: true,
        
        // --- Uso de STACK ---
        // Usamos un STACK para poner el contenido (textos, icono)
        // ENCIMA de la imagen de fondo.
        body: Stack(
          // fit: StackFit.expand hace que los hijos (como la imagen)
          // llenen todo el espacio del Stack.
          fit: StackFit.expand, 
          children: [
            
            // --- 1. IMAGEN DE FONDO (Uso de Image) ---
            // Este es el primer widget en el Stack (el del fondo).
            Image.asset(
              'assets/background.jpg', // ¡Cambia esto por el nombre de tu imagen!
              fit: BoxFit.cover, // Hace que la imagen cubra toda la pantalla
            ),

            // --- 2. CONTENIDO (Icono y Textos) ---
            // Este es el segundo widget en el Stack (encima de la imagen).
            // Usamos Center y Column para organizar el contenido.
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // --- Uso de ICON (Criterio de evaluación) ---
                  const Icon(
                    Icons.movie_filter_sharp, // Un ícono de claqueta de cine
                    color: Colors.white,
                    size: 100.0,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                  ),
                  
                  const SizedBox(height: 20), // Un espacio separador

                  // --- Nombre de la Aplicación (Instrucción) ---
                  const Text(
                    'Cinephile Catalog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                    ),
                  ),

                  const SizedBox(height: 10), // Un espacio separador
                  
                  // --- Mensaje "Hello World" (Criterio de evaluación) ---
                  const Text(
                    'Hello World! Bienvenido.', // Cumple ambos requisitos
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}