import 'dart:convert'; // Para decodificar la respuesta JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importa el paquete http

// --- 1. MODELO DE DATOS ACTUALIZADO ---
// Ahora también guardamos la URL de la imagen (imageUrl)
class Pokemon {
  final String name;
  final String imageUrl; 

  const Pokemon({
    required this.name,
    required this.imageUrl, 
  });

  // --- 2. CONSTRUCTOR 'fromJson' ACTUALIZADO ---
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'] ?? 'Nombre no encontrado', // Respaldo para el nombre
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? 'https://via.placeholder.com/150'    );
  }
}

// --- FUNCIÓN DE PETICIÓN HTTP (Esta no cambia) ---
Future<Pokemon> fetchPokemon() async {
  final response = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/gengar'));

  if (response.statusCode == 200) {
    return Pokemon.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error al cargar el Pokémon');
  }
}

// --- INTERFAZ DE USUARIO ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Pokemon> futurePokemon;

  @override
  void initState() {
    super.initState();
    futurePokemon = fetchPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Act. 3.6 - HTTP con Imagen'),
        ),
        body: Center(
          child: FutureBuilder<Pokemon>(
            future: futurePokemon,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                
                // --- 3. UI ACTUALIZADA ---
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      snapshot.data!.imageUrl,
                      height: 300,
                      width: 300,
                    ),
                    const SizedBox(height: 20), 
                    Text(
                      snapshot.data!.name.toUpperCase(),
                      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}