import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/util/db/helper.dart';
import 'package:sqflite/sqflite.dart';

class DbScoutedPits {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, ScoutedPit.tableName)) return;
    await db.execute(
      "CREATE TABLE ${ScoutedPit.tableName}("
      "${ScoutedPit.uidKey} TEXT PRIMARY KEY, "
      "${ScoutedPit.scouterIdKey} TEXT NOT NULL, "
      "${ScoutedPit.localKey} INTEGER NOT NULL, "
      "${ScoutedPit.teamNumberKey} INTEGER NOT NULL, "
      "${ScoutedPit.weightKey} INTEGER NOT NULL, "
      "${ScoutedPit.widthKey} INTEGER NOT NULL, "
      "${ScoutedPit.depthKey} INTEGER NOT NULL, "
      "${ScoutedPit.startingHeightKey} INTEGER NOT NULL, "
      "${ScoutedPit.extendedHeightKey} INTEGER NOT NULL, "
      "${ScoutedPit.isKitBotKey} INTEGER NOT NULL, "
      "${ScoutedPit.drivetrainKey} INTEGER NOT NULL, "
      "${ScoutedPit.wheelTypeKey} INTEGER NOT NULL, "
      "${ScoutedPit.fuelPickupMethodsKey} INTEGER NOT NULL, "
      "${ScoutedPit.hasTurretKey} INTEGER NOT NULL, "
      "${ScoutedPit.maxFuelCapacityKey} INTEGER NOT NULL, "
      "${ScoutedPit.shooterNumberKey} INTEGER NOT NULL, "
      "${ScoutedPit.autoCommentsKey} TEXT NOT NULL, "
      "${ScoutedPit.generalCommentsKey} TEXT NOT NULL)",
    );
  }


Future<int> upsertScoutedPit(ScoutedPit scoutedPit) async {
    Database db = await dbHelper.db;
    int result = await db.insert(
      ScoutedPit.tableName,
      scoutedPit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<ScoutedPit?> getScoutedPit(int teamNumber) async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      ScoutedPit.tableName,
      where: "${ScoutedPit.teamNumberKey} = ?",
      whereArgs: [teamNumber],
    );

    ScoutedPit? scoutedPit = result.isNotEmpty
        ? ScoutedPit.fromMap(result.first)
        : null;

    return scoutedPit;
  }

  Future<List<ScoutedPit>> getScoutedPits() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      ScoutedPit.tableName,
    );

    List<ScoutedPit> scoutedPits = result
        .map((e) => ScoutedPit.fromMap(e))
        .toList();

    return scoutedPits;
  }

  Future<List<ScoutedPit>> getLocalScoutedPits() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      ScoutedPit.tableName,
      where: "${ScoutedPit.localKey} = 1",
    );

    List<ScoutedPit> scoutedPits = result
        .map((e) => ScoutedPit.fromMap(e))
        .toList();

    return scoutedPits;
  }

  Future<int> deleteScoutedPit(String uid) async {
    Database db = await dbHelper.db;

    int result = await db.delete(
      ScoutedPit.tableName,
      where: "${ScoutedPit.uidKey} = ?",
      whereArgs: [uid],
    );

    return result;
  }

  Future<int> markScoutedPitSynced(String uid) async {
    Database db = await dbHelper.db;

    int result = await db.update(
      ScoutedPit.tableName,
      {ScoutedPit.localKey: 0},
      where: "${ScoutedPit.uidKey} = ?",
      whereArgs: [uid],
    );

    return result;
  }
}
