import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'user_database.db';
  static const String tableName = 'users';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final appDirectory =
        await getExternalStorageDirectory(); // Change to external storage directory
    final path = join(appDirectory!.path, dbName);

    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load("assets/$dbName");
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return db.insert(tableName, user);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    final db = await database;
    return db.query(tableName);
  }

  Future closeDatabase() async {
    final db = await database;
    db.close();
  }
}


// import 'package:sqflite/sqflite.dart';
// import 'package:flutter/services.dart'; // Import this package
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class DatabaseHelper {
//   static Database? _database;
//   static const String dbName = 'user_database.db';
//   static const String tableName = 'users';

//   static final DatabaseHelper _instance = DatabaseHelper._internal();

//   factory DatabaseHelper() {
//     return _instance;
//   }

//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     // Specify the path to the main folder of the app
//     final appDirectory = await getApplicationDocumentsDirectory();
//     final mainFolder = appDirectory.parent; // Access the main folder
//     final path = join(mainFolder.path, dbName);

//     // Copy the database file from assets if it doesn't exist
//     if (!await databaseExists(path)) {
//       ByteData data = await rootBundle.load("assets/$dbName");
//       List<int> bytes = data.buffer.asUint8List();
//       await File(path).writeAsBytes(bytes, flush: true);
//     }

//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE $tableName(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT,
//             email TEXT,
//             password TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> insertUser(Map<String, dynamic> user) async {
//     final db = await database;
//     return db.insert(tableName, user);
//   }

//   Future<List<Map<String, dynamic>>> queryAllUsers() async {
//     final db = await database;
//     return db.query(tableName);
//   }

//   // Add more methods as needed for CRUD operations

//   Future closeDatabase() async {
//     final db = await database;
//     db.close();
//   }
// }


// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static Database? _database;
//   static const String dbName = 'user_database.db';
//   static const String tableName = 'users';

//   static final DatabaseHelper _instance = DatabaseHelper._internal();

//   factory DatabaseHelper() {
//     return _instance;
//   }

//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     final documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, dbName);
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE $tableName(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT,
//             email TEXT,
//             password TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> insertUser(Map<String, dynamic> user) async {
//     final db = await database;
//     return db.insert(tableName, user);
//   }

//   Future<List<Map<String, dynamic>>> queryAllUsers() async {
//     final db = await database;
//     return db.query(tableName);
//   }

//   // Add more methods as needed for CRUD operations

//   Future closeDatabase() async {
//     final db = await database;
//     db.close();
//   }
// }


// // import 'package:sqflite/sqflite.dart';
// // import 'package:path/path.dart';

// // class DatabaseHelper {
// //   static Database? _database;
// //   static const String dbName = 'user_database.db';
// //   static const String tableName = 'users';

// //   static final DatabaseHelper _instance = DatabaseHelper._internal();

// //   factory DatabaseHelper() {
// //     return _instance;
// //   }

// //   DatabaseHelper._internal();

// //   Future<Database> get database async {
// //     if (_database != null) return _database!;

// //     _database = await initDatabase();
// //     return _database!;
// //   }

// //   Future<Database> initDatabase() async {
// //     final path = join(await getDatabasesPath(), dbName);
// //     return openDatabase(
// //       path,
// //       version: 1,
// //       onCreate: (db, version) {
// //         return db.execute('''
// //           CREATE TABLE $tableName(
// //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// //             name TEXT,
// //             email TEXT,
// //             password TEXT
// //           )
// //         ''');
// //       },
// //     );
// //   }

// //   Future<int> insertUser(Map<String, dynamic> user) async {
// //     final db = await database;
// //     return db.insert(tableName, user);
// //   }
// // }
