import '../db/db.dart';

class ContactController {
  final dbHelper = DatabaseHelper.instance;

  Future<int> createContact(int userId, String nome, String coordenada, String email) async {
    final db = await dbHelper.database;
    return await db.insert('contacts', {
      'nome': nome,
      'coordenada': coordenada,
      'email': email,
      'userId': userId,
    });
  }

  Future<List<Map<String, dynamic>>> getContacts(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'contacts',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
