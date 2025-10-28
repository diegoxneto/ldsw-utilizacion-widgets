// Importa el paquete de Material Design
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la banda de "Debug"
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Act. 3.4 - Demo de Widgets'),
        ),
        
        // --- Uso de COLUMN ---
        // COLUMN organiza a sus hijos de forma vertical (uno debajo del otro).
        body: Column(
          // mainAxisAlignment.spaceEvenly distribuye el espacio vertical
          // de manera uniforme entre los hijos.
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            // --- Uso de CONTAINER y TEXT ---
            // CONTAINER es una "caja" que nos permite dar estilo
            // (color, padding, márgenes, bordes, etc.).
            // TEXT, como su nombre indica, muestra un texto.
            Container(
              color: Colors.blue[100], // Color de fondo
              padding: const EdgeInsets.all(16.0), // Espacio interno
              child: const Text(
                '1. Esto es un TEXT dentro de un CONTAINER.',
                style: TextStyle(fontSize: 18),
              ),
            ),

            // --- Uso de ROW ---
            // ROW organiza a sus hijos de forma horizontal (uno al lado del otro).
            const Row(
              // mainAxisAlignment.spaceAround distribuye el espacio horizontal
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('2. Hijo A (Row)'),
                Text('Hijo B (Row)'),
                Text('Hijo C (Row)'),
              ],
            ),

            // --- Uso de STACK ---
            // STACK apila widgets uno encima del otro.
            // Es perfecto para poner texto sobre una imagen o un fondo.
            Stack(
              // Alignment.center centra a los hijos (uno encima del otro)
              alignment: Alignment.center,
              children: [
                // Widget base (abajo)
                Container(
                  width: 250,
                  height: 100,
                  color: Colors.green[200],
                ),
                // Widget superior (encima)
                Container(
                  width: 200,
                  height: 50,
                  color: Colors.green[400],
                ),
                // Widget más superior (encima de todos)
                const Text(
                  '3. Esto es un STACK (texto sobre contenedores)',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}