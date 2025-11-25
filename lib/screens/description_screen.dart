import 'package:flutter/material.dart';

class DescriptionScreen extends StatelessWidget {
  // Recibimos un "mapa" con los datos de la película
  final Map<String, dynamic> movie;

  const DescriptionScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Función simple para obtener un valor o un texto por defecto
    String getMovieValue(String key) {
      return movie[key]?.toString() ?? 'No disponible';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getMovieValue('titulo')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la película
            Center(
              child: Image.network(
                getMovieValue('imagenUrl'),
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.hide_image, size: 100),
              ),
            ),
            const SizedBox(height: 20),

            // Muestra todos los campos requeridos
            _buildDetailRow('Título', getMovieValue('titulo')),
            _buildDetailRow('Año', getMovieValue('anio')),
            _buildDetailRow('Director', getMovieValue('director')),
            _buildDetailRow('Género', getMovieValue('genero')),
            
            const SizedBox(height: 10),
            
            // Sinopsis
            Text(
              'Sinopsis',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Text(
              getMovieValue('sinopsis'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  // Un widget helper para mostrar las filas de detalles
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}