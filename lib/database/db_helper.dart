import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:developer';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('booth.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final db = await openDatabase(path, version: 1, onCreate: _createDB);

    // enable foreign key
    await db.execute('PRAGMA foreign_keys = ON');

    return db;
  }

  // create table
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        username TEXT NOT NULL UNIQUE,
        role $textType,
        fullName $textType,
        email $textType,
        phone $textType,
        password $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE boothbook (
        bookid INTEGER PRIMARY KEY AUTOINCREMENT,
        userid INTEGER NOT NULL,
        packageName TEXT NOT NULL,
        packagePrice REAL NOT NULL,
        bookDateTime TEXT NOT NULL,
        additionalItems TEXT,
        FOREIGN KEY (userid) REFERENCES users (id)
      )
    ''');
  }

  // check if username exists
  Future<bool> usernameExists(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // register user
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  // get user by username for login
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // get user by id
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // retrieve user information
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  // update user information
  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await instance.database;

    return db.update('users', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  // insert booking
  Future<int> insertBooking(Map<String, dynamic> booking) async {
    final db = await instance.database;
    return await db.insert('boothbook', booking);
  }

  // get user booking
  Future<List<Map<String, dynamic>>> getUserBookings(int userId) async {
    final db = await instance.database;
    return await db.query(
      'boothbook',
      where: 'userid = ?',
      whereArgs: [userId],
      orderBy: 'bookDateTime DESC',
    );
  }

  // update user booking
  Future<int> updateBooking(Map<String, dynamic> booking) async {
    final db = await database;
    return await db.update(
      'boothbook',
      booking,
      where: 'bookid = ?',
      whereArgs: [booking['bookid']],
    );
  }

  // close db
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // delete database
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'booth.db');

    // close existing connection if open
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await deleteDatabase(path);
    log('booth.db has been deleted.');
  }
}
