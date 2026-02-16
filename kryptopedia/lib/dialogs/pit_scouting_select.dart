import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/screens/pit_scouting.dart';

import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class ScoutPitSelectionDialog extends StatefulWidget {
  const ScoutPitSelectionDialog({super.key});

  @override
  State<ScoutPitSelectionDialog> createState() =>
      _ScoutPitSelectionDialogState();
}

class _ScoutPitSelectionDialogState extends State<ScoutPitSelectionDialog> {
  DbEvents dbEvents = DbEvents();
  DbTeams dbTeams = DbTeams();

  late int _selectedTeam;
  late String _selectedScouter;
  late Future<FutureResponse> data;
  bool noTeams = false;

  Future<FutureResponse> _future() async {
    DbScoutedPits dbScoutedPits = DbScoutedPits();

    List<Team> teams = await dbTeams.getTeams();

    final teamsWithScoutedPits = await Future.wait(
      teams.map((t) async {
        final pit = await dbScoutedPits.getScoutedPit(t.number);
        return pit == null ? t : null;
      }),
    );
    teams = teamsWithScoutedPits.whereType<Team>().toList();

    if (teams.isEmpty) {
      noTeams = true;
      return FutureResponse(teams: [], scouters: []);
    }

    _selectedTeam = teams[0].number;

    DbTeamMembers dbTeamMembers = DbTeamMembers();
    List<TeamMember> teamMembers = await dbTeamMembers.getTeamMembers();

    _selectedScouter = teamMembers[0].id;

    return FutureResponse(teams: teams, scouters: teamMembers);
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
        height: 350,
        width: 550,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Pit Scouting",
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
                if (snapshot.hasError) return Text("${snapshot.error}");
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (noTeams &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Text("no teams left to scout!");
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
                      Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: AutoSizeText(
                          "Select a team to scout:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: Device.fontSize(context, 15.0, 25.0),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<int>(
                          value: _selectedTeam,
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedTeam = newValue!;
                            });
                          },
                          items: snapshot.data!.teams
                              .map<DropdownMenuItem<int>>((Team team) {
                                return DropdownMenuItem<int>(
                                  value: team.number,
                                  child: SizedBox(
                                    width: Device.isTablet(context)
                                        ? 425.0
                                        : 225.0,
                                    child: AutoSizeText(
                                      "${team.number} - ${team.nickname}",
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
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PopScope(
                                  canPop: false,
                                  child: PitScouting(
                                    team: snapshot.data!.teams.firstWhere(
                                      (t) => t.number == _selectedTeam,
                                    ),
                                    scouter: snapshot.data!.scouters.firstWhere(
                                      (s) => s.id == _selectedScouter,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[500],
                          ),
                          child: Text(
                            "Scout Pit",
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
  final List<Team> teams;
  final List<TeamMember> scouters;

  FutureResponse({required this.teams, required this.scouters});
}
