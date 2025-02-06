class Contact {
  final int? id;
  final String nome;
  final double latitude;
  final double longitude;
  final String email;

  Contact({
    this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.email,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      nome: map['nome'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'latitude': latitude,
      'longitude': longitude,
      'email': email,
    };
  }
}
