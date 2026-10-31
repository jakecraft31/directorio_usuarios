import 'package:flutter_test/flutter_test.dart';
import 'package:directorio_usuarios/models/usuario.dart';

void main() {
  test('Usuario.fromJson parsea correctamente el JSON anidado', () {
    // Simulamos un JSON exacto como el que devuelve la API
    final json = {
      "id": 1,
      "name": "Leanne Graham",
      "email": "Sincere@april.biz",
      "phone": "1-770-736-8031",
      "address": {
        "city": "Gwenborough"
      },
      "company": {
        "name": "Romaguera-Crona"
      }
    };

    // Convertimos el JSON a nuestro objeto Usuario
    final user = Usuario.fromJson(json);

    // Verificamos que los datos anidados se hayan leído bien
    expect(user.id, 1);
    expect(user.nombre, "Leanne Graham");
    expect(user.ciudad, "Gwenborough"); // Probamos el JSON anidado
    expect(user.empresa, "Romaguera-Crona"); // Probamos el JSON anidado
  });
}