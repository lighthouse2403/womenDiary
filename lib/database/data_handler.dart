import 'package:women_diary/diary/diary_model.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHandler {
  static String databasePath = 'womenDiary.db';
  static String menstruationTable = 'menstruationTable';
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
    await database.execute("CREATE TABLE $menstruationTable(startTime INTEGER, endTime INTEGER, note TEXT, createdTime INTEGER, updatedTime INTEGER)");
    await database.execute("CREATE TABLE $scheduleTable(id TEXT PRIMARY KEY, time INTEGER, content TEXT, createdTime INTEGER, updatedTime INTEGER, alarm INTEGER)");
    await database.execute("CREATE TABLE $diaryTable(id TEXT PRIMARY KEY, time INTEGER, content TEXT, createdTime INTEGER, updatedTime INTEGER, url TEXT)");
  }

  static Future<void> clearData() async {
    sql.deleteDatabase(DatabaseHandler.databasePath);
  }

  ///----------------------- RED DATE ------------------------------------------
  static Future<void> insertMenstruation(MenstruationModel menstruation) async {
    final db = await DatabaseHandler.db(menstruationTable);
    await db.insert(
      menstruationTable,
      menstruation.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<MenstruationModel> getMenstruation(int startTime, int endTime) async {
    final db = await DatabaseHandler.db(menstruationTable);
    final List<Map<String, dynamic>> maps = await db.query(menstruationTable, where: 'startTime = ? AND endTime = ?', whereArgs: [startTime, endTime]);
    return MenstruationModel.fromDatabase(maps.first);
  }

  static Future<List<MenstruationModel>> getAllMenstruation() async {
    final db = await DatabaseHandler.db(menstruationTable);
    final List<Map<String, dynamic>> list = await db.query(menstruationTable);
    return list.map((e) => MenstruationModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateMenstruation(MenstruationModel menstruation) async {
    final db = await DatabaseHandler.db(menstruationTable);

    await db.update(
      menstruationTable,
      menstruation.toJson(),
      where: 'startTime = ? AND endTime = ?',
      whereArgs: [menstruation.startTime, menstruation.endTime],
    );
  }

  // Delete
  static Future<void> deleteMenstruation(int startTime, int endTime) async {
    final db = await DatabaseHandler.db(menstruationTable);
    try {
      await db.delete(
          menstruationTable,
          where: 'startTime = ? AND endTime = ?',
          whereArgs: [startTime, endTime]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllMenstruation() async {
    final db = await DatabaseHandler.db(menstruationTable);
    try {
      await db.delete(
          menstruationTable
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