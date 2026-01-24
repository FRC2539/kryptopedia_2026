/*
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia_2025/dialogs/confirmation.dart';
import 'package:kryptopedia_2025/screens/match_scouting_boxes.dart';

import 'package:kryptopedia_2025/util/dbhelpers/dbhelper.dart';
import 'package:kryptopedia_2025/util/dbhelpers/dbappinfo.dart';
import 'package:kryptopedia_2025/util/dbhelpers/dbevents.dart';
import 'package:kryptopedia_2025/util/dbhelpers/dbmatch.dart';
import 'package:kryptopedia_2025/util/dbhelpers/dbscoutedmatch.dart';
import 'package:kryptopedia_2025/util/dbhelpers/dbteams.dart';
import 'package:kryptopedia_2025/util/deviceinfo.dart';

import 'package:kryptopedia_2025/models/appinfo.dart';
import 'package:kryptopedia_2025/models/event.dart';
import 'package:kryptopedia_2025/models/match.dart';
import 'package:kryptopedia_2025/models/team.dart';

import 'package:kryptopedia_2025/screens/match_scouting.dart';

class ScoutedMatchSelectionDialog extends StatefulWidget {
  const ScoutedMatchSelectionDialog({super.key});

  @override
  State<ScoutedMatchSelectionDialog> createState() =>
      _ScoutedMatchSelectionDialogState();
}

class _ScoutedMatchSelectionDialogState
    extends State<ScoutedMatchSelectionDialog> {
  var dbHelper = DbHelper();
  var dbAppInfo = DbAppInfo();
  var dbEvent = DbEvent();
  var dbMatch = DbMatch();
  var dbScoutedMatch = DbScoutedMatch();
  var dbTeam = DbTeam();

  List<Match> _matchList = [];

  final List<String> _alliancePositions = [
    'Blue 1',
    'Blue 2',
    'Blue 3',
    'Red 1',
    'Red 2',
    'Red 3'
  ];

  int? _selectedEvent;
  int? _selectedMatch;
  int? _selectedTeam;
  String? _selectedAlliancePosition;

  //-----------------------------------------------------------------------------
  Future<bool> _getMatchList() async {
    if (_selectedEvent == null) {
      var activeEvents = await dbEvent.getActiveEvents();

      activeEvents.sort((a, b) => a.name.compareTo(b.name));

      _selectedEvent = activeEvents[0].id;
    }

    // Pull application defaults from database
    AppInfo appInfo = await dbAppInfo.getAppInfo();

    if (_selectedAlliancePosition == null) {
      _selectedAlliancePosition = appInfo.defaultAlliancePosition;
    } else {
      await dbAppInfo.updateAlliancePosition(_selectedAlliancePosition!);
    }

    // Get Match Information
    if (_selectedMatch == null) {
      _matchList = [];
      List<Match> tempMatchList =
          await dbMatch.getMatchesAtEvent(_selectedEvent!);

      for (var match in tempMatchList) {
        if (match.name.indexOf("Q") == 0) {
          int teamID;

          switch (_selectedAlliancePosition) {
            case "Blue 1":
              teamID = match.blue1teamid;
              break;
            case "Blue 2":
              teamID = match.blue2teamid;
              break;
            case "Blue 3":
              teamID = match.blue3teamid;
              break;
            case "Red 1":
              teamID = match.red1teamid;
              break;
            case "Red 2":
              teamID = match.red2teamid;
              break;
            default:
              teamID = match.red3teamid;
              break;
          }

          if (!(await dbScoutedMatch.existsScoutedMatchWithTeam(
              match.id, teamID))) {
            _matchList.add(match);
          }
        }
      }

      _matchList.sort((a, b) {
        int matchid1 = int.parse(a.name.split(" ")[2]);
        int matchid2 = int.parse(b.name.split(" ")[2]);

        return (matchid1).compareTo(matchid2);
      });

      if (_matchList.isNotEmpty) {
        bool matchFound = false;
        for (int i = _matchList.length - 1; i > 0 && !matchFound; i--) {
          int matchid1 = int.parse(_matchList[i].name.split(" ")[2]);
          int matchid2 = int.parse(_matchList[i - 1].name.split(" ")[2]);

          if (matchid2 + 1 != matchid1) {
            matchFound = true;
            _selectedMatch = _matchList[i].id;
          }
        }

        if (!matchFound) {
          _selectedMatch = _matchList[0].id;
        }
      } else {
        _selectedMatch = null;
      }
    }

    return true;
  }

  //-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        height: 600,
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Match Scouting",
                textAlign: TextAlign.left,
                style:
                    TextStyle(fontSize: Device.fontSize(context, 20.0, 30.0)),
                maxLines: 1,
              ),
            ),
            FutureBuilder(
                future: _getMatchList(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 40.0, 0.0, 5.0),
                                  child: AutoSizeText(
                                    "Select an Alliance Member:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: Device.fontSize(
                                            context, 15.0, 25.0)),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: DropdownButton<String>(
                              value: _selectedAlliancePosition,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedAlliancePosition = newValue!;
                                  _selectedMatch = null;
                                });
                              },
                              items: _alliancePositions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: AutoSizeText(
                                          "   $value   ",
                                          style: TextStyle(
                                            fontSize: Device.fontSize(
                                                context, 15.0, 20.0),
                                            // color: (value.indexOf("B") == 0) ? Colors.blue : Colors.red,
                                          ),
                                          maxLines: 1,
                                        )));
                              }).toList(),
                            ),
                          ),
                          (_matchList.isNotEmpty)
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 40.0, 0.0, 5.0),
                                        child: AutoSizeText(
                                          "Select a match:",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: Device.fontSize(
                                                  context, 15.0, 25.0)),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          (_matchList.isNotEmpty)
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: DropdownButton<int>(
                                    value: _selectedMatch,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        _selectedMatch = newValue;
                                      });
                                    },
                                    items: _matchList
                                        .map<DropdownMenuItem<int>>(
                                            (Match match) {
                                      return DropdownMenuItem<int>(
                                          value: match.id,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: AutoSizeText(
                                                (_selectedAlliancePosition ==
                                                        "Blue 1")
                                                    ? "   ${match.name} - ${match.blue1teamid}"
                                                    : (_selectedAlliancePosition ==
                                                            "Blue 2")
                                                        ? "   ${match.name} - ${match.blue2teamid}"
                                                        : (_selectedAlliancePosition ==
                                                                "Blue 3")
                                                            ? "   ${match.name} - ${match.blue3teamid}"
                                                            : (_selectedAlliancePosition ==
                                                                    "Red 1")
                                                                ? "   ${match.name} - ${match.red1teamid}"
                                                                : (_selectedAlliancePosition ==
                                                                        "Red 2")
                                                                    ? "   ${match.name} - ${match.red2teamid}"
                                                                    : "   ${match.name} - ${match.red3teamid}",
                                                style: TextStyle(
                                                    fontSize: Device.fontSize(
                                                        context, 15.0, 20.0)),
                                                maxLines: 1,
                                              )));
                                    }).toList(),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                    );
                  }
                }),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  MatchScoutingSelections selections = await getSelectedTeam();

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PopScope(
                          canPop: false,
                          child: MatchScouting(
                            team: selections.team,
                            event: selections.event,
                            match: selections.match,
                            alliancePosition: _selectedAlliancePosition!,
                          ),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[500],
                ),
                child: AutoSizeText(
                  "Scout Match",
                  style: TextStyle(
                    fontSize: Device.fontSize(context, 15.0, 25.0),
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  String? confirmation = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => ConfirmationDialog(
                            title: "SUPER SPECIAL MATCH SCOUTING BOXES EDITION",
                            body:
                                "its brand new and might be broken and/or confusing so check with dominic before using it",
                            confirmText: "sir yes sir",
                          ));
                  if (confirmation == null) {
                    return;
                  }
                  Navigator.pop(context);
                  MatchScoutingSelections selections = await getSelectedTeam();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MatchScoutingBoxesEdition(
                              selections: selections,
                              alliancePosition: _selectedAlliancePosition!)));
                },
                icon: Icon(Icons.grid_on))
          ],
        ),
      ),
    );
  }

  Future<MatchScoutingSelections> getSelectedTeam() async {
    Event event = await dbEvent.getEvent(_selectedEvent!);
    Match match = await dbMatch.getMatch(_selectedMatch!);

    switch (_selectedAlliancePosition) {
      case "Blue 1":
        _selectedTeam = match.blue1teamid;
        break;
      case "Blue 2":
        _selectedTeam = match.blue2teamid;
        break;
      case "Blue 3":
        _selectedTeam = match.blue3teamid;
        break;
      case "Red 1":
        _selectedTeam = match.red1teamid;
        break;
      case "Red 2":
        _selectedTeam = match.red2teamid;
        break;
      default:
        _selectedTeam = match.red3teamid;
        break;
    }

    Team team = await dbTeam.getTeam(_selectedTeam!);
    return MatchScoutingSelections(team: team, event: event, match: match);
  }
}

class MatchScoutingSelections {
  final Team team;
  final Event event;
  final Match match;

  const MatchScoutingSelections(
      {required this.team, required this.event, required this.match});
}
*/