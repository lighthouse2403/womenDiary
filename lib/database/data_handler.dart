import 'package:flutter/cupertino.dart';
import 'package:women_diary/actions_history/action_detail/new_action.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
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
  static String userActionTable = 'userActionTable';

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
    await database.execute("CREATE TABLE $userActionTable(id TEXT PRIMARY KEY, type INTEGER, time INTEGER, emoji TEXT, note TEXT, title TEXT, createdTime INTEGER, updatedTime INTEGER)");
  }

  static Future<void> clearData() async {
    sql.deleteDatabase(DatabaseHandler.databasePath);
  }

  ///----------------------- Menstruation PERIOD -------------------------------
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
    List<MenstruationModel> allMenstruation = list.map((e) => MenstruationModel.fromDatabase(e)).toList();
    allMenstruation.sort((a, b) => a.startTime.compareTo(b.startTime));
    return allMenstruation;
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

  static Future<UserAction> getAction(String id) async {
    final db = await DatabaseHandler.db(userActionTable);
    final List<Map<String, dynamic>> maps = await db.query(userActionTable, where: 'id = ?', whereArgs: [id]);
    return UserAction.fromDatabase(maps.first);
  }

  static Future<List<ScheduleModel>> getSchedule({int? startTime, int? endTime}) async {
    final db = await DatabaseHandler.db(userActionTable);

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (startTime != null) {
      whereClauses.add('time >= ?');
      whereArgs.add(startTime);
    }

    if (endTime != null) {
      whereClauses.add('time <= ?');
      whereArgs.add(endTime);
    }

    final whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    final List<Map<String, dynamic>> list = await db.query(
      userActionTable,
      where: whereString,
      whereArgs: whereArgs,
      orderBy: 'time DESC',
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

  ///----------------------- DIARIES -------------------------------------------
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

  ///---------------------------- USER ACTION ----------------------------------
  static Future<void> insertNewAction(UserAction action) async {
    final db = await DatabaseHandler.db(userActionTable);
    await db.insert(
      userActionTable,
      action.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<UserAction> getAction(String id) async {
    final db = await DatabaseHandler.db(userActionTable);
    final List<Map<String, dynamic>> maps = await db.query(userActionTable, where: 'id = ?', whereArgs: [id]);
    return UserAction.fromDatabase(maps.first);
  }

  static Future<List<UserAction>> getActions({int? startTime, int? endTime, ActionType? type}) async {
    final db = await DatabaseHandler.db(userActionTable);

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (startTime != null) {
      whereClauses.add('time >= ?');
      whereArgs.add(startTime);
    }

    if (endTime != null) {
      whereClauses.add('time <= ?');
      whereArgs.add(endTime);
    }

    if (type != null) {
      whereClauses.add('type = ?');
      whereArgs.add(type.index);
    }


    final whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    final List<Map<String, dynamic>> list = await db.query(
      userActionTable,
      where: whereString,
      whereArgs: whereArgs,
      orderBy: 'time DESC',
    );
    print('list ${list}');

    return list.map((e) => UserAction.fromDatabase(e)).toList();
  }

  static Future<List<UserAction>> getAllAction() async {
    final db = await DatabaseHandler.db(userActionTable);
    final List<Map<String, dynamic>> list = await db.query(userActionTable);
    return list.map((e) => UserAction.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateAction(UserAction action) async {
    final db = await DatabaseHandler.db(userActionTable);

    await db.update(
      userActionTable,
      action.toJson(),
      where: 'id = ?',
      whereArgs: [action.id],
    );
  }

  // Delete
  static Future<void> deleteAction(String id) async {
    final db = await DatabaseHandler.db(userActionTable);
    try {
      await db.delete(
          userActionTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllAction() async {
    final db = await DatabaseHandler.db(userActionTable);
    try {
      await db.delete(
          userActionTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}