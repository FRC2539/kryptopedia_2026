import 'dart:convert';

import 'package:kryptopedia/models/event.dart';
import 'package:sqflite/sqflite.dart';

import 'package:kryptopedia/util/db/helper.dart';

class DbEvents {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, Event.tableName)) return;
    await db.execute(
      "CREATE TABLE ${Event.tableName}("
      "${Event.idKey} INTEGER PRIMARY KEY, "
      "${Event.codeKey} TEXT NOT NULL, "
      "${Event.nameKey} TEXT NOT NULL, "
      "${Event.yearKey} INTEGER NOT NULL, "
      "${Event.serverURLKey} TEXT, "
      "${Event.authTokenKey} TEXT, "
      "${Event.teamNumberKey} INTEGER NOT NULL, "
      "${Event.lastSyncKey} INTEGER NOT NULL, "
      "${Event.lastScouterKey} TEXT, "
      "${Event.defaultAlliancePositionKey} TEXT, "
      "${Event.pitMapDataJSONKey} TEXT)"
    );
  }

  Future<int> upsertEvent(Event event) async {
    Database db = await dbHelper.db;
    int result = await db.insert(
      Event.tableName,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<bool> doesEventExist() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      Event.tableName,
      where: "${Event.idKey} = 0",
    );

    return (result.isNotEmpty);
  }

  Future<Event> getEvent() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      Event.tableName,
      where: "${Event.idKey} = 0",
    );

    return Event.fromMap(result.first);
  }

  Future<int> updateSyncTime(DateTime syncTime) async {
    Database db = await dbHelper.db;

    int result = await db.update(Event.tableName, {
      Event.lastSyncKey: syncTime.millisecondsSinceEpoch,
    }, where: "${Event.idKey} = 0");

    return result;
  }

  Future<int> updateLastScouter(String scouterID) async {
    Database db = await dbHelper.db;

    int result = await db.update(Event.tableName, {
      Event.lastScouterKey: scouterID,
    }, where: "${Event.idKey} = 0");

    return result;
  }

  Future<int> updateAlliancePosition(
    AlliancePosition alliancePosition,
  ) async {
    Database db = await dbHelper.db;

    int result = await db.update(Event.tableName, {
      Event.defaultAlliancePositionKey: alliancePositionNames[alliancePosition],
    }, where: "${Event.idKey} = 0");
    
    return result;
  }

  Future<int> updatePitMapData(Map<String, dynamic> pitMapDataJSON) async {
    Database db = await dbHelper.db;

    int result = await db.update(Event.tableName, {
      Event.pitMapDataJSONKey: jsonEncode(pitMapDataJSON),
    }, where: "${Event.idKey} = 0");
    
    return result;
  }
}

Map<AlliancePosition, String> alliancePositionNames = {
  AlliancePosition.red1: "Red 1",
  AlliancePosition.red2: "Red 2",
  AlliancePosition.red3: "Red 3",
  AlliancePosition.blue1: "Blue 1",
  AlliancePosition.blue2: "Blue 2",
  AlliancePosition.blue3: "Blue 3",
};
