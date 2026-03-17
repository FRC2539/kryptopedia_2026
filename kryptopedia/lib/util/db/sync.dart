import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/notification.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/preloaded_flag.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/db/preloaded_flags.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';

Future<APIResponse> syncData({
  bool hard = false,
  bool fromClean = false,
}) async {
  DbEvents dbEvents = DbEvents();
  Event event = await dbEvents.getEvent();

  if (!event.syncEnabled) {
    return APIResponse(success: false, data: "Sync disabled");
  }

  List<SyncDataItem> dataToPush = [];

  DbScoutedPits dbScoutedPits = DbScoutedPits();
  DbScoutedMatches dbScoutedMatches = DbScoutedMatches();
  DbTeamFlagApplications dbTeamFlagApplications = DbTeamFlagApplications();

  List<ScoutedPit> scoutedPits = await dbScoutedPits.getLocalScoutedPits();
  dataToPush.addAll(scoutedPits.map((s) => s.toSyncDataItem()));

  List<ScoutedMatch> scoutedMatches = await dbScoutedMatches
      .getLocalScoutedMatches();
  dataToPush.addAll(scoutedMatches.map((s) => s.toSyncDataItem()));

  List<TeamFlagApplication> teamFlagApplications = await dbTeamFlagApplications
      .getLocalTeamFlagApplications();
  dataToPush.addAll(teamFlagApplications.map((t) => t.toSyncDataItem()));

  //PUSH ^^
  APIResponse pulledData = await Api.syncData(
    event.serverURL!,
    event.teamNumber,
    event.authToken!,
    (event.lastSync == null || hard)
        ? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toIso8601String()
        : event.lastSync!.toUtc().toIso8601String(),
    dataToPush,
    fromClean: fromClean,
  );
  if (!pulledData.success) {
    return APIResponse(
      success: false,
      data: "Error syncing data: ${pulledData.data}",
    );
  }
  //PULL vv

  //mark successful pushes
  await Future.wait([
    ...scoutedPits.map((s) => dbScoutedPits.markScoutedPitSynced(s.uid)),
    ...scoutedMatches.map(
      (s) => dbScoutedMatches.markScoutedMatchSynced(s.uid),
    ),
    ...teamFlagApplications.map((t) {
      if (t.deleted) {
        return dbTeamFlagApplications.deleteTeamFlagApplication(
          t.name,
          t.teamNumber,
        );
      }
      return dbTeamFlagApplications.markTeamFlagApplicationSynced(
        t.name,
        t.teamNumber,
      );
    }),
  ]);

  DateTime syncedTo = DateTime.parse(pulledData.data["synced_to"]);
  List<dynamic> items = pulledData.data["items"];

  DbTeams dbTeams = DbTeams();
  DbTeamMembers dbTeamMembers = DbTeamMembers();
  DbMatches dbMatches = DbMatches();
  DbPreloadedFlags dbPreloadedFlags = DbPreloadedFlags();

  if (kDebugMode) print(pulledData.data);

  bool pulledPitMap = false;
  if (pulledData.data["pit_map_data"] != null) {
    await dbEvents.updatePitMapData(pulledData.data["pit_map_data"]);
    pulledPitMap = true;
  }

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

      if (type == "team_member") {
        if (deleted) {
          dbTeamMembers.deleteTeamMember(item["id"]);
          continue;
        }
        TeamMember teamMember = TeamMember(id: item["id"], name: item["name"]);
        await dbTeamMembers.upsertTeamMember(teamMember);
      }

      if (type == "match") {
        if (deleted) {
          dbMatches.deleteMatch(item["number"], item["comp_level"]);
        }
        EventMatch match = EventMatch.fromMap(item);
        await dbMatches.upsertMatch(match);
      }

      if (type == "preloaded_flag") {
        if (deleted) {
          dbPreloadedFlags.deletePreloadedFlag(item["name"]);
          continue;
        }
        PreloadedFlag preloadedFlag = PreloadedFlag(item["name"]);
        await dbPreloadedFlags.upsertPreloadedFlag(preloadedFlag);
      }

      //ScoutingDataItems vv

      if (type == "scouted_pit") {
        if (deleted) {
          dbScoutedPits.deleteScoutedPit(item["data"]["uid"]);
          continue;
        }
        ScoutedPit scoutedPit = ScoutedPit.fromMap(item["data"]);
        await dbScoutedPits.upsertScoutedPit(scoutedPit);
      }

      if (type == "scouted_match") {
        if (deleted) {
          dbScoutedMatches.deleteScoutedMatch(item["data"]["uid"]);
          continue;
        }
        ScoutedMatch scoutedMatch = ScoutedMatch.fromMap(item["data"]);
        await dbScoutedMatches.upsertScoutedMatch(scoutedMatch);
      }

      if (type == "team_flag_application") {
        if (deleted) {
          dbTeamFlagApplications.deleteTeamFlagApplication(
            item["data"][TeamFlagApplication.nameKey],
            item["data"][TeamFlagApplication.teamNumberKey],
          );
          continue;
        }
        TeamFlagApplication teamFlagApplication = TeamFlagApplication(
          item["data"][TeamFlagApplication.nameKey],
          item["data"][TeamFlagApplication.teamNumberKey],
          false,
          false,
        );
        await dbTeamFlagApplications.upsertTeamFlagApplication(
          teamFlagApplication,
        );
      }
    } catch (e) {
      return APIResponse(
        success: false,
        data: "an error! $e \n on item: $item",
      );
    }
  }

  await dbEvents.updateSyncTime(syncedTo);
  return APIResponse(
    success: true,
    data:
        "Uploaded ${dataToPush.length} items, downloaded ${items.length} items${pulledPitMap ? ", and updated the pit map" : ""}.",
  );
}

Future<APIResponse> uploadPitPhotos(Event event) async {
  DbScoutedPits dbScoutedPits = DbScoutedPits();

  List<ScoutedPit> scoutedPits = await dbScoutedPits.getScoutedPits();
  int successCount = 0;
  for (ScoutedPit pit in scoutedPits) {
    try {
      if (pit.serverPhotoUpdated != null || pit.local) continue;
      String path = await pit.photoPath;
      if (!await File(path).exists()) continue;
      APIResponse response = await Api.uploadPhoto(
        event.serverURL!,
        event.teamNumber,
        event.authToken!,
        pit.uid,
        path,
      );
      if (!response.success) throw response.data;
      await dbScoutedPits.updateScoutedPitPhotoTimestamp(
        pit.uid,
        response.data,
      );
      successCount++;
    } catch (e) {
      return APIResponse(
        success: false,
        data: "Error uploading photo for ${pit.teamNumber}: $e",
      );
    }
  }
  return APIResponse(success: true, data: "Uploaded $successCount photos");
}

Future<APIResponse> downloadPitPhotos(Event event) async {
  DbScoutedPits dbScoutedPits = DbScoutedPits();

  List<ScoutedPit> scoutedPits = await dbScoutedPits.getScoutedPits();
  int successCount = 0;
  for (ScoutedPit pit in scoutedPits) {
    try {
      if (pit.serverPhotoUpdated == null || pit.local) continue;
      File existingFile = File(await pit.photoPath);
      if (await existingFile.exists() &&
          existingFile.lastModifiedSync().isAfter(pit.serverPhotoUpdated!)) {
        continue;
      }
      APIResponse response = await Api.downloadPitPhoto(
        event.serverURL!,
        event.teamNumber,
        event.authToken!,
        pit.uid,
      );
      if (!response.success) {
        return APIResponse(
          success: false,
          data:
              "Error downloading photo for ${pit.teamNumber}: ${response.data}",
        );
      }
      String path = await pit.photoPath;
      File file = File(path);
      await file.create(recursive: true);
      await file.writeAsBytes(response.data);
      successCount++;
    } catch (e) {
      return APIResponse(
        success: false,
        data: "Error downloading photo for ${pit.teamNumber}: $e",
      );
    }
  }
  return APIResponse(success: true, data: "Downloaded $successCount photos");
}

Future syncFlow(
  BuildContext context, {
  bool hard = false,
  bool fromClean = false,
  bool withPhotos = true,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (context) => NotificationDialog(
      title: "Syncing data",
      body: "Syncing data with server...",
      showOkButton: false,
      showLoading: true,
    ),
  );

  String finalMessage = "Data synced successfully! woohoo\n\n";

  APIResponse dataSyncResponse = await syncData(
    hard: hard,
    fromClean: fromClean,
  );
  if (!dataSyncResponse.success) {
    if (!context.mounted) return;
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) =>
          NotificationDialog(title: "Sync Error", body: dataSyncResponse.data),
    );
    return;
  }
  finalMessage += dataSyncResponse.data;
  finalMessage += "\n";

  if (withPhotos) {
    APIResponse uploadResponse = await uploadPitPhotos(
      await DbEvents().getEvent(),
    );
    if (!uploadResponse.success) {
      if (!context.mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          title: "Photo Upload Error",
          body: uploadResponse.data,
        ),
      );
      return;
    }
    finalMessage += uploadResponse.data;
    finalMessage += "\n";

    APIResponse downloadResponse = await downloadPitPhotos(
      await DbEvents().getEvent(),
    );
    if (!downloadResponse.success) {
      if (!context.mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          title: "Photo Download Error",
          body: downloadResponse.data,
        ),
      );
      return;
    }
    finalMessage += downloadResponse.data;
  }

  if (!context.mounted) return;
  Navigator.pop(context);
  await showDialog(
    context: context,
    builder: (context) =>
        NotificationDialog(title: "Sync Complete", body: finalMessage),
  );
}
