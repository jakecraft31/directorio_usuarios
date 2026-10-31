import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuarios_provider.dart';

class DetalleScreen extends StatelessWidget {
  final int id;
  const DetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsuariosProvider>();
    final user = provider.porId(id);
    final isFav = provider.esFavorito(id);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Usuario no encontrado')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Contacto'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.amber, size: 30),
            onPressed: () => provider.alternarFavorito(id),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar grande
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  user.nombre[0], 
                  style: TextStyle(
                    fontSize: 50, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary
                  )
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(user.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            
            // Tarjeta con la información
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue), 
                      title: Text(user.correo), 
                      subtitle: const Text('Correo electrónico')
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green), 
                      title: Text(user.telefono), 
                      subtitle: const Text('Teléfono')
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_city, color: Colors.orange), 
                      title: Text(user.ciudad), 
                      subtitle: const Text('Ciudad')
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.business, color: Colors.purple), 
                      title: Text(user.empresa), 
                      subtitle: const Text('Empresa')
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}