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
      "${ScoutedMatch.autoFuelScoredKey} INTEGER NOT NULL, "
      "${ScoutedMatch.autoFuelFinalKey} INTEGER NOT NULL, "
      "${ScoutedMatch.autoClimbedKey} INTEGER NOT NULL, "
      "${ScoutedMatch.teleopFuelScoredKey} INTEGER NOT NULL,"
      "${ScoutedMatch.teleopFuelFedKey} INTEGER NOT NULL,"
      "${ScoutedMatch.climbLevelKey} INTEGER NOT NULL,"
      "${ScoutedMatch.autoCommentsKey} TEXT NOT NULL, "
      "${ScoutedMatch.defenseCommentsKey} TEXT NOT NULL, "
      "${ScoutedMatch.generalCommentsKey} TEXT NOT NULL, ",
    );
  }

  Future<int> insertScoutedMatch(ScoutedMatch scoutedMatch) async {
    Database db = await dbHelper.db;
    int result = await db.insert(ScoutedMatch.tableName, scoutedMatch.toMap());
    return result;
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
}
