import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/router.dart';
import 'data/api_service.dart';
import 'data/local_db.dart';
import 'data/usuarios_repository.dart';
import 'providers/usuarios_provider.dart';

void main() {
  // Inicializamos las dependencias (Repositorio -> API y BD)
  final repo = UsuariosRepository(ApiService(), LocalDb());
  
  runApp(
    ChangeNotifierProvider(
      // El "..cargar()" hace que la app descargue los datos apenas abre
      create: (_) => UsuariosProvider(repo)..cargar(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Directorio UCN',
      debugShowCheckedModeBanner: false, // Quita la cinta de DEBUG
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), // Color bonito
        useMaterial3: true,
      ),
      routerConfig: appRouter, // Usamos el enrutador que creamos
    );
  }
}