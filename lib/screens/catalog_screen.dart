import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importa las otras pantallas para poder navegar a ellas
import 'admin_screen.dart';
import 'description_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Referencia a nuestra base de datos
    final CollectionReference peliculas =
        FirebaseFirestore.instance.collection('peliculas');

    return Scaffold(
      appBar: AppBar(
        // Menú en la parte superior (del criterio de evaluación)
        title: const Text('Catálogo de Películas'),
        actions: [
          // Botón para ir a la pantalla de Admin
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            },
          ),
          // Botón para cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // El AuthGate detectará esto y nos regresará al HomeScreen
            },
          ),
        ],
      ),
      // StreamBuilder se conecta a Firestore y escucha cambios en tiempo real
      body: StreamBuilder<QuerySnapshot>(
        stream: peliculas.snapshots(),
        builder: (context, snapshot) {
          // Si está cargando, muestra un indicador
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si no hay películas, muestra un mensaje
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay películas en el catálogo.'));
          }

          // Si hay datos, construye la lista
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Obtiene el documento de la película
              var movieDoc = snapshot.data!.docs[index];
              Map<String, dynamic> movie =
                  movieDoc.data() as Map<String, dynamic>;

              // Muestra el título y la imagen (del criterio de evaluación)
              return ListTile(
                // USA UN VALOR DE RESPALDO SI LA IMAGEN O TÍTULO SON NULOS
                leading: Image.network(
                  movie['imagenUrl'] ?? 'https://via.placeholder.com/50',
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
                title: Text(movie['titulo'] ?? 'Sin Título'),
                subtitle: Text(movie['genero'] ?? 'Sin Género'),
                onTap: () {
                  // Al tocar, navega a la pantalla de descripción
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionScreen(
                        // Pasa los datos de la película a la siguiente pantalla
                        movie: movie,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}