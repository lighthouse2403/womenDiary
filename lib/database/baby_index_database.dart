import 'package:baby_diary/baby_index/index_model.dart';
import 'package:baby_diary/database/data_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class BabyIndexDatabase {
  /// Index of the baby
  static String babyIndexTable = 'babyIndexTable';

  static Future<void> createBabyIndexTables(sql.Database database) async {
    await database.execute("CREATE TABLE $babyIndexTable(id TEXT PRIMARY KEY, babyId TEXT, value INTEGER, type INTEGER, note TEXT, time INTEGER, createdTime INTEGER, updatedTime INTEGER, url TEXT)");
  }

  static Future<void> insertIndex(IndexModel index) async {
    final db = await DatabaseHandler.db(babyIndexTable);
    await db.insert(
      babyIndexTable,
      index.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<IndexModel> getIndexById(String id) async {
    final db = await DatabaseHandler.db(babyIndexTable);
    final List<Map<String, dynamic>> maps = await db.query(babyIndexTable, where: 'id = ?', whereArgs: [id]);
    return IndexModel.fromDatabase(maps.first);
  }

  static Future<List<IndexModel>> getAllIndex() async {
    final db = await DatabaseHandler.db(babyIndexTable);
    final List<Map<String, dynamic>> list = await db.query(babyIndexTable);
    return list.map((e) => IndexModel.fromDatabase(e)).toList();
  }

  static Future<List<IndexModel>> getIndexOnDate(int date) async {
    final db = await DatabaseHandler.db(babyIndexTable);
    final List<Map<String, dynamic>> list = await db.query(babyIndexTable, where: 'time = ?', whereArgs: [date]);
    return list.map((e) => IndexModel.fromDatabase(e)).toList();
  }

  static Future<void> updateIndex(IndexModel index) async {
    final db = await DatabaseHandler.db(babyIndexTable);

    await db.update(
      babyIndexTable,
      index.toJson(),
      where: 'id = ?',
      whereArgs: [index.id],
    );
  }

  // Delete
  static Future<void> deleteIndex(String id) async {
    final db = await DatabaseHandler.db(babyIndexTable);
    try {
      await db.delete(
          babyIndexTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllIndex() async {
    final db = await DatabaseHandler.db(babyIndexTable);
    try {
      await db.delete(
          babyIndexTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
