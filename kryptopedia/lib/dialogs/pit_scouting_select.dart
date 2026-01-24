/*
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/screens/pit_scouting.dart';

import 'package:kryptopedia/util/dbhelpers/dbhelper.dart';
import 'package:kryptopedia/util/dbhelpers/dbevents.dart';
import 'package:kryptopedia/util/dbhelpers/dbeventteam.dart';
import 'package:kryptopedia/util/dbhelpers/dbscoutedpit.dart';
import 'package:kryptopedia/util/dbhelpers/dbteams.dart';

import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class ScoutPitSelectionDialog extends StatefulWidget {
  const ScoutPitSelectionDialog({super.key});

  @override
  State<ScoutPitSelectionDialog> createState() =>
      _ScoutPitSelectionDialogState();
}

class _ScoutPitSelectionDialogState extends State<ScoutPitSelectionDialog> {
  var dbHelper = DbHelper();
  var dbEvent = DbEvent();
  var dbEventTeam = DbEventTeam();
  var dbTeam = DbTeam();

  int _selectedEvent = -1;
  int _selectedTeam = -1;

  List<Team> _teamList = [];

  //-----------------------------------------------------------------------------
  Future<bool> _getTeamList() async {
    var activeEvents = await dbEvent.getActiveEvents();

    activeEvents.sort((a, b) => a.name.compareTo(b.name));

    _selectedEvent = activeEvents[0].id;

    DbScoutedPit dbScoutPit = DbScoutedPit();

    _teamList = [];

    List<Team> tempTeamList = await dbEventTeam.getTeamsAtEvent(_selectedEvent);

    for (var teamInfo in tempTeamList) {
      if (!(await dbScoutPit.existsScoutedPit(
          _selectedEvent, teamInfo.teamnumber))) {
        _teamList.add(teamInfo);
      }
    }

    _teamList.sort((a, b) => a.teamnumber.compareTo(b.teamnumber));

    if (_selectedTeam == -1) {
      _selectedTeam = _teamList[0].teamnumber;
    }

    return true;
  }

  //----------------------------------------------------------------------------

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
                style:
                    TextStyle(fontSize: Device.fontSize(context, 20.0, 30.0)),
                maxLines: 1,
              ),
            ),
            FutureBuilder(
                future: _getTeamList(),
                builder: (context, snapshot) {
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
                                    fontSize:
                                        Device.fontSize(context, 15.0, 25.0)),
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
                            items: _teamList
                                .map<DropdownMenuItem<int>>((Team team) {
                              return DropdownMenuItem<int>(
                                  value: team.teamnumber,
                                  child: SizedBox(
                                      width: Device.isTablet(context)
                                          ? 425.0
                                          : 225.0,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: AutoSizeText(
                                            "  ${team.teamnumber} - ${team.nickname}  ",
                                            style: TextStyle(
                                                fontSize: Device.fontSize(
                                                    context, 12.0, 22.0)),
                                            maxLines: 2,
                                          ))));
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Event event = await dbEvent.getEvent(_selectedEvent);
                  Team team = await dbTeam.getTeam(_selectedTeam);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PopScope(
                          canPop: false,
                          child: PitScouting(
                            team: team,
                            event: event,
                          ),
                        ),
                      ),
                    );
                  }
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
            )
          ],
        ),
      ),
    );
  }
}
*/