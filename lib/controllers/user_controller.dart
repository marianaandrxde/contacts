import 'package:contacts/db/db.dart';

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
  print('Buscando usuário com email: $email e senha: $senha');
  
  final result = await db.query(
    'users',
    where: 'email = ? AND senha = ?',
    whereArgs: [email, senha],
  );
  
  print('Resultado da consulta: $result');
  
  if (result.isEmpty) {
    print('Falha no login: email ou senha incorretos');
  } else {
    print('Usuário encontrado: $result');
  }
  
  return result.isNotEmpty ? result.first : null;
}



  // Função para retornar todos os usuários
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('users');
    return result;
  }
}
