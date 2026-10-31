import '../models/usuario.dart';
import 'api_service.dart';
import 'local_db.dart';

class UsuariosRepository {
  UsuariosRepository(this._api, this._local);
  
  final ApiService _api;
  final LocalDb _local;

  Future<List<Usuario>> obtenerUsuarios() async {
    try {
      // 1. Intentar descargar de la API
      final usuariosRed = await _api.obtenerUsuarios();
      // 2. Si funciona, guardar en SQLite
      await _local.guardarUsuarios(usuariosRed);
      return usuariosRed;
    } catch (e) {
      // 3. Si falla (sin internet), leer de SQLite
      final usuariosLocal = await _local.leerUsuarios();
      if (usuariosLocal.isNotEmpty) {
        return usuariosLocal;
      }
      // 4. Si no hay nada guardado, relanzar el error
      rethrow;
    }
  }

  Future<Set<int>> favoritos() => _local.leerFavoritos();
  Future<void> alternarFavorito(int id) => _local.alternarFavorito(id);
}