import 'package:sqflite/sqflite.dart';

import 'package:kryptopedia/models/team_insights_record.dart';
import 'package:kryptopedia/util/db/helper.dart';

class DbTeamInsightsRecords {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, TeamInsightsRecord.tableName)) return;
    await db.execute(
      "CREATE TABLE ${TeamInsightsRecord.tableName}("
      "${TeamInsightsRecord.teamNumberKey} INTEGER PRIMARY KEY, "
      "${TeamInsightsRecord.oprKey} REAL, "
      "${TeamInsightsRecord.dprKey} REAL, "
      "${TeamInsightsRecord.ccwmKey} REAL, "
      "${TeamInsightsRecord.rankingKey} INTEGER,"
      "${TeamInsightsRecord.epaKey} REAL)",
    );
  }

  Future<int> upsertTeamInsightsRecord(
    TeamInsightsRecord teamInsightsRecord,
  ) async {
    Database db = await dbHelper.db;
    var result = await db.insert(
      TeamInsightsRecord.tableName,
      teamInsightsRecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<TeamInsightsRecord>> getInsightsRecords() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> matches = await db.query(
      TeamInsightsRecord.tableName,
    );

    return List.generate(matches.length, (i) {
      return TeamInsightsRecord.fromMap(matches[i]);
    });
  }

  Future<TeamInsightsRecord?> getTeamInsights(int teamNumber) async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> matches = await db.query(
      TeamInsightsRecord.tableName,
      where: "${TeamInsightsRecord.teamNumberKey} = ?",
      whereArgs: [teamNumber],
    );

    if (matches.isEmpty) return null;
    return TeamInsightsRecord.fromMap(matches[0]);
  }
}
