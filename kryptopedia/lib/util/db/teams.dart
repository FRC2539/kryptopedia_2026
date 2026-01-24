import 'package:sqflite/sqflite.dart';

import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/helper.dart';

class DbTeams {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, Team.tableName)) return;
    await db.execute(
      "CREATE TABLE ${Team.tableName}("
      "${Team.numberKey} INTEGER PRIMARY KEY, "
      "${Team.nicknameKey} TEXT NOT NULL)",
    );
  }

  Future<int> insertTeam(Team team) async {
    Database db = await dbHelper.db;
    int result = await db.insert(Team.tableName, team.toMap());
    return result;
  }

  Future<List<Team>> getTeams() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> teams = await db.query(Team.tableName);

    return List.generate(teams.length, (i) {
      return Team.fromMap(teams[i]);
    });
  }

  Future<Team> getTeam(int id) async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      Team.tableName,
      where: "${Team.numberKey} = ?",
      whereArgs: [id],
    );

    Team returnValue = Team.fromMap(result.first);

    return returnValue;
  }
}
