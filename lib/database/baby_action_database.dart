import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/database/data_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class BabyActionsDatabase {
  /// The actions of baby
  static String babyActionTable           = 'babyActionTable';

  static Future<void> createBabyActionsTables(sql.Database database) async {
    /// Actions for baby
    await database.execute("CREATE TABLE $babyActionTable(id TEXT PRIMARY KEY, babyId TEXT, quantity INTEGER, unit TEXT, startTime INTEGER, stopTime INTEGER, createdTime INTEGER, updatedTime INTEGER, note TEXT, url TEXT)");
  }

  /// -------------------- Handle Eating ------------------------------------
  static Future<void> insert(BabyActionModel babyAction) async {
    final db = await DatabaseHandler.db(babyActionTable);
    await db.insert(
      babyActionTable,
      babyAction.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<BabyActionModel> getActionById(String id) async {
    final db = await DatabaseHandler.db(babyActionTable);
    final List<Map<String, dynamic>> maps = await db.query(babyActionTable, where: 'id = ?', whereArgs: [id]);
    return BabyActionModel.fromDatabase(maps.first);
  }

  static Future<List<BabyActionModel>> getAllAction() async {
    final db = await DatabaseHandler.db(babyActionTable);
    final List<Map<String, dynamic>> list = await db.query(babyActionTable);
    return list.map((e) => BabyActionModel.fromDatabase(e)).toList();
  }

  static Future<List<BabyActionModel>> getActionByType(ActionType type) async {
    final db = await DatabaseHandler.db(babyActionTable);
    final List<Map<String, dynamic>> list = await db.query(babyActionTable, where: 'type = ?', whereArgs: [type.value]);
    return list.map((e) => BabyActionModel.fromDatabase(e)).toList();
  }

  static Future<List<BabyActionModel>> getActionsOnDate(DateTime day) async {
    final db = await DatabaseHandler.db(babyActionTable);

    final startOfDay = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> list = await db.query(
      babyActionTable,
      where: '''
      startTime <= ? AND 
      (stopTime IS NULL OR stopTime >= ?)
    ''',
      whereArgs: [endOfDay, startOfDay],
    );

    return list.map((e) => BabyActionModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateAction(BabyActionModel action) async {
    final db = await DatabaseHandler.db(babyActionTable);

    await db.update(
      babyActionTable,
      action.toJson(),
      where: 'id = ?',
      whereArgs: [action.id],
    );
  }

  // Delete
  static Future<void> deleteActioon(String id) async {
    final db = await DatabaseHandler.db(babyActionTable);
    try {
      await db.delete(
          babyActionTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllAction() async {
    final db = await DatabaseHandler.db(babyActionTable);
    try {
      await db.delete(
          babyActionTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
