import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class LocalDb {
  Future<Database> _getDb() async {
    final path = join(await getDatabasesPath(), 'directorio.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Creamos la tabla de usuarios (datos cacheados)
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY, nombre TEXT, correo TEXT, 
            telefono TEXT, ciudad TEXT, empresa TEXT
          )
        ''');
        // Creamos la tabla de favoritos (solo IDs)
        await db.execute('''
          CREATE TABLE favoritos(usuario_id INTEGER PRIMARY KEY)
        ''');
      },
    );
  }

  Future<void> guardarUsuarios(List<Usuario> lista) async {
    final db = await _getDb();
    final batch = db.batch();
    for (var u in lista) {
      // Usamos replace SOLO en la tabla usuarios
      batch.insert('usuarios', u.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Usuario>> leerUsuarios() async {
    final db = await _getDb();
    final maps = await db.query('usuarios');
    return maps.map((m) => Usuario.fromMap(m)).toList();
  }

  Future<Set<int>> leerFavoritos() async {
    final db = await _getDb();
    final maps = await db.query('favoritos');
    return maps.map((m) => m['usuario_id'] as int).toSet();
  }

  Future<void> alternarFavorito(int id) async {
    final db = await _getDb();
    final existe = await db.query('favoritos', where: 'usuario_id = ?', whereArgs: [id]);
    
    if (existe.isNotEmpty) {
      // Si ya es favorito, lo eliminamos
      await db.delete('favoritos', where: 'usuario_id = ?', whereArgs: [id]);
    } else {
      // Si no es favorito, lo insertamos
      await db.insert('favoritos', {'usuario_id': id});
    }
  }
}