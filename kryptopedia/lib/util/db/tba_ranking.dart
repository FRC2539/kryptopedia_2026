import 'package:sqflite/sqflite.dart';
import 'package:kryptopedia/util/db/helper.dart';
import 'package:kryptopedia/models/eventranking.dart';

class DbEventRanking {
  DbHelper dbHelper = DbHelper();

  Future createEventRankingTable() async {
    Database db = await dbHelper.db;

    await db.execute(
      "DROP TABLE IF EXISTS ${EventRanking.tblEventRankingInfo}",
    );
    await db.execute(
      "CREATE TABLE ${EventRanking.tblEventRankingInfo}("
      "${EventRanking.colEventRankingTeamId} INTEGER NOT NULL, "
      "${EventRanking.colEventRankingTeamRank} INTEGER NOT NULL)",
    );
  }

  Future<int> insertEventRanking(EventRanking eventRanking) async {
    Database db = await dbHelper.db;
    var result = await db.insert(
      EventRanking.tblEventRankingInfo,
      eventRanking.toMap(),
    );
    return result;
  }

  Future<List<EventRanking>> getEventRankings() async {
    // Get an instance to the database
    Database db = await dbHelper.db;

    // Check to see if the database exists.
    if (await dbHelper.tableExists(db, EventRanking.tblEventRankingInfo)) {
      // Query the table for all users
      final List<Map<String, dynamic>> eventrankings = await db.query(
        EventRanking.tblEventRankingInfo,
      );

      return List.generate(eventrankings.length, (i) {
        return EventRanking.fromMap(eventrankings[i]);
      });
    }

    // Table didn't exist, so we need to return an empty User list.
    return [];
  }

  Future<int?> getTeamRanking(int teamid) async {
    // Get an instance to the database
    Database db = await dbHelper.db;

    // Check to see if the database exists.
    if (await dbHelper.tableExists(db, EventRanking.tblEventRankingInfo)) {
      final List<Map<String, dynamic>> eventRankingList = await db.query(
        EventRanking.tblEventRankingInfo,
        where: "${EventRanking.colEventRankingTeamId} = ?",
        whereArgs: [teamid],
      );

      if (eventRankingList.isNotEmpty) {
        return eventRankingList[0][EventRanking.colEventRankingTeamRank];
      }
    }

    return null;
  }
}
