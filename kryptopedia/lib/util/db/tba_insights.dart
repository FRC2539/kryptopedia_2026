import 'package:sqflite/sqflite.dart';

import 'package:kryptopedia/models/eventinsights.dart';
import 'package:kryptopedia/util/db/helper.dart';

class DbEventInsights {
  DbHelper dbHelper = DbHelper();

  Future createEventInsightsTable() async {
    Database db = await dbHelper.db;

    await db.execute(
      "DROP TABLE IF EXISTS ${EventInsights.tblEventInsightsInfo}",
    );
    await db.execute(
      "CREATE TABLE ${EventInsights.tblEventInsightsInfo}("
      "${EventInsights.colEventInsightsTeamId} INTEGER NOT NULL, "
      "${EventInsights.colEventInsightsTeamOprs} REAL NOT NULL, "
      "${EventInsights.colEventInsightsTeamDprs} REAL NOT NULL, "
      "${EventInsights.colEventInsightsTeamCcwms} REAL NOT NULL)",
    );
  }

  Future<int> insertEventInsights(EventInsights eventInsignts) async {
    Database db = await dbHelper.db;
    var result = await db.insert(
      EventInsights.tblEventInsightsInfo,
      eventInsignts.toMap(),
    );
    return result;
  }

  Future<List<EventInsights>> getEventInsights() async {
    // Get an instance to the database
    Database db = await dbHelper.db;

    // Check to see if the database exists.
    if (await dbHelper.tableExists(db, EventInsights.tblEventInsightsInfo)) {
      // Query the table for all users
      final List<Map<String, dynamic>> eventinsights = await db.query(
        EventInsights.tblEventInsightsInfo,
      );

      // Convert the List<Map<String, dynamic>> into a List<User>
      return List.generate(eventinsights.length, (i) {
        return EventInsights.fromMap(eventinsights[i]);
      });
    }

    // Table didn't exist, so we need to return an empty User list.
    return [];
  }

  Future<double?> getTeamOprs(int teamid) async {
    // Get an instance to the database
    Database db = await dbHelper.db;

    // Check to see if the database exists.
    if (await dbHelper.tableExists(db, EventInsights.tblEventInsightsInfo)) {
      // Query the table for the event name
      final List<Map<String, dynamic>> eventInsightsList = await db.query(
        EventInsights.tblEventInsightsInfo,
        where: "${EventInsights.colEventInsightsTeamId} = ?",
        whereArgs: [teamid],
      );

      if (eventInsightsList.isNotEmpty) {
        return eventInsightsList[0][EventInsights.colEventInsightsTeamOprs];
      }
    }

    return null;
  }

  Future<double?> getTeamDprs(int teamid) async {
    // Get an instance to the database
    Database db = await dbHelper.db;

    // Check to see if the database exists.
    if (await dbHelper.tableExists(db, EventInsights.tblEventInsightsInfo)) {
      // Query the table for the event name
      final List<Map<String, dynamic>> eventInsightsList = await db.query(
        EventInsights.tblEventInsightsInfo,
        where: "${EventInsights.colEventInsightsTeamId} = ?",
        whereArgs: [teamid],
      );

      if (eventInsightsList.isNotEmpty) {
        return eventInsightsList[0][EventInsights.colEventInsightsTeamDprs];
      }
    }

    return null;
  }

  Future<double?> getTeamCcwms(int teamid) async {
    // Get an instance to the database
    Database db = await dbHelper.db;

    // Check to see if the database exists.
    if (await dbHelper.tableExists(db, EventInsights.tblEventInsightsInfo)) {
      // Query the table for the event name
      final List<Map<String, dynamic>> eventInsightsList = await db.query(
        EventInsights.tblEventInsightsInfo,
        where: "${EventInsights.colEventInsightsTeamId} = ?",
        whereArgs: [teamid],
      );

      if (eventInsightsList.isNotEmpty) {
        return eventInsightsList[0][EventInsights.colEventInsightsTeamCcwms];
      }
    }

    return null;
  }
}
