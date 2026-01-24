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
      "${Event.yearKey} INTEGER NOT NULL)",
    );
  }

  Future<int> insertEvent(Event event) async {
    Database db = await dbHelper.db;
    int result = await db.insert(Event.tableName, event.toMap());
    return result;
  }

  Future<Event> getEvent() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> result = await db.query(
      Event.tableName,
      where: "${Event.idKey} = 0",
    );

    Event returnValue = Event.fromMap(result.first);

    return returnValue;
  }
}
