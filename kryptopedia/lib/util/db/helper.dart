import 'dart:async';
import 'dart:io';

import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team.dart';
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
        onCreate: (db, v) => createTables(db),
      );
      return database;
    } else {
      sqfliteFfiInit();
      Database database = await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, v) => createTables(db),
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

    Future.wait([
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

  Future recreateDatabaseWithTestData() async {
    await recreateDatabase();

    DbTeams dbTeams = DbTeams();
    DbEvents dbEvents = DbEvents();

    await Future.wait([
      dbTeams.insertTeam(Team(2539, "Krypton Cougars")),
      dbTeams.insertTeam(Team(1, "Test Team 1")),
      dbTeams.insertTeam(Team(2, "Test Team 2")),
      dbTeams.insertTeam(Team(3, "Test Team 3")),
      dbTeams.insertTeam(Team(4, "Test Team 4")),
      dbTeams.insertTeam(Team(5, "Test Team 5")),
      dbTeams.insertTeam(Team(6, "Test Team 6")),
      dbTeams.insertTeam(Team(7, "Test Team 7")),
      dbTeams.insertTeam(Team(8, "Test Team 8")),
      dbTeams.insertTeam(Team(9, "Test Team 9")),
      dbTeams.insertTeam(Team(10, "Test Team 10")),
      dbTeams.insertTeam(Team(11, "Test Team 11")),
      dbTeams.insertTeam(Team(12, "Test Team 12")),
      dbEvents.insertEvent(
        Event(0, "FMA District Hatboro-Horsham Event", "PAHAT", 2026),
      ),
    ]);
  }
}
