import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/util/db/helper.dart';
import 'package:sqflite/sqflite.dart';

class DbMatches {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, EventMatch.tableName)) return;
    await db.execute(
      "CREATE TABLE ${EventMatch.tableName}("
      "${EventMatch.numberKey} INTEGER NOT NULL, "
      "${EventMatch.compLevelKey} TEXT NOT NULL, "
      "${EventMatch.red1numberKey} INTEGER NOT NULL, "
      "${EventMatch.red2numberKey} INTEGER NOT NULL, "
      "${EventMatch.red3numberKey} INTEGER NOT NULL, "
      "${EventMatch.blue1numberKey} INTEGER NOT NULL, "
      "${EventMatch.blue2numberKey} INTEGER NOT NULL, "
      "${EventMatch.blue3numberKey} INTEGER NOT NULL, "
      "PRIMARY KEY (${EventMatch.numberKey}, ${EventMatch.compLevelKey}))",
    );
  }

  Future<int> upsertMatch(EventMatch match) async {
    Database db = await dbHelper.db;
    int result = await db.insert(
      EventMatch.tableName,
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<EventMatch>> getMatches() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> matches = await db.query(
      EventMatch.tableName,
    );

    return List.generate(matches.length, (i) {
      return EventMatch.fromMap(matches[i]);
    });
  }

  Future<List<EventMatch>> getQualificationMatches() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> matches = await db.query(
      EventMatch.tableName,
      where: "${EventMatch.compLevelKey} = ?",
      whereArgs: ["qm"],
    );

    return List.generate(matches.length, (i) {
      return EventMatch.fromMap(matches[i]);
    });
  }

  Future<EventMatch> getQualificationMatch(int matchNumber) async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      EventMatch.tableName,
      where: "${EventMatch.compLevelKey} = ? AND ${EventMatch.numberKey} = ?",
      whereArgs: ["qm", matchNumber],
    );

    EventMatch returnValue = EventMatch.fromMap(result.first);

    return returnValue;
  }

  Future<int> deleteMatch(int matchNumber, String compLevel) async {
    Database db = await dbHelper.db;

    int result = await db.delete(
      EventMatch.tableName,
      where: "${EventMatch.compLevelKey} = ? AND ${EventMatch.numberKey} = ?",
      whereArgs: [compLevel, matchNumber],
    );

    return result;
  }
}
