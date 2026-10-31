import 'package:flutter/material.dart';
import '../data/usuarios_repository.dart';
import '../models/usuario.dart';

enum Estado { inicial, cargando, exito, error }

class UsuariosProvider extends ChangeNotifier {
  UsuariosProvider(this._repo);
  final UsuariosRepository _repo;

  Estado estado = Estado.inicial;
  List<Usuario> _usuarios = [];
  Set<int> _favoritos = {};
  String _textoBusqueda = '';
  bool _soloFavoritos = false;
  
  // Aquí está la variable que se había borrado
  String _errorMsg = ''; 
  
  // Aquí está el getter que agregamos
  String get errorMsg => _errorMsg;

  // Getter para obtener la lista filtrada (por búsqueda y favoritos)
  List<Usuario> get visibles {
    return _usuarios.where((u) {
      final coincideBusqueda = u.nombre.toLowerCase().contains(_textoBusqueda.toLowerCase());
      final esFav = !_soloFavoritos || _favoritos.contains(u.id);
      return coincideBusqueda && esFav;
    }).toList();
  }

  Future<void> cargar() async {
    estado = Estado.cargando;
    notifyListeners(); // Avisa a la UI que muestre el spinner

    try {
      _usuarios = await _repo.obtenerUsuarios();
      _favoritos = await _repo.favoritos();
      estado = Estado.exito;
    } catch (e) {
      _errorMsg = 'No hay conexión y no hay datos guardados localmente.';
      estado = Estado.error;
    }
    notifyListeners(); // Avisa a la UI que ya terminó
  }

  void buscar(String texto) {
    _textoBusqueda = texto;
    notifyListeners();
  }

  void alternarSoloFavoritos() {
    _soloFavoritos = !_soloFavoritos;
    notifyListeners();
  }

  Future<void> alternarFavorito(int id) async {
    await _repo.alternarFavorito(id);
    _favoritos = await _repo.favoritos();
    notifyListeners();
  }

  bool esFavorito(int id) => _favoritos.contains(id);
  
  Usuario? porId(int id) {
    try {
      return _usuarios.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }
}