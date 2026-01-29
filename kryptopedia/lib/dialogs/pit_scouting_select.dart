import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/screens/pit_scouting.dart';

import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
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
  late Future<List<Team>?> teams;

  Future<List<Team>?> _getTeamList() async {
    DbScoutedPits dbScoutedPits = DbScoutedPits();

    List<Team> teams = await dbTeams.getTeams();

    final results = await Future.wait(
      teams.map((t) async {
        final pit = await dbScoutedPits.getScoutedPit(t.number);
        return pit == null ? t : null;
      }),
    );
    teams = results.whereType<Team>().toList();

    _selectedTeam = teams[0].number;

    return teams;
  }

  @override
  void initState() {
    super.initState();
    teams = _getTeamList();
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
            FutureBuilder<List<Team>?>(
              future: teams,
              builder: (context, snapshot) {
                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Text("no teams left to scout!");
                }
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.hasError) return Text("${snapshot.error}");
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: AutoSizeText(
                              "Select a team to scout:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: Device.fontSize(context, 15.0, 25.0),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
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
                          items: snapshot.data!.map<DropdownMenuItem<int>>((
                            Team team,
                          ) {
                            return DropdownMenuItem<int>(
                              value: team.number,
                              child: SizedBox(
                                width: Device.isTablet(context) ? 425.0 : 225.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                  ),
                                  child: AutoSizeText(
                                    "  ${team.number} - ${team.nickname}  ",
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
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PopScope(
                                  canPop: false,
                                  child: PitScouting(
                                    team: snapshot.data!.firstWhere(
                                      (t) => t.number == _selectedTeam,
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
