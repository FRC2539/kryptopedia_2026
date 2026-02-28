import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/notification.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';

Future<APIResponse> syncData({bool hard = false}) async {
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
        ? DateTime.fromMillisecondsSinceEpoch(0).toIso8601String()
        : event.lastSync!.toIso8601String(),
    dataToPush,
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

  print(pulledData.data);

  if (pulledData.data["pit_map_data"] != null) {
    await dbEvents.updatePitMapData(pulledData.data["pit_map_data"]);
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
        "Uploaded ${dataToPush.length} items, downloaded ${items.length} items",
  );
}

Future syncDataFlow(BuildContext context, {bool hard = false}) async {
  APIResponse response = await syncData(hard: hard);
  if (!response.success) {
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (context) =>
          NotificationDialog(title: "Sync Error", body: response.data),
    );
  } else {
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (context) => NotificationDialog(
        title: "Sync Complete",
        body: "Data synced successfully! woohoo\n\n${response.data}",
      ),
    );
  }
}
