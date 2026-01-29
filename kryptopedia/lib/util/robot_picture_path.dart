import 'dart:io';

import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//TODO this sytem will still not work well with scouting conflicts :( rethink
Future<String> robotPicturePath(int teamNumber) async {
  DbEvents dbEvents = DbEvents();
  Event? event = await dbEvents.getEvent();

  final Directory appDir = await getApplicationDocumentsDirectory();
  Directory robotPicsDir = await Directory(
    "${appDir.path}/Robot_Pics",
  ).create();

  return join(robotPicsDir.path, "${event?.code}_${teamNumber}_robot.jpg");
}
