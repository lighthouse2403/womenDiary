import 'package:flutter/cupertino.dart' hide Action;
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHandler {
  static String databasePath    = 'womenDiary.db';
  static String cycleTable      = 'cycleTable';
  static String scheduleTable   = 'scheduleTable';
  static String actionTable     = 'actionTable';
  static String actionTypeTable = 'actionTypeTable';

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
    await database.execute("CREATE TABLE $actionTable(id TEXT PRIMARY KEY, typeId TEXT, time INTEGER, cycleId TEXT, emoji TEXT, note TEXT, title TEXT, createdTime INTEGER, updatedTime INTEGER)");
    await database.execute("CREATE TABLE $actionTypeTable(id TEXT PRIMARY KEY, title TEXT, emoji TEXT, createdTime INTEGER, updatedTime INTEGER)");
  }

  static Future<void> clearData() async {
    sql.deleteDatabase(DatabaseHandler.databasePath);
  }

  ///----------------------- Menstruation PERIOD -------------------------------
  static Future<void> insertCycle(CycleModel cycle) async {
    final db = await DatabaseHandler.db(cycleTable);
    await db.insert(
      cycleTable,
      cycle.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<CycleModel> getCycle(String id) async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> maps = await db.query(cycleTable, where: 'id = ?', whereArgs: [id]);
    return CycleModel.fromDatabase(maps.first);
  }

  static Future<List<CycleModel>> getAllCycle() async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> list = await db.query(cycleTable);
    List<CycleModel> allCycle = list.map((e) => CycleModel.fromDatabase(e)).toList();
    allCycle.sort((a, b) => b.cycleStartTime.compareTo(a.cycleStartTime));
    return allCycle;
  }

  static Future<CycleModel> getLongestCycle() async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> list = await db.query(cycleTable);
    List<CycleModel> allCycle = list.map((e) => CycleModel.fromDatabase(e)).toList();
    int cycleDefaultLength = await LocalStorageService.getCycleLength();
    int menstruationDefaultLength = await LocalStorageService.getCycleLength();

    if (allCycle.isEmpty) {
      return CycleModel.init(
          DateTime.now(),
          DateTime.now().add(Duration(days: cycleDefaultLength)),
          DateTime.now().add(Duration(days: menstruationDefaultLength))
      );
    };

    final now = DateTime.now();

    // Chỉ lấy chu kỳ đã xảy ra (start <= now)
    final pastCycles = allCycle.where(
          (e) => e.cycleStartTime.isBefore(now) || e.cycleStartTime.isAtSameMomentAs(now),
    ).toList();

    if (pastCycles.isEmpty) {
      return CycleModel.init(
          DateTime.now(),
          DateTime.now().add(Duration(days: cycleDefaultLength)),
          DateTime.now().add(Duration(days: menstruationDefaultLength))
      );
    };

    // Tìm chu kỳ dài nhất
    pastCycles.sort((a, b) {
      final lenA = a.cycleEndTime.difference(a.cycleStartTime).inDays;
      final lenB = b.cycleEndTime.difference(b.cycleStartTime).inDays;
      return lenB.compareTo(lenA); // sắp xếp giảm dần theo độ dài
    });

    return pastCycles.first;
  }

  static Future<CycleModel> getShortestCycle() async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> list = await db.query(cycleTable);
    List<CycleModel> allCycle = list.map((e) => CycleModel.fromDatabase(e)).toList();
    int cycleDefaultLength = await LocalStorageService.getCycleLength();
    int menstruationDefaultLength = await LocalStorageService.getCycleLength();

    if (allCycle.isEmpty) {
      return CycleModel.init(
          DateTime.now(),
          DateTime.now().add(Duration(days: cycleDefaultLength)),
          DateTime.now().add(Duration(days: menstruationDefaultLength))
      );
    };
    final now = DateTime.now();

    // Chỉ lấy chu kỳ đã xảy ra
    final pastCycles = allCycle.where(
          (e) => e.cycleStartTime.isBefore(now) || e.cycleStartTime.isAtSameMomentAs(now),
    ).toList();


    if (pastCycles.isEmpty) {
      return CycleModel.init(
          DateTime.now(),
          DateTime.now().add(Duration(days: cycleDefaultLength)),
          DateTime.now().add(Duration(days: menstruationDefaultLength))
      );
    };

    // Tìm chu kỳ ngắn nhất
    pastCycles.sort((a, b) {
      final lenA = a.cycleEndTime.difference(a.cycleStartTime).inDays;
      final lenB = b.cycleEndTime.difference(b.cycleStartTime).inDays;
      return lenA.compareTo(lenB); // sắp xếp tăng dần theo độ dài
    });

    return pastCycles.first;
  }

  static Future<CycleModel?> getCycleByDate(DateTime actionDate) async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> list = await db.query(cycleTable);
    List<CycleModel> allCycle = list.map((e) => CycleModel.fromDatabase(e)).toList();

    print('length: ${allCycle.length}');
    if (allCycle.isEmpty) return null;

    // Tìm chu kỳ chứa actionDate
    for (final cycle in allCycle) {
      print('${cycle.cycleStartTime} -- ${cycle.cycleEndTime}');
      print('$actionDate');

      if ((actionDate.isAtSameMomentAs(cycle.cycleStartTime) ||
          actionDate.isAfter(cycle.cycleStartTime)) &&
          (actionDate.isAtSameMomentAs(cycle.cycleEndTime) ||
              actionDate.isBefore(cycle.cycleEndTime))) {

        return cycle;
      }
    }
    return null; // nếu không tìm thấy chu kỳ nào chứa ngày này
  }

  static Future<int> getAverageCycleLength() async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> list = await db.query(cycleTable);
    List<CycleModel> allCycle = list.map((e) => CycleModel.fromDatabase(e)).toList();

    if (allCycle.isEmpty) return 30;

    final now = DateTime.now();

    // Chỉ lấy các cycle trong quá khứ hoặc đang diễn ra
    final pastCycles = allCycle.where(
          (e) => e.cycleEndTime.isBefore(now) || e.cycleEndTime.isAtSameMomentAs(now),
    ).toList();

    if (pastCycles.isEmpty) return 30;

    // Tính độ dài chu kỳ cho từng cycle
    final lengths = pastCycles.map((e) {
      return e.cycleEndTime.difference(e.cycleStartTime).inDays + 1;
    }).toList();

    // Tính trung bình
    final avg = lengths.reduce((a, b) => a + b) / lengths.length;
    return avg.floor();
  }

  static Future<CycleModel> getLastCycle() async {
    final db = await DatabaseHandler.db(cycleTable);
    final List<Map<String, dynamic>> list = await db.query(cycleTable);
    List<CycleModel> allCycle = list.map((e) => CycleModel.fromDatabase(e)).toList();

    int cycleDefaultLength = await LocalStorageService.getCycleLength();
    int menstruationDefaultLength = await LocalStorageService.getCycleLength();
    if (allCycle.isEmpty) {
      return CycleModel.init(
          DateTime.now(),
          DateTime.now().add(Duration(days: cycleDefaultLength)),
          DateTime.now().add(Duration(days: menstruationDefaultLength))
      );
    }

    final now = DateTime.now();

    final pastCycles = allCycle.where((e) => e.cycleStartTime.isBefore(now) ||
        e.cycleStartTime.isAtSameMomentAs(now)).toList();
    if (pastCycles.isEmpty) {
      return CycleModel.init(
          DateTime.now(),
          DateTime.now().add(Duration(days: 30)),
          DateTime.now().add(Duration(days: 6))
      );
    }

    pastCycles.sort((a, b) => b.cycleStartTime.compareTo(a.cycleStartTime));

    return pastCycles.first;
  }

  static Future<void> updateCycle(CycleModel existCycle) async {
    final db = await DatabaseHandler.db(cycleTable);

    await db.update(
      cycleTable,
      existCycle.toJson(),
      where: 'id = ?',
      whereArgs: [existCycle.id],
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

  static Future<void> deleteCycleById(String id) async {
    final db = await DatabaseHandler.db(cycleTable);
    try {
      await db.delete(
          cycleTable,
          where: 'id = ?',
          whereArgs: [id]);
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
    List<ScheduleModel> schedules = list.map((e) => ScheduleModel.fromDatabase(e)).toList();
    schedules.sort((a, b) => b.time.compareTo(a.time));
    return schedules;
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
  static Future<void> insertNewAction(ActionModel action) async {
    final db = await DatabaseHandler.db(actionTable);
    await db.insert(
      actionTable,
      action.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<ActionModel> getAction(String id) async {
    final db = await DatabaseHandler.db(actionTable);
    final List<Map<String, dynamic>> maps = await db.query(actionTable, where: 'id = ?', whereArgs: [id]);
    return ActionModel.fromDatabase(maps.first);
  }

  static Future<List<ActionModel>> getActionsByType({String? typeId}) async {
    final db = await DatabaseHandler.db(actionTable);

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];
    //
    // if (startTime != null) {
    //   whereClauses.add('time >= ?');
    //   whereArgs.add(startTime);
    // }
    //
    // if (endTime != null) {
    //   whereClauses.add('time <= ?');
    //   whereArgs.add(endTime);
    // }

    if (typeId != null) {
      whereClauses.add('typeId = ?');
      whereArgs.add(typeId);
    }


    final whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    final List<Map<String, dynamic>> list = await db.query(
      actionTable,
      where: whereString,
      whereArgs: whereArgs,
      orderBy: 'time DESC',
    );
    print('list ${list}');

    return list.map((e) => ActionModel.fromDatabase(e)).toList();
  }

  static Future<List<ActionModel>> getActionsByCycle(String cycleId) async {
    final db = await DatabaseHandler.db(actionTable);

    final List<Map<String, dynamic>> list = await db.query(
      actionTable,
      where: "cycleId = ?",
      whereArgs: [cycleId],
      orderBy: 'time DESC',
    );

    return list.map((e) => ActionModel.fromDatabase(e)).toList();
  }

  static Future<List<ActionModel>> getAllAction() async {
    final db = await DatabaseHandler.db(actionTable);
    final List<Map<String, dynamic>> list = await db.query(actionTable);
    return list.map((e) => ActionModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateAction(ActionModel action) async {
    final db = await DatabaseHandler.db(actionTable);

    await db.update(
      actionTable,
      action.toJson(),
      where: 'id = ?',
      whereArgs: [action.id],
    );
  }

  // Delete
  static Future<void> deleteAction(String id) async {
    final db = await DatabaseHandler.db(actionTable);
    try {
      await db.delete(
          actionTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteActionByType(String typeId) async {
    final db = await DatabaseHandler.db(actionTable);
    try {
      await db.delete(
          actionTable,
          where: "typeId = ?",
          whereArgs: [typeId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllAction() async {
    final db = await DatabaseHandler.db(actionTable);
    try {
      await db.delete(
          actionTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  ///---------------------------- ACTION TYPE ----------------------------------
  static Future<void> insertNewActionType(ActionTypeModel actionType) async {
    final db = await DatabaseHandler.db(actionTypeTable);
    await db.insert(
      actionTypeTable,
      actionType.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<ActionTypeModel> getActionType(String id) async {
    final db = await DatabaseHandler.db(actionTypeTable);
    final List<Map<String, dynamic>> maps = await db.query(actionTypeTable, where: 'id = ?', whereArgs: [id]);
    return ActionTypeModel.fromDatabase(maps.first);
  }

  static Future<List<ActionTypeModel>> getAllActionType() async {
    final db = await DatabaseHandler.db(actionTypeTable);
    final List<Map<String, dynamic>> list = await db.query(actionTypeTable);
    return list.map((e) => ActionTypeModel.fromDatabase(e)).toList();
  }

  static Future<void> updateActionType(ActionTypeModel actionType) async {
    final db = await DatabaseHandler.db(actionTypeTable);

    await db.update(
      actionTypeTable,
      actionType.toJson(),
      where: 'id = ?',
      whereArgs: [actionType.id],
    );
  }

  // Delete
  static Future<void> deleteActionType(String id) async {
    final db = await DatabaseHandler.db(actionTypeTable);
    try {
      await db.delete(
          actionTypeTable,
          where: "id = ?",
          whereArgs: [id]);
      DatabaseHandler.deleteActionByType(id);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
