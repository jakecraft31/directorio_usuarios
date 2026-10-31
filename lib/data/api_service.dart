import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiService {
  // Nota: La URL del PDF tiene un error tipográfico (typecode), usamos la correcta:
  static const _url = 'https://jsonplaceholder.typicode.com/users';

  Future<List<Usuario>> obtenerUsuarios() async {
    // Petición con timeout de 10 segundos
    final response = await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 10));
    
    // Validación del código de estado
    if (response.statusCode != 200) {
      throw Exception('Error en el servidor: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Usuario.fromJson(json)).toList();
  }
}