import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/usuarios_provider.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});
  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsuariosProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio UCN', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Botón para filtrar solo favoritos
          IconButton(
            icon: Icon(provider.visibles.isNotEmpty && provider.esFavorito(provider.visibles.first.id) ? Icons.star : Icons.star_border),
            tooltip: 'Solo Favoritos',
            onPressed: () => provider.alternarSoloFavoritos(),
          )
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda moderna
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), 
                  borderSide: BorderSide.none
                ),
              ),
              onChanged: provider.buscar,
            ),
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(UsuariosProvider provider) {
    // 1. Estado de carga
    if (provider.estado == Estado.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // 2. Estado de error (Sin internet y sin datos)
    if (provider.estado == Estado.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            // AQUÍ ESTABA EL ERROR: Se quitó el guion bajo
            Text(provider.errorMsg, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: provider.cargar, 
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar')
            ),
          ],
        ),
      );
    }

    // 3. Estado de éxito
    final lista = provider.visibles;
    if (lista.isEmpty) {
      return const Center(child: Text('No se encontraron usuarios'));
    }

    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final user = lista[index];
        final isFav = provider.esFavorito(user.id);
        
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                user.nombre[0], 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).colorScheme.primary
                )
              ),
            ),
            title: Text(user.nombre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            subtitle: Text(user.correo, style: const TextStyle(color: Colors.grey)),
            trailing: IconButton(
              icon: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.amber, size: 28),
              onPressed: () => provider.alternarFavorito(user.id),
            ),
            onTap: () => context.push('/detalle/${user.id}'),
          ),
        );
      },
    );
  }
}