import 'package:flutter/cupertino.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHandler {
  static String databasePath    = 'womenDiary.db';
  static String cycleTable      = 'cycleTable';
  static String scheduleTable   = 'scheduleTable';
  static String diaryTable      = 'diaryTable';
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
    await database.execute("CREATE TABLE $cycleTable(id TEXT PRIMARY KEY, cycleStartTime INTEGER, cycleEndTime INTEGER, menstruationEndTime INTEGER, note TEXT, createdTime INTEGER, updatedTime INTEGER)");
    await database.execute("CREATE TABLE $scheduleTable(id TEXT PRIMARY KEY, time INTEGER, title TEXT, note TEXT, createdTime INTEGER, updatedTime INTEGER, isReminderOn INTEGER)");
    await database.execute("CREATE TABLE $userActionTable(id TEXT PRIMARY KEY, type INTEGER, time INTEGER, emoji TEXT, note TEXT, title TEXT, createdTime INTEGER, updatedTime INTEGER)");
  }

  static Future<void> clearData() async {
    sql.deleteDatabase(DatabaseHandler.databasePath);
  }

  ///----------------------- Menstruation PERIOD -------------------------------
  static Future<void> insertCycle(CycleModel menstruation) async {
    final db = await DatabaseHandler.db(cycleTable);
    await db.insert(
      cycleTable,
      menstruation.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<CycleModel> getCycle(int cycleStartTime) async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> maps = await db.query(cycleTable, where: 'cycleStartTime = ?', whereArgs: [cycleStartTime]);
    return CycleModel.fromDatabase(maps.first);
  }

  static Future<List<CycleModel>> getAllCycle() async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> list = await db.query(cycleTable);
    List<CycleModel> allCycle = list.map((e) => CycleModel.fromDatabase(e)).toList();
    allCycle.sort((a, b) => a.cycleStartTime.compareTo(b.cycleStartTime));
    return allCycle;
  }

  static Future<void> updateCycle(CycleModel allCycle) async {
    final db = await DatabaseHandler.db(cycleTable);

    await db.update(
      cycleTable,
      allCycle.toJson(),
      where: 'cycleStartTime = ?',
      whereArgs: [allCycle.cycleStartTime],
    );
  }

  // Delete
  static Future<void> deleteCycle(int cycleStartTime) async {
    final db = await DatabaseHandler.db(cycleTable);
    try {
      await db.delete(
          cycleTable,
          where: 'cycleStartTime = ?',
          whereArgs: [cycleStartTime]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllCycle() async {
    final db = await DatabaseHandler.db(cycleTable);
    try {
      await db.delete(
          cycleTable
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

  static Future<List<ScheduleModel>> getSchedules({int? startTime, int? endTime}) async {
    final db = await DatabaseHandler.db(scheduleTable);

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
      scheduleTable,
      where: whereString,
      whereArgs: whereArgs,
      orderBy: 'time DESC',
    );

    print(list);
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