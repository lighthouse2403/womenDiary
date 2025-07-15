import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/database/baby_action_database.dart';
import 'package:baby_diary/database/baby_index_database.dart';
import 'package:baby_diary/database/mother_database.dart';
import 'package:baby_diary/schedule/schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHandler {
  static String databasePath = 'babyDiary.db';
  static String babyTable = 'babiesTable';
  static String scheduleTable = 'scheduleTable';

  static Future<sql.Database> db(String tableName) async {
    return sql.openDatabase(
      DatabaseHandler.databasePath,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("CREATE TABLE $babyTable(babyId TEXT PRIMARY KEY, babyName TEXT, gender TEXT, birthDate INTEGER, createdTime INTEGER, updatedTime INTEGER, group INTEGER, selected INTEGER)");
    await database.execute("CREATE TABLE $scheduleTable(babyId TEXT PRIMARY KEY, babyId TEXT, time INTEGER, content TEXT, createdTime INTEGER, updatedTime INTEGER, alarm INTEGER)");

    /// Actions for baby
    await BabyActionsDatabase.createBabyActionsTables(database);
    await BabyIndexDatabase.createBabyIndexTables(database);
    await MotherDatabase.createMotherTables(database);
  }

  static Future<void> clearData() async {
    sql.deleteDatabase(DatabaseHandler.databasePath);
  }

  ///----------------------- BABIES --------------------------------------------
  static Future<void> insertBaby(BabyModel baby) async {
    final db = await DatabaseHandler.db(babyTable);
    await db.insert(
      babyTable,
      baby.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<BabyModel> getBaby(String id) async {
    final db = await DatabaseHandler.db(babyTable);
    final List<Map<String, dynamic>> maps = await db.query(babyTable, where: 'babyId = ?', whereArgs: [id]);
    return BabyModel.fromDatabase(maps.first);
  }

  static Future<BabyModel> getSelectedBaby() async {
    final db = await DatabaseHandler.db(babyTable);
    final List<Map<String, dynamic>> maps = await db.query(babyTable, where: 'selected = ?', whereArgs: [1]);
    return BabyModel.fromDatabase(maps.first);
  }

  static Future<List<BabyModel>> getAllBaby() async {
    final db = await DatabaseHandler.db(babyTable);
    final List<Map<String, dynamic>> list = await db.query(babyTable);
    return list.map((e) => BabyModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateBaby(BabyModel baby) async {
    final db = await DatabaseHandler.db(babyTable);

    await db.update(
      babyTable,
      baby.toJson(),
      where: 'babyId = ?',
      whereArgs: [baby.babyId],
    );
  }

  // Delete
  static Future<void> deleteBaby(String babyId) async {
    final db = await DatabaseHandler.db(babyTable);
    try {
      await db.delete(
          babyTable,
          where: "babyId = ?",
          whereArgs: [babyId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllBaby() async {
    final db = await DatabaseHandler.db(babyTable);
    try {
      await db.delete(
          babyTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  /// ----------------------------- SCHEDULE -----------------------------------
  static Future<void> insertSchedule(ScheduleModel schedule) async {
    final db = await DatabaseHandler.db(scheduleTable);
    await db.insert(
      scheduleTable,
      schedule.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<ScheduleModel> getScheduleById(String id) async {
    final db = await DatabaseHandler.db(scheduleTable);
    final List<Map<String, dynamic>> maps = await db.query(scheduleTable, where: 'id = ?', whereArgs: [id]);
    return ScheduleModel.fromDatabase(maps.first);
  }

  static Future<List<ScheduleModel>> getAllSchedule() async {
    final db = await DatabaseHandler.db(scheduleTable);
    final List<Map<String, dynamic>> list = await db.query(scheduleTable);
    return list.map((e) => ScheduleModel.fromDatabase(e)).toList();
  }

  static Future<List<ScheduleModel>> getScheduleOnDate(DateTime day) async {
    final db = await DatabaseHandler.db(scheduleTable);

    final startOfDay = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> list = await db.query(
      scheduleTable,
      where: '''
      startTime <= ? AND 
      (stopTime IS NULL OR stopTime >= ?)
    ''',
      whereArgs: [endOfDay, startOfDay],
    );

    return list.map((e) => ScheduleModel.fromDatabase(e)).toList();
  }

  static Future<void> updateSchedule(ScheduleModel action) async {
    final db = await DatabaseHandler.db(scheduleTable);

    await db.update(
      scheduleTable,
      action.toJson(),
      where: 'id = ?',
      whereArgs: [action.id],
    );
  }

  static Future<void> deleteSchedule(String id) async {
    final db = await DatabaseHandler.db(scheduleTable);
    try {
      await db.delete(
          scheduleTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllSchedule() async {
    final db = await DatabaseHandler.db(scheduleTable);
    try {
      await db.delete(
          scheduleTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}