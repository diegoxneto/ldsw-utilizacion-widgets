import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Importamos Auth
import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de Películas',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
      ),
      home: AuthGate(),
    );
  }
}

// --- WIDGET "VIGILANTE" ---
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // 2. Escucha los cambios de estado de autenticación
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 3. Si el snapshot está cargando, muestra un indicador
        if (!snapshot.hasData) {
          // 4. Si NO hay datos (usuario no loggeado), muestra la Home
          return const HomeScreen();
        }

        // 5. Si SÍ hay datos (usuario loggeado), muestra el Catálogo
        return const CatalogScreen();
      },
    );
  }
}