import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SQLhelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""create table Book
    (id integer Primary key autoincrement not null,
    title text,
    author text,
    description text,
    createdAT TImeStamp not null default Current_timestamp)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'library.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<int> insertItem(
      String title, String author, String description) async {
    final db = await SQLhelper.db();
    final data = {'title': title, 'author': author, 'description': description};
    final id = await db.insert('Book', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLhelper.db();
    return db.query('Book', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItemByid(int id) async {
    final db = await SQLhelper.db();
    return db.query('Book', where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String author, String description) async {
    final db = await SQLhelper.db();
    final data = {
      'title': title,
      'author': author,
      'description': description,
      'createdAT': DateTime.now().toString()
    };

    final result =
        await db.update('Book', data, where: "id=?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLhelper.db();
    try {
      await db.delete('Book', where: "id=?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting the item: $err");
    }
  }
}
