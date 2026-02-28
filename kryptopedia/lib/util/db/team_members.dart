import 'package:sqflite/sqflite.dart';

import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/db/helper.dart';

class DbTeamMembers {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, TeamMember.tableName)) return;
    await db.execute(
      "CREATE TABLE ${TeamMember.tableName}("
      "${TeamMember.idKey} TEXT PRIMARY KEY, "
      "${TeamMember.nameKey} TEXT NOT NULL)",
    );
  }

  Future<TeamMember> getTeamMemberById(String id) async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      TeamMember.tableName,
      where: "${TeamMember.idKey} = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return TeamMember.fromMap(result.first);
    } else {
      throw Exception("Team member with id $id not found");
    }
  }

  Future<int> upsertTeamMember(TeamMember teamMember) async {
    Database db = await dbHelper.db;
    int result = await db.insert(
      TeamMember.tableName,
      teamMember.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<TeamMember>> getTeamMembers() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> teamMembers = await db.query(
      TeamMember.tableName,
    );

    return List.generate(teamMembers.length, (i) {
      return TeamMember.fromMap(teamMembers[i]);
    });
  }

  Future<int> deleteTeamMember(String id) async {
    Database db = await dbHelper.db;

    int result = await db.delete(
      TeamMember.tableName,
      where: "${TeamMember.idKey} = ?",
      whereArgs: [id],
    );

    return result;
  }
}
