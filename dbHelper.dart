import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class dbHelper {
  dbHelper.singleton();

  static final dbHelper instance = dbHelper.singleton();

  factory dbHelper() {
    return instance;
  }

  static late Database _db;

  Future<Database> db() async {
    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    final Directory dir = await getApplicationDocumentsDirectory();

    String dbPath = join(dir.path, "Student_Management.db");

    Database db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, ver) => createTable(db, ver),
    );

    return db;
  }

  static final String TABLE_NAME = "students";

  Future<void> createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        rollNo TEXT NOT NULL,
        course TEXT NOT NULL,
        semester TEXT NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertStudent(Map<String, dynamic> student) async {
    Database database = await db();

    return await database.insert(
      TABLE_NAME,
      student,
    );
  }

  // READ
  Future<List<Map<String, dynamic>>> getStudents() async {
    Database database = await db();

    return await database.query('students');
  }

  // UPDATE
  Future<int> updateStudent(
      int id, Map<String, dynamic> student) async {
    Database database = await db();

    return await database.update(
      'students',
      student,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    Database database = await db();

    return await database.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}