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
import 'package:kryptopedia/models/team_insights_record.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/db/preloaded_flags.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/util/db/team_insights.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';

Future<APIResponse> syncData(
  BuildContext context, {
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
  DbTeamInsightsRecords dbTeamInsightsRecords = DbTeamInsightsRecords();

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
          await dbTeams.deleteTeam(item["number"]);
          continue;
        }
        Team team = Team(item["number"], item["nickname"]);
        await dbTeams.upsertTeam(team);
      }

      if (type == "team_member") {
        if (deleted) {
          await dbTeamMembers.deleteTeamMember(item["id"]);
          continue;
        }
        TeamMember teamMember = TeamMember(id: item["id"], name: item["name"]);
        await dbTeamMembers.upsertTeamMember(teamMember);
      }

      if (type == "match") {
        if (deleted) {
          await dbMatches.deleteMatch(item["number"], item["comp_level"]);
          continue;
        }
        EventMatch match = EventMatch.fromMap(item);
        await dbMatches.upsertMatch(match);
      }

      if (type == "preloaded_flag") {
        if (deleted) {
          await dbPreloadedFlags.deletePreloadedFlag(item["name"]);
          continue;
        }
        PreloadedFlag preloadedFlag = PreloadedFlag(item["name"]);
        await dbPreloadedFlags.upsertPreloadedFlag(preloadedFlag);
      }

      if (type == "team_insights") {
        TeamInsightsRecord teamInsightsRecord = TeamInsightsRecord.fromMap(
          item["data"],
        );
        await dbTeamInsightsRecords.upsertTeamInsightsRecord(
          teamInsightsRecord,
        );
      }

      //ScoutingDataItems vv

      if (type == "scouted_pit") {
        if (deleted) {
          await dbScoutedPits.deleteScoutedPit(item["data"]["uid"]);
          continue;
        }
        ScoutedPit scoutedPit = ScoutedPit.fromMap(item["data"]);
        await dbScoutedPits.upsertScoutedPit(scoutedPit);
      }

      if (type == "scouted_match") {
        if (deleted) {
          await dbScoutedMatches.deleteScoutedMatch(item["data"]["uid"]);
          continue;
        }
        ScoutedMatch scoutedMatch = ScoutedMatch.fromMap(item["data"]);
        await dbScoutedMatches.upsertScoutedMatch(scoutedMatch);
      }

      if (type == "team_flag_application") {
        if (deleted) {
          await dbTeamFlagApplications.deleteTeamFlagApplication(
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

Future syncFlow(
  BuildContext context, {
  bool hard = false,
  bool fromClean = false,
  bool withPhotos = true,
}) async {
  String finalMessage = "Data synced successfully! woohoo\n\n";

  ValueNotifier<String> syncStatus = ValueNotifier<String>("Starting data...");
  ValueNotifier<double?> loadingProgress = ValueNotifier<double?>(null);

  if (context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) => ValueListenableBuilder<String>(
        valueListenable: syncStatus,
        builder: (context, status, _) => NotificationDialog(
          title: "Syncing data...",
          body: status,
          showOkButton: false,
          showLoading: true,
          loadingProgress: loadingProgress.value,
        ),
      ),
    );
  }

  APIResponse dataSyncResponse = await syncData(
    context,
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

  Event event = await DbEvents().getEvent();

  if (withPhotos) {
    syncStatus.value = "Uploading photos...";

    DbScoutedPits dbScoutedPits = DbScoutedPits();
    List<ScoutedPit> scoutedPits = await dbScoutedPits.getScoutedPits();

    List<ScoutedPit> pitsToUpload = [];
    for (ScoutedPit pit in scoutedPits) {
      if (pit.serverPhotoUpdated == null &&
          !pit.local &&
          await File(await pit.photoPath).exists()) {
        pitsToUpload.add(pit);
      }
    }

    for (int i = 0; i < pitsToUpload.length; i++) {
      ScoutedPit pit = pitsToUpload[i];
      syncStatus.value =
          "Uploading photo for team ${pit.teamNumber}... ${i + 1}/${pitsToUpload.length}";
      loadingProgress.value = (i + 1) / pitsToUpload.length;
      try {
        String path = await pit.photoPath;
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
        //rewrite photo with itself to update modified time
        File file = File(path);
        await file.writeAsBytes(await file.readAsBytes());
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => NotificationDialog(
            title: "Photo Upload Error",
            body: "Error uploading photo for team ${pit.teamNumber}: $e",
          ),
        );
        return;
      }
    }

    finalMessage += "Uploaded ${pitsToUpload.length} photos.\n";
    syncStatus.value = "Downloading photos...";

    List<ScoutedPit> pitsToDownload = [];
    for (ScoutedPit pit in scoutedPits) {
      File localFile = File(await pit.photoPath);
      if (pit.serverPhotoUpdated != null &&
          !pit.local &&
          (!localFile.existsSync() ||
              localFile.lastModifiedSync().isBefore(pit.serverPhotoUpdated!))) {
        pitsToDownload.add(pit);
      }
    }

    for (int i = 0; i < pitsToDownload.length; i++) {
      ScoutedPit pit = pitsToDownload[i];
      syncStatus.value =
          "Downloading photo for team ${pit.teamNumber}... ${i + 1}/${pitsToDownload.length}";
      loadingProgress.value = (i + 1) / pitsToDownload.length;
      try {
        APIResponse response = await Api.downloadPitPhoto(
          event.serverURL!,
          event.teamNumber,
          event.authToken!,
          pit.uid,
        );
        if (!response.success) throw response.data;
        String path = await pit.photoPath;
        File file = File(path);
        await file.create(recursive: true);
        await file.writeAsBytes(response.data);
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => NotificationDialog(
            title: "Photo Download Error",
            body: "Error downloading photo for team ${pit.teamNumber}: $e",
          ),
        );
        return;
      }
    }

    finalMessage += "Downloaded ${pitsToDownload.length} photos.\n";
  }

  if (!context.mounted) return;
  Navigator.pop(context);
  await showDialog(
    context: context,
    builder: (context) =>
        NotificationDialog(title: "Sync Complete", body: finalMessage),
  );
}
