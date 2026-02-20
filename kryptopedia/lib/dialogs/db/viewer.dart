import 'package:flutter/material.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';

class DbViewerDialog extends StatefulWidget {
  const DbViewerDialog({super.key});

  @override
  State<DbViewerDialog> createState() => _DbViewerDialogState();
}

class _DbViewerDialogState extends State<DbViewerDialog> {
  late Future<Map<String, List<dynamic>>> _data;
  String selectedTable = Event.tableName;

  List<DropdownMenuItem<String>> dropdownMenuEntries = [
    DropdownMenuItem(value: Event.tableName, child: Text("Events")),
    DropdownMenuItem(value: Team.tableName, child: Text("Teams")),
    DropdownMenuItem(value: ScoutedPit.tableName, child: Text("Scouted Pits")),
    DropdownMenuItem(value: TeamMember.tableName, child: Text("Team Members")),
    DropdownMenuItem(value: EventMatch.tableName, child: Text("Matches")),
    DropdownMenuItem(
      value: TeamFlagApplication.tableName,
      child: Text("Flag Applications"),
    ),
  ];

  Future<Map<String, List<dynamic>>> getData() async {
    Map<String, List<dynamic>> result = {};

    DbEvents dbEvents = DbEvents();
    Event event = await dbEvents.getEvent();
    result[Event.tableName] = [event];

    DbTeams dbTeams = DbTeams();
    List<Team> teams = await dbTeams.getTeams();
    result[Team.tableName] = teams;

    DbScoutedPits dbScoutedPits = DbScoutedPits();
    List<ScoutedPit> scoutedPits = await dbScoutedPits.getScoutedPits();
    result[ScoutedPit.tableName] = scoutedPits;

    DbTeamMembers dbTeamMembers = DbTeamMembers();
    List<TeamMember> teamMembers = await dbTeamMembers.getTeamMembers();
    result[TeamMember.tableName] = teamMembers;

    DbMatches dbMatches = DbMatches();
    List<EventMatch> matches = await dbMatches.getMatches();
    result[EventMatch.tableName] = matches;

    DbTeamFlagApplications dbFlagApplications = DbTeamFlagApplications();
    List<TeamFlagApplication> flagApplications = await dbFlagApplications
        .getTeamFlagApplications();
    result[TeamFlagApplication.tableName] = flagApplications;

    return result;
  }

  @override
  void initState() {
    super.initState();
    _data = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    items: dropdownMenuEntries,
                    onChanged: (value) => setState(() {
                      selectedTable = value!;
                    }),
                    initialValue: selectedTable,
                  ),
                ),
                Spacer(),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  List<dynamic> tableData = snapshot.data![selectedTable]!;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tableData.length,
                      itemBuilder: (context, index) {
                        switch (selectedTable) {
                          case Event.tableName:
                            Event event = tableData[index];
                            return ListTile(
                              title: Text("Event: ${event.name}"),
                              subtitle: Text(event.toMap().toString()),
                            );
                          case Team.tableName:
                            Team team = tableData[index];
                            return ListTile(
                              title: Text("Team: ${team.number}"),
                              subtitle: Text("Nickname: ${team.nickname}"),
                            );
                          case ScoutedPit.tableName:
                            ScoutedPit pit = tableData[index];
                            return ListTile(
                              title: Text(
                                "Scouted Pit - Team: ${pit.teamNumber}",
                              ),
                              subtitle: Text(pit.toMap().toString()),
                            );
                          case TeamMember.tableName:
                            TeamMember member = tableData[index];
                            return ListTile(
                              title: Text("Team Member: ${member.name}"),
                              subtitle: Text("ID: ${member.id}"),
                            );
                          case EventMatch.tableName:
                            EventMatch match = tableData[index];
                            return ListTile(
                              title: Text(
                                "Match: ${match.compLevel} ${match.number}",
                              ),
                              subtitle: Text(match.toMap().toString()),
                            );
                          case TeamFlagApplication.tableName:
                            TeamFlagApplication flagApplication =
                                tableData[index];
                            return ListTile(
                              title: Text(
                                "Flag Application - Team: ${flagApplication.teamNumber}, Flag: ${flagApplication.name}",
                              ),
                              subtitle: Text(
                                flagApplication.toMap().toString(),
                              ),
                            );
                          default:
                            return ListTile(title: Text("Unknown Table"));
                        }
                      },
                    ),
                  );
                } else {
                  return Text("No data available.");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
