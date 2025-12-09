import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseService {
  static const String _dbName = 'books.db';
  static const String _tableName = 'books';
  static const int _version = 2;

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _dbName);

    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // 📌 CREATE TABLE (Versión 1)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        publishedDate TEXT,
        pages INTEGER,
        rating REAL,
        isbn TEXT,
        isFavorite INTEGER DEFAULT 0,
        addedDate TEXT NOT NULL,
        userNotes TEXT
      )
    ''');
  }

  // 📌 MIGRACIÓN a versión 2 (Agrega userNotes si no existía)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE $_tableName ADD COLUMN userNotes TEXT;");
    }
  }

  // -------------------------------------------------------------
  // CRUD COMPLETO
  // -------------------------------------------------------------

  // CREATE
  Future<void> addBook(Book book) async {
    final db = await database;

    final bookToAdd = book.copyWith(
      addedDate: book.addedDate ?? DateTime.now(),
    );

    await db.insert(
      _tableName,
      bookToAdd.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ - Todos los libros
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result.map((json) => Book.fromDatabase(json)).toList();
  }

  // READ - Solo favoritos
  Future<List<Book>> getFavoriteBooks() async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return result.map(Book.fromDatabase).toList();
  }

  // READ - Por ID
  Future<Book?> getBookById(String id) async {
    final db = await database;

    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? Book.fromDatabase(result.first) : null;
  }

  // READ - Buscar por título
  Future<List<Book>> searchBooksByTitle(String title) async {
    final db = await database;

    final result = await db.query(
      _tableName,
      where: 'title LIKE ?',
      whereArgs: ['%$title%'],
    );

    return result.map(Book.fromDatabase).toList();
  }

  // READ - Buscar por autor
  Future<List<Book>> searchBooksByAuthor(String author) async {
    final db = await database;

    final result = await db.query(
      _tableName,
      where: 'author LIKE ?',
      whereArgs: ['%$author%'],
    );

    return result.map(Book.fromDatabase).toList();
  }

  // UPDATE - Cambiar favorito
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    final db = await database;

    await db.update(
      _tableName,
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE - Completo
  Future<void> updateBook(Book book) async {
    final db = await database;

    await db.update(
      _tableName,
      book.toJson(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // UPDATE - Notas del usuario
  Future<void> updateNotes(String id, String notes) async {
    final db = await database;

    await db.update(
      _tableName,
      {'userNotes': notes},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<void> deleteBook(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL
  Future<void> deleteAllBooks() async {
    final db = await database;
    await db.delete(_tableName);
  }

  // COUNT - Total libros
  Future<int> getTotalBooks() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // COUNT - Total favoritos
  Future<int> getTotalFavorites() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE isFavorite = 1',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
