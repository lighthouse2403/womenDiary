import 'package:women_diary/diary/diary_model.dart';
import 'package:women_diary/period/period_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHandler {
  static String databasePath = 'womenDiary.db';
  static String periodTable = 'periodTable';
  static String scheduleTable = 'scheduleTable';
  static String diaryTable = 'diaryTable';

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
    await database.execute("CREATE TABLE $periodTable(id TEXT PRIMARY KEY, startTime INTEGER, endTime INTEGER, createdTime INTEGER, updatedTime INTEGER)");
    await database.execute("CREATE TABLE $scheduleTable(id TEXT PRIMARY KEY, time INTEGER, content TEXT, createdTime INTEGER, updatedTime INTEGER, alarm INTEGER)");
    await database.execute("CREATE TABLE $diaryTable(id TEXT PRIMARY KEY, time INTEGER, content TEXT, createdTime INTEGER, updatedTime INTEGER, url TEXT)");
  }

  static Future<void> clearData() async {
    sql.deleteDatabase(DatabaseHandler.databasePath);
  }

  ///----------------------- RED DATE ------------------------------------------
  static Future<void> insertPeriod(PeriodModel date) async {
    final db = await DatabaseHandler.db(periodTable);
    await db.insert(
      periodTable,
      date.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<PeriodModel> gedPeriod(String id) async {
    final db = await DatabaseHandler.db(periodTable);
    final List<Map<String, dynamic>> maps = await db.query(periodTable, where: 'id = ?', whereArgs: [id]);
    return PeriodModel.fromDatabase(maps.first);
  }

  static Future<List<PeriodModel>> getAllPeriod() async {
    final db = await DatabaseHandler.db(periodTable);
    final List<Map<String, dynamic>> list = await db.query(periodTable);
    return list.map((e) => PeriodModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updatePeriod(PeriodModel date) async {
    final db = await DatabaseHandler.db(periodTable);

    await db.update(
      periodTable,
      date.toJson(),
      where: 'id = ?',
      whereArgs: [date.id],
    );
  }

  // Delete
  static Future<void> deletePeriod(String id) async {
    final db = await DatabaseHandler.db(periodTable);
    try {
      await db.delete(
          periodTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllPeriod() async {
    final db = await DatabaseHandler.db(periodTable);
    try {
      await db.delete(
          periodTable
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

  ///----------------------- BABIES --------------------------------------------
  static Future<void> insertDiary(DiaryModel diary) async {
    final db = await DatabaseHandler.db(diaryTable);
    await db.insert(
      diaryTable,
      diary.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<DiaryModel> gedDiary(String id) async {
    final db = await DatabaseHandler.db(diaryTable);
    final List<Map<String, dynamic>> maps = await db.query(diaryTable, where: 'id = ?', whereArgs: [id]);
    return DiaryModel.fromDatabase(maps.first);
  }

  static Future<List<DiaryModel>> getAllDiary() async {
    final db = await DatabaseHandler.db(diaryTable);
    final List<Map<String, dynamic>> list = await db.query(diaryTable);
    return list.map((e) => DiaryModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateDiary(DiaryModel diary) async {
    final db = await DatabaseHandler.db(diaryTable);

    await db.update(
      diaryTable,
      diary.toJson(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }

  // Delete
  static Future<void> deleteDiary(String id) async {
    final db = await DatabaseHandler.db(diaryTable);
    try {
      await db.delete(
          diaryTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllDiary() async {
    final db = await DatabaseHandler.db(diaryTable);
    try {
      await db.delete(
          diaryTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}