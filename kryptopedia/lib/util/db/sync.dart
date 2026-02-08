import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/notification.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';

Future<String?> syncData() async {
  DbEvents dbEvents = DbEvents();
  Event event = await dbEvents.getEvent();

  if (!event.syncEnabled) return null;

  List<SyncDataItem> dataToPush = [];

  DbScoutedPits dbScoutedPits = DbScoutedPits();

  List<ScoutedPit> scoutedPits = await dbScoutedPits.getLocalScoutedPits();
  dataToPush.addAll(scoutedPits.map((s) => s.toSyncDataItem()));

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

  //mark successful pushes
  Future.wait(
    scoutedPits.map((s) => dbScoutedPits.markScoutedPitSynced(s.uid)),
  );

  DateTime syncedTo = DateTime.parse(pulledData.data["synced_to"]);
  List<dynamic> items = pulledData.data["items"];

  DbTeams dbTeams = DbTeams();
  DbTeamMembers dbTeamMembers = DbTeamMembers();

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

      if (type == "scouted_pit") {
        if (deleted) {
          dbScoutedPits.deleteScoutedPit(item["data"]["uid"]);
          continue;
        }
        ScoutedPit scoutedPit = ScoutedPit.fromMap(item["data"]);
        await dbScoutedPits.upsertScoutedPit(scoutedPit);
      }

    } catch (e) {
      return "an error!: $e \n on item: $item";
    }
  }

  await dbEvents.updateSyncTime(syncedTo);
  return null;
}

Future syncDataFlow(BuildContext context) async {
  String? error = await syncData();
  if (error != null) {
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (context) =>
          NotificationDialog(title: "Sync Error", body: error),
    );
  } else {
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (context) => NotificationDialog(
        title: "Sync Complete",
        body: "Data synced successfully! woohoo",
      ),
    );
  }
}
