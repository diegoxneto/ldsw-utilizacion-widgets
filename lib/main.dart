import 'package:flutter/material.dart';
// 1. Importa los paquetes de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 2. Importa el archivo de configuración que se autogeneró
import 'firebase_options.dart';

// 3. El main() AHORA DEBE SER ASÍNCRONO
void main() async {
  // 4. Asegúrate de que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Inicializa Firebase usando el archivo autogenerado
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 6. Ejecuta la app
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
          title: const Text('Act. 3.7 - Integración Firebase'),
        ),
        body: Center(
          // 7. Vamos a crear un botón para probar la base de datos
          child: ElevatedButton(
            child: const Text('Agregar Película de Prueba'),
            onPressed: () {
              // Esta función se ejecuta al presionar el botón
              agregarPelicula();
            },
          ),
        ),
      ),
    );
  }

  // 8. Esta es la función que CUMPLE EL CRITERIO DE EVALUACIÓN
  void agregarPelicula() async {
    try {
      // Obtiene la "colección" (la carpeta) de películas en Firestore
      final coleccion = FirebaseFirestore.instance.collection('peliculas');

      // Agrega un nuevo "documento" (un archivo) con datos
      await coleccion.add({
        'titulo': 'Pelicula de Prueba',
        'director': 'Yo Mismo',
        'anio': 2025
      });

      print('¡Película agregada con éxito!');

    } catch (e) {
      print('Error al agregar la película: $e');
    }
  }
}