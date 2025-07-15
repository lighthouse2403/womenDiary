import 'package:baby_diary/database/data_handler.dart';
import 'package:baby_diary/diary/diary_model.dart';
import 'package:baby_diary/mother_action/new_mother_action/other/other_model.dart';
import 'package:baby_diary/mother_action/new_mother_action/pumping_breast_milk/milking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class MotherDatabase {
  /// Actions for mother
  static String breastMilkPumpingTable  = 'milkingTable';
  static String otherTable    = 'otherTable';
  static String diaryTable    = 'diariesTable';

  static Future<void> createMotherTables(sql.Database database) async {
    /// Index of the baby
    await database.execute("CREATE TABLE $breastMilkPumpingTable(id TEXT PRIMARY KEY, babyId TEXT, leftQuantity INTEGER, rightQuantity INTEGER, time INTEGER, createdTime INTEGER, updatedTime INTEGER, note TEXT, duration INTEGER, url TEXT, date INTEGER, date INTEGER)");
    await database.execute("CREATE TABLE $otherTable(id TEXT PRIMARY KEY, babyId TEXT, quantity INTEGER, unit TEXT, time INTEGER, createdTime INTEGER, updatedTime INTEGER, note TEXT, duration INTEGER, url TEXT, date INTEGER)");
    await database.execute("CREATE TABLE $diaryTable(id TEXT PRIMARY KEY, content TEXT, time INTEGER, createdTime INTEGER, updatedTime INTEGER, mediaUrl TEXT, date INTEGER)");
  }

  ///------------------------------ DIARIES ------------------------------------
  static Future<void> insertDiary(DiaryModel diary) async {
    final db = await DatabaseHandler.db(diaryTable);
    await db.insert(
      diaryTable,
      diary.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<DiaryModel> getDiary(String diaryId) async {
    final db = await DatabaseHandler.db(diaryTable);
    final List<Map<String, dynamic>> maps = await db.query(diaryTable, where: 'id = ?', whereArgs: [diaryId]);
    return DiaryModel.fromDatabase(maps.first);
  }

  static Future<List<DiaryModel>> getDiaries() async {
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
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
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

  static Future<void> deleteAllDiary(String diaryId) async {
    final db = await DatabaseHandler.db(diaryTable);
    try {
      await db.delete(
          diaryTable);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  /// ----------------------------- BreastMilkPumping --------------------------
  static Future<void> insertBreastMilkPumping(PumpingBreastMilkModel breastMilk) async {
    final db = await DatabaseHandler.db(breastMilkPumpingTable);
    await db.insert(
      breastMilkPumpingTable,
      breastMilk.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<PumpingBreastMilkModel> getBreastMilkPumpingById(String id) async {
    final db = await DatabaseHandler.db(breastMilkPumpingTable);
    final List<Map<String, dynamic>> maps = await db.query(breastMilkPumpingTable, where: 'id = ?', whereArgs: [id]);
    return PumpingBreastMilkModel.fromDatabase(maps.first);
  }

  static Future<List<PumpingBreastMilkModel>> getAllBreastMilkPumping() async {
    final db = await DatabaseHandler.db(breastMilkPumpingTable);
    final List<Map<String, dynamic>> list = await db.query(breastMilkPumpingTable);
    return list.map((e) => PumpingBreastMilkModel.fromDatabase(e)).toList();
  }

  static Future<List<PumpingBreastMilkModel>> getBreastMilkPumpingByDate(int date) async {
    final db = await DatabaseHandler.db(breastMilkPumpingTable);
    final List<Map<String, dynamic>> list = await db.query(breastMilkPumpingTable, where: 'date = ?', whereArgs: [date]);
    return list.map((e) => PumpingBreastMilkModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateBreastMilkPumping(PumpingBreastMilkModel milking) async {
    final db = await DatabaseHandler.db(breastMilkPumpingTable);

    await db.update(
      breastMilkPumpingTable,
      milking.toJson(),
      where: 'id = ?',
      whereArgs: [milking.id],
    );
  }

  // Delete
  static Future<void> deleteBreastMilkPumpingById(String id) async {
    final db = await DatabaseHandler.db(breastMilkPumpingTable);
    try {
      await db.delete(
          breastMilkPumpingTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllBreastMilkPumping() async {
    final db = await DatabaseHandler.db(breastMilkPumpingTable);
    try {
      await db.delete(
          breastMilkPumpingTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  /// ------------------------------ OTHERS ------------------------------------
  static Future<void> insertOther(OtherModel other) async {
    final db = await DatabaseHandler.db(otherTable);
    await db.insert(
      otherTable,
      other.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<OtherModel> getOtherById(String id) async {
    final db = await DatabaseHandler.db(otherTable);
    final List<Map<String, dynamic>> maps = await db.query(otherTable, where: 'id = ?', whereArgs: [id]);
    return OtherModel.fromDatabase(maps.first);
  }

  static Future<List<OtherModel>> getAllOther() async {
    final db = await DatabaseHandler.db(otherTable);
    final List<Map<String, dynamic>> list = await db.query(otherTable);
    return list.map((e) => OtherModel.fromDatabase(e)).toList();
  }

  static Future<List<OtherModel>> getOtherByDate(int date) async {
    final db = await DatabaseHandler.db(otherTable);
    final List<Map<String, dynamic>> list = await db.query(otherTable, where: 'date = ?', whereArgs: [date]);
    return list.map((e) => OtherModel.fromDatabase(e)).toList();
  }

  // Update an item by id
  static Future<void> updateOther(OtherModel milking) async {
    final db = await DatabaseHandler.db(otherTable);

    await db.update(
      otherTable,
      milking.toJson(),
      where: 'id = ?',
      whereArgs: [milking.id],
    );
  }

  // Delete
  static Future<void> deleteOtherById(String id) async {
    final db = await DatabaseHandler.db(otherTable);
    try {
      await db.delete(
          otherTable,
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deleteAllOther() async {
    final db = await DatabaseHandler.db(otherTable);
    try {
      await db.delete(
          otherTable
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
