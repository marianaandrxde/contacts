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

  // Converter um Map para um objeto Contact
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      nome: map['nome'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      email: map['email'],
    );
  }

  // Converter um objeto Contact para Map (para inserção no banco)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'latitude': latitude,
      'longitude': longitude,
      'email': email,
    };
  }
}
