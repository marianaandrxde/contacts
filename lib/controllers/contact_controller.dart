import 'package:contacts/db/db.dart';
import 'package:contacts/models/contact.dart';
class ContactController {
  final dbHelper = DatabaseHelper.instance;

  // Função para adicionar um contato
  Future<void> addContact(Contact contact) async {
    final db = await dbHelper.database;
    await db.insert(
      'contacts',
      {
        'nome': contact.nome,
        'latitude': contact.latitude,
        'longitude': contact.longitude,
        'email': contact.email,
      },
    );
  }

  // Função para atualizar um contato
  Future<int> updateContact(Contact contact) async {
    final db = await dbHelper.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Função para excluir um contato
  Future<int> deleteContact(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Função para buscar todos os contatos
  Future<List<Contact>> fetchAllContacts() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('contacts');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  // Função para buscar um contato por ID
  Future<Contact?> fetchContactById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Contact.fromMap(result.first) : null;
  }
}
