import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/util/db/helper.dart';
import 'package:sqflite/sqflite.dart';

class DbScoutedMatches {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, ScoutedMatch.tableName)) return;
    await db.execute(
      "CREATE TABLE ${ScoutedMatch.tableName}("
      "${ScoutedMatch.teamNumberKey} INTEGER NOT NULL, "
      "${ScoutedMatch.localKey} INTEGER NOT NULL, "
      "${ScoutedMatch.uidKey} TEXT PRIMARY KEY, "
      "${ScoutedMatch.scouterIdKey} TEXT NOT NULL, "
      "${ScoutedMatch.autoFuelScoredKey} INTEGER NOT NULL, "
      "${ScoutedMatch.autoFuelFinalKey} INTEGER NOT NULL, "
      "${ScoutedMatch.autoClimbedKey} INTEGER NOT NULL, "
      "${ScoutedMatch.teleopFuelScoredKey} INTEGER NOT NULL,"
      "${ScoutedMatch.teleopFuelFedKey} INTEGER NOT NULL,"
      "${ScoutedMatch.climbLevelKey} INTEGER NOT NULL,"
      "${ScoutedMatch.defenseCommentsKey} TEXT NOT NULL, "
      "${ScoutedMatch.generalCommentsKey} TEXT NOT NULL)",
    );
  }

  Future<int> upsertScoutedMatch(ScoutedMatch scoutedMatch) async {
    Database db = await dbHelper.db;
    int result = await db.insert(
      ScoutedMatch.tableName,
      scoutedMatch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<ScoutedMatch>> getScoutedMatches() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      ScoutedMatch.tableName,
    );

    List<ScoutedMatch> scoutedMatches = result
        .map((map) => ScoutedMatch.fromMap(map))
        .toList();

    return scoutedMatches;
  }

  Future<List<ScoutedMatch>> getLocalScoutedMatches() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      ScoutedMatch.tableName,
      where: "${ScoutedMatch.localKey} = ?",
      whereArgs: [1],
    );

    List<ScoutedMatch> scoutedMatches = result
        .map((map) => ScoutedMatch.fromMap(map))
        .toList();

    return scoutedMatches;
  }

  Future<ScoutedMatch?> getScoutedMatch(int teamNumber) async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      ScoutedMatch.tableName,
      where: "${ScoutedMatch.teamNumberKey} = ?",
      whereArgs: [teamNumber],
    );

    ScoutedMatch? scoutedMatch = result.isNotEmpty
        ? ScoutedMatch.fromMap(result.first)
        : null;

    return scoutedMatch;
  }

  Future<int> deleteScoutedMatch(String uid) async {
    Database db = await dbHelper.db;
    int result = await db.delete(
      ScoutedMatch.tableName,
      where: "${ScoutedMatch.uidKey} = ?",
      whereArgs: [uid],
    );
    return result;
  }

  Future<int> markScoutedMatchSynced(String uid) async {
    Database db = await dbHelper.db;
    int result = await db.update(
      ScoutedMatch.tableName,
      {ScoutedMatch.localKey: 0},
      where: "${ScoutedMatch.uidKey} = ?",
      whereArgs: [uid],
    );
    return result;
  }

  //Future<bool> existsScoutedMatchWithTeam(String id, int teamID) async {
  //  Database db = await dbHelper.db;
  //  bool result = await db.;
  //}
}
