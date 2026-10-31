class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final String telefono;
  final String ciudad;
  final String empresa;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.ciudad,
    required this.empresa,
  });

  // Convierte el JSON de la API a nuestro objeto Dart
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['name'],
      correo: json['email'],
      telefono: json['phone'],
      // La ciudad y empresa vienen anidadas en el JSON
      ciudad: json['address']?['city'] ?? 'Sin ciudad',
      empresa: json['company']?['name'] ?? 'Sin empresa',
    );
  }

  // Convierte el objeto a un Map para guardarlo en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'telefono': telefono,
      'ciudad': ciudad,
      'empresa': empresa,
    };
  }

  // Convierte lo que viene de SQLite a nuestro objeto Dart
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      correo: map['correo'],
      telefono: map['telefono'],
      ciudad: map['ciudad'],
      empresa: map['empresa'],
    );
  }
}