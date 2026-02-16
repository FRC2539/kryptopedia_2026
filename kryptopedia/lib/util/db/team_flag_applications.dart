import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/util/db/helper.dart';
import 'package:sqflite/sqflite.dart';

class DbTeamFlagApplications {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, TeamFlagApplication.tableName)) return;
    await db.execute(
      "CREATE TABLE ${TeamFlagApplication.tableName}("
      "${TeamFlagApplication.nameKey} TEXT NOT NULL, "
      "${TeamFlagApplication.teamNumberKey} INTEGER NOT NULL, "
      "${TeamFlagApplication.localKey} INTEGER NOT NULL, "
      "${TeamFlagApplication.deletedKey} INTEGER NOT NULL, "
      "PRIMARY KEY (${TeamFlagApplication.nameKey}, ${TeamFlagApplication.teamNumberKey}))",
    );
  }

  Future<int> upsertTeamFlagApplication(
    TeamFlagApplication flagApplication,
  ) async {
    Database db = await dbHelper.db;
    int result = await db.insert(
      TeamFlagApplication.tableName,
      flagApplication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<TeamFlagApplication>> getTeamFlagApplications() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      TeamFlagApplication.tableName,
    );

    return result.map((map) => TeamFlagApplication.fromMap(map)).toList();
  }

  Future<List<TeamFlagApplication>> getActiveTeamFlagApplications() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      TeamFlagApplication.tableName,
      where: "${TeamFlagApplication.deletedKey} = ?",
      whereArgs: [0],
    );

    return result.map((map) => TeamFlagApplication.fromMap(map)).toList();
  }

  Future<List<TeamFlagApplication>> getActiveTeamFlagApplicationsForTeam(
    int teamNumber,
  ) async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      TeamFlagApplication.tableName,
      where:
          "${TeamFlagApplication.teamNumberKey} = ? AND ${TeamFlagApplication.deletedKey} = ?",
      whereArgs: [teamNumber, 0],
    );

    return result.map((map) => TeamFlagApplication.fromMap(map)).toList();
  }
}
