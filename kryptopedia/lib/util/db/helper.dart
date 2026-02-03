import 'dart:async';
import 'dart:io';

import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  static Database? _db;
  static bool _initialized = false;

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> get db async {
    if (!_initialized) {
      _db = await initializeDb();
      _initialized = true;
    }
    return _db!;
  }

  Future<Database> initializeDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "kryptopedia.db");
    if (!Platform.isWindows && !Platform.isLinux) {
      Database database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, v) async => await createTables(db),
      );
      return database;
    } else {
      sqfliteFfiInit();
      Database database = await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, v) async => await createTables(db),
        ),
      );
      return database;
    }
  }

  //db needs to passed around through parameters here, otherwise we get a loop of
  //initializing the database over and over mid-initialization and nothing works
  //and everything complains about it being closed
  Future<void> createTables(Database db) async {
    DbTeams dbTeams = DbTeams();
    DbEvents dbEvents = DbEvents();
    DbScoutedPits dbScoutedPits = DbScoutedPits();

    await Future.wait([
      dbTeams.ensureTableExists(db),
      dbEvents.ensureTableExists(db),
      dbScoutedPits.ensureTableExists(db),
    ]);
  }

  Future<bool> tableExists(Database db, String tableName) async {
    var retValue = await db.query(
      'sqlite_master',
      where: 'name = ?',
      whereArgs: [tableName],
    );
    return retValue.isNotEmpty;
  }

  Future recreateDatabase() async {
    await db;
    if (_db!.isOpen) {
      await _db!.close();
    }
    _initialized = false;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "kryptopedia.db");
    if (!Platform.isWindows && !Platform.isLinux) {
      await deleteDatabase(path);
    } else {
      File dbFile = File(path);
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
    }
    await db;
  }

  Future<String?> syncData() async {
    DbEvents dbEvents = DbEvents();
    Event event = await dbEvents.getEvent();

    if (!event.syncEnabled) return null;

    List<SyncDataItem> dataToPush = [];

    //PUSH ^^
    APIResponse pulledData = await Api.syncData(
      event.serverURL!,
      event.teamNumber,
      event.authToken!,
      event.lastSync.toIso8601String(),
      dataToPush,
    );
    if (!pulledData.success) {
      return "Error syncing data: ${pulledData.data}";
    }
    //PULL vv

    DateTime syncedTo = DateTime.parse(pulledData.data["synced_to"]);
    List<dynamic> items = pulledData.data["items"];

    DbTeams dbTeams = DbTeams();

    for (dynamic item in items) {
      try {
        String type = item["type"];
        bool deleted = item["deleted"];

        if (type == "team") {
          if (deleted) {
            dbTeams.deleteTeam(item["number"]);
            continue;
          }
          Team team = Team(item["number"], item["nickname"]);
          await dbTeams.upsertTeam(team);
        }
      } catch (e) {
        return "an error!: $e \n on item: $item";
      }
    }

    await dbEvents.updateSyncTime(syncedTo);
    return null;
  }
}
