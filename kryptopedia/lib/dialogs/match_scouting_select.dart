import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/screens/match_scouting_boxes.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/matches.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class ScoutMatchSelectionDialog extends StatefulWidget {
  const ScoutMatchSelectionDialog({super.key});

  @override
  State<ScoutMatchSelectionDialog> createState() =>
      _ScoutMatchSelectionDialogState();
}

class _ScoutMatchSelectionDialogState extends State<ScoutMatchSelectionDialog> {
  late ScoutMatchOption _selectedMatch;
  late String _selectedScouter;
  late Future<FutureResponse> data;
  AlliancePosition _selectedPosition = AlliancePosition.values.first;
  late Team _selectedTeam;
  bool noMatches = false;

  DbEvents dbEvents = DbEvents();

  Future<FutureResponse> _future() async {
    DbScoutedMatches dbScoutedMatches = DbScoutedMatches();
    DbMatches dbMatches = DbMatches();
    DbTeams dbTeams = DbTeams();

    Event event = await dbEvents.getEvent();
    List<Team> teams = await dbTeams.getTeams();
    List<EventMatch> matches = await dbMatches.getQualificationMatches();
    List<ScoutedMatch> scoutedMatches = await dbScoutedMatches
        .getScoutedMatches();

    List<ScoutMatchOption> options = [];
    for (EventMatch match in matches) {
      Map<AlliancePosition, Team> matchTeams = {
        AlliancePosition.blue1: teams.firstWhere(
          (t) => t.number == match.blue1number,
        ),
        AlliancePosition.blue2: teams.firstWhere(
          (t) => t.number == match.blue2number,
        ),
        AlliancePosition.blue3: teams.firstWhere(
          (t) => t.number == match.blue3number,
        ),
        AlliancePosition.red1: teams.firstWhere(
          (t) => t.number == match.red1number,
        ),
        AlliancePosition.red2: teams.firstWhere(
          (t) => t.number == match.red2number,
        ),
        AlliancePosition.red3: teams.firstWhere(
          (t) => t.number == match.red3number,
        ),
      };
      Map<AlliancePosition, bool> scouted = matchTeams.map(
        (position, team) => MapEntry(
          position,
          scoutedMatches.any(
            (sm) =>
                sm.teamNumber == team.number &&
                sm.matchNumber == match.number &&
                sm.matchCompLevel == match.compLevel,
          ),
        ),
      );
      options.add(
        ScoutMatchOption(match: match, teams: matchTeams, scouted: scouted),
      );
    }

    if (options.isEmpty) {
      noMatches = true;
      return FutureResponse(matches: [], scouters: []);
    }

    if (event.defaultAlliancePosition != null) {
      _selectedPosition = event.defaultAlliancePosition!;
    }

    int selectedIndex = options.indexWhere(
      (option) => !(option.scouted[_selectedPosition] ?? false),
    );
    if (selectedIndex == -1) {
      selectedIndex = 0;
    }

    _selectedMatch = options[selectedIndex];

    _selectedTeam =
        _selectedMatch.teams[_selectedPosition] ??
        _selectedMatch.teams.values.first;

    DbTeamMembers dbTeamMembers = DbTeamMembers();
    List<TeamMember> teamMembers = await dbTeamMembers.getTeamMembers();

    _selectedScouter = event.lastScouter ?? teamMembers[0].id;

    return FutureResponse(scouters: teamMembers, matches: options);
  }

  @override
  void initState() {
    super.initState();
    data = _future();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        height: 500,
        width: 550,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Match Scouting",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Device.fontSize(context, 20.0, 30.0),
                ),
                maxLines: 1,
              ),
            ),
            FutureBuilder<FutureResponse>(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("ohhhh ${snapshot.error}");
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (noMatches &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Text("no matches ???");
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    spacing: 8,
                    children: <Widget>[
                      Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: AutoSizeText(
                          "Who's scouting?",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: Device.fontSize(context, 15.0, 25.0),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: _selectedScouter,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedScouter = newValue!;
                              dbEvents.updateLastScouter(_selectedScouter);
                            });
                          },
                          items: snapshot.data!.scouters
                              .map<DropdownMenuItem<String>>((
                                TeamMember scouter,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: scouter.id,
                                  child: SizedBox(
                                    width: Device.isTablet(context)
                                        ? 425.0
                                        : 225.0,
                                    child: AutoSizeText(
                                      scouter.name,
                                      style: TextStyle(
                                        fontSize: Device.fontSize(
                                          context,
                                          12.0,
                                          22.0,
                                        ),
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: AutoSizeText(
                          "Select a match to scout:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: Device.fontSize(context, 15.0, 25.0),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<ScoutMatchOption>(
                          value: _selectedMatch,
                          onChanged: (ScoutMatchOption? newValue) {
                            setState(() {
                              _selectedMatch = newValue!;
                              _selectedTeam =
                                  _selectedMatch.teams[_selectedPosition] ??
                                  _selectedMatch.teams.values.first;
                            });
                          },
                          items: snapshot.data!.matches
                              .map<DropdownMenuItem<ScoutMatchOption>>((
                                ScoutMatchOption match,
                              ) {
                                return DropdownMenuItem(
                                  value: match,
                                  child: SizedBox(
                                    width: Device.isTablet(context)
                                        ? 425.0
                                        : 225.0,
                                    child: AutoSizeText(
                                      match.match.name,
                                      style: TextStyle(
                                        fontSize: Device.fontSize(
                                          context,
                                          12.0,
                                          22.0,
                                        ),
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: AutoSizeText(
                          "Select a team:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: Device.fontSize(context, 15.0, 25.0),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<Team>(
                          value: _selectedTeam,
                          onChanged: (Team? newValue) {
                            setState(() {
                              _selectedTeam = newValue!;
                              final selectedEntry = _selectedMatch.teams.entries
                                  .firstWhere(
                                    (entry) => entry.value == newValue,
                                    orElse: () =>
                                        MapEntry(_selectedPosition, newValue),
                                  );
                              _selectedPosition = selectedEntry.key;
                              dbEvents.updateAlliancePosition(
                                _selectedPosition,
                              
                              );
                            });
                          },
                          items: _selectedMatch.teams.entries
                              .map<DropdownMenuItem<Team>>((entry) {
                                final position = entry.key;
                                final team = entry.value;
                                return DropdownMenuItem<Team>(
                                  value: team,
                                  child: SizedBox(
                                    width: Device.isTablet(context)
                                        ? 425.0
                                        : 225.0,
                                    child: AutoSizeText(
                                      "${position.name} - ${team.number} ${team.nickname}",
                                      style: TextStyle(
                                        fontWeight:
                                            (_selectedMatch.scouted[position] ??
                                                false)
                                            ? FontWeight.w200
                                            : FontWeight.normal,
                                        fontSize: Device.fontSize(
                                          context,
                                          12.0,
                                          22.0,
                                        ),
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_selectedMatch.scouted[_selectedPosition] ??
                                false) {
                              bool? confirmation = await showDialog(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  title: "Already Scouted",
                                  body:
                                      "This team has already been scouted for this match. Are you sure you want to scout them again?",
                                ),
                              );
                              if (confirmation != true) {
                                return;
                              }
                            }

                            if (!context.mounted) return;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchScoutingBoxesEdition(
                                  alliancePosition: _selectedPosition,
                                  match: _selectedMatch.match,
                                  team: _selectedTeam,
                                  scouter: snapshot.data!.scouters.firstWhere(
                                    (s) => s.id == _selectedScouter,
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[500],
                          ),
                          child: Text(
                            "Scout Match",
                            style: TextStyle(
                              fontSize: Device.fontSize(context, 15.0, 25.0),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FutureResponse {
  final List<ScoutMatchOption> matches;
  final List<TeamMember> scouters;

  FutureResponse({required this.matches, required this.scouters});
}

class ScoutMatchOption {
  final Map<AlliancePosition, Team> teams;
  final Map<AlliancePosition, bool> scouted;
  final EventMatch match;

  ScoutMatchOption({
    required this.teams,
    required this.scouted,
    required this.match,
  });
}
