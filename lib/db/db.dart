import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Exclui o banco de dados para reiniciar o desenvolvimento
    // **Somente durante o desenvolvimento**
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 2, // Atualiza para a versão 2
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // Lida com a atualização do banco
    );
  }

  // Função de criação do banco na primeira vez
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        latitude REAL NOT NULL,  -- Alteração: tipo REAL para latitude
        longitude REAL NOT NULL, -- Alteração: tipo REAL para longitude
        email TEXT NOT NULL      )
    ''');
  }

  // Função para atualizar o banco quando a versão mudar
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Atualiza a tabela contacts para incluir latitude e longitude
      await db.execute('''
        ALTER TABLE contacts ADD COLUMN latitude REAL;
        ALTER TABLE contacts ADD COLUMN longitude REAL;
      ''');
    }
  }
}
