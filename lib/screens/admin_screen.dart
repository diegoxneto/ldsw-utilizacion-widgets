import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Controladores para el formulario de "Alta"
  final _tituloController = TextEditingController();
  final _anioController = TextEditingController();
  final _directorController = TextEditingController();
  final _generoController = TextEditingController();
  final _sinopsisController = TextEditingController();
  final _imagenUrlController = TextEditingController();

  // Referencia a la base de datos
  final CollectionReference peliculas =
      FirebaseFirestore.instance.collection('peliculas');

  // --- FUNCIÓN DE ALTA ---
  Future<void> _darDeAlta() async {
    if (_tituloController.text.isEmpty) {
      // Muestra un error si el título está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título es obligatorio')),
      );
      return;
    }

    // Añade el nuevo documento a Firestore
    await peliculas.add({
      'titulo': _tituloController.text,
      'anio': int.tryParse(_anioController.text) ?? 2000, // Convierte a número
      'director': _directorController.text,
      'genero': _generoController.text,
      'sinopsis': _sinopsisController.text,
      'imagenUrl': _imagenUrlController.text,
    });

    // Limpia los campos después de agregar
    _tituloController.clear();
    _anioController.clear();
    _directorController.clear();
    _generoController.clear();
    _sinopsisController.clear();
    _imagenUrlController.clear();

    // Muestra mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Película agregada con éxito')),
    );
  }

  // --- FUNCIÓN DE BAJA ---
  Future<void> _darDeBaja(String docId) async {
    // Borra el documento usando su ID
    await peliculas.doc(docId).delete();

    // Muestra mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Película eliminada con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- FORMULARIO DE ALTA ---
            Text('Dar de Alta Nueva Película',
                style: Theme.of(context).textTheme.titleLarge),
            TextField(controller: _tituloController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: _anioController, decoration: const InputDecoration(labelText: 'Año'), keyboardType: TextInputType.number),
            TextField(controller: _directorController, decoration: const InputDecoration(labelText: 'Director')),
            TextField(controller: _generoController, decoration: const InputDecoration(labelText: 'Género')),
            TextField(controller: _sinopsisController, decoration: const InputDecoration(labelText: 'Sinopsis')),
            TextField(controller: _imagenUrlController, decoration: const InputDecoration(labelText: 'URL de la Imagen')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _darDeAlta,
              child: const Text('Agregar Película'),
            ),

            const Divider(height: 40),

            // --- LISTA PARA DAR DE BAJA ---
            Text('Dar de Baja (Eliminar)',
                style: Theme.of(context).textTheme.titleLarge),
            
            // Usamos un StreamBuilder para mostrar la lista de películas
            StreamBuilder<QuerySnapshot>(
              stream: peliculas.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return ListView.builder(
                  shrinkWrap: true, // Importante dentro de un SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll de esta lista
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var movieDoc = snapshot.data!.docs[index];
                    Map<String, dynamic> movie =
                        movieDoc.data() as Map<String, dynamic>;
                    
                    return ListTile(
                      title: Text(movie['titulo'] ?? 'Sin Título'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        // Al tocar, llama a la función de baja con el ID del documento
                        onPressed: () => _darDeBaja(movieDoc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}