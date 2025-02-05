import '../db/db.dart';

class UserController {
  final dbHelper = DatabaseHelper.instance;

  Future<int> registerUser(String username, String email, String senha) async {
    final db = await dbHelper.database;
    final result = await db.insert('users', {
      'username': username,
      'email': email,
      'senha': senha,
    });

    return result;
  }

  Future<Map<String, dynamic>?> loginUser(String email, String senha) async {
    final db = await dbHelper.database;
    
    final result = await db.query(
      'users',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    return result.isNotEmpty ? result.first : null;
  }
}
