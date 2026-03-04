import 'package:kryptopedia/models/preloaded_flag.dart';
import 'package:kryptopedia/util/db/helper.dart';
import 'package:sqflite/sqflite.dart';

class DbPreloadedFlags {
  DbHelper dbHelper = DbHelper();

  Future ensureTableExists(Database db) async {
    if (await dbHelper.tableExists(db, PreloadedFlag.tableName)) return;
    await db.execute(
      "CREATE TABLE ${PreloadedFlag.tableName}("
      "${PreloadedFlag.nameKey} TEXT NOT NULL)",
    );
  }

  Future<int> upsertPreloadedFlag(PreloadedFlag flag) async {
    Database db = await dbHelper.db;
    int result = await db.insert(
      PreloadedFlag.tableName,
      flag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<PreloadedFlag>> getPreloadedFlags() async {
    Database db = await dbHelper.db;

    final List<Map<String, dynamic>> flags = await db.query(
      PreloadedFlag.tableName,
    );

    return List.generate(flags.length, (i) {
      return PreloadedFlag.fromMap(flags[i]);
    });
  }

  Future<int> deletePreloadedFlag(String name) async {
    Database db = await dbHelper.db;
    int result = await db.delete(
      PreloadedFlag.tableName,
      where: "${PreloadedFlag.nameKey} = ?",
      whereArgs: [name],
    );
    return result;
  }
}
