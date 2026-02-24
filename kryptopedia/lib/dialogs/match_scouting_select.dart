import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/screens/match_scouting.dart';

import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/db/helper.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class ScoutedMatchSelectionDialog extends StatefulWidget {
  const ScoutedMatchSelectionDialog({super.key});

  @override
  State<ScoutedMatchSelectionDialog> createState() =>
      _ScoutedMatchSelectionDialogState();
}

final List<String> alliancePositions = [
  'Blue 1',
  'Blue 2',
  'Blue 3',
  'Red 1',
  'Red 2',
  'Red 3',
];

class _ScoutedMatchSelectionDialogState
    extends State<ScoutedMatchSelectionDialog> {
  var dbHelper = DbHelper();
  var dbEvent = DbEvents();
  var dbMatch = DbMatches();
  var dbScoutedMatch = DbScoutedMatches();
  var dbTeam = DbTeams();

  List<EventMatch> _matchList = [];

  int? selectedEvent;
  String? _selectedMatch;
  int? _selectedTeam;
  String? _selectedAlliancePosition;

  //-----------------------------------------------------------------------------
  Future<bool> _getMatchList() async {
      
    var selectedEvent = await dbEvent.getEvent();

    // Pull application defaults from database

    if (_selectedAlliancePosition == null) {
      _selectedAlliancePosition = selectedEvent.defaultAlliancePosition;
    } else {
      await dbEvent.updateAlliancePosition(_selectedAlliancePosition!);
    }

    // Get Match Information
    if (_selectedMatch == null) {
      _matchList = [];
      EventMatch tempMatch =
        (await dbMatch.getMatches()).first;

        if (tempMatch.number == 0) {
          int teamID;

          switch (_selectedAlliancePosition) {
            case "Blue 1":
              teamID = tempMatch.blue1number;
              break;
            case "Blue 2":
              teamID = tempMatch.blue2number;
              break;
            case "Blue 3":
              teamID = tempMatch.blue3number;
              break;
            case "Red 1":
              teamID = tempMatch.red1number;
              break;
            case "Red 2":
              teamID = tempMatch.red2number;
              break;
            default:
              teamID = tempMatch.red3number;
              break;
          }

        //  if (!(await dbScoutedMatch.existsScoutedMatchWithTeam(  <--- Still needs to be defined
        //      tempMatch.id, teamID))) {
        //    _matchList.add(tempMatch);
        //  }
        //}

      _matchList.sort((a, b) {
        int matchid1 = a.number;
        int matchid2 = b.number;

        return (matchid1).compareTo(matchid2);
      });

      if (_matchList.isNotEmpty) {
        bool matchFound = false;
        for (int i = _matchList.length - 1; i > 0 && !matchFound; i--) {
          int matchid1 = _matchList[i].number;
          int matchid2 = _matchList[i - 1].number;

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
                            items: alliancePositions
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
                                  child: DropdownButton<String>(
                                    value: _selectedMatch,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedMatch = newValue;
                                      });
                                    },
                                    items: _matchList
                                        .map<DropdownMenuItem<String>>(
                                            (EventMatch match) {
                                      return DropdownMenuItem<String>(
                                          value: match.id,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: AutoSizeText(
                                                (_selectedAlliancePosition ==
                                                        "Blue 1")
                                                    ? "   ${match.number} - ${match.blue1number}"
                                                    : (_selectedAlliancePosition ==
                                                            "Blue 2")
                                                        ? "   ${match.number} - ${match.blue2number}"
                                                        : (_selectedAlliancePosition ==
                                                                "Blue 3")
                                                            ? "   ${match.number} - ${match.blue3number}"
                                                            : (_selectedAlliancePosition ==
                                                                    "Red 1")
                                                                ? "   ${match.number} - ${match.red1number}"
                                                                : (_selectedAlliancePosition ==
                                                                        "Red 2")
                                                                    ? "   ${match.number} - ${match.red2number}"
                                                                    : "   ${match.number} - ${match.red3number}",
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

                  //placeholder before select menu is added
                  DbTeamMembers dbTeamMembers = DbTeamMembers();
                  TeamMember scouter =
                      (await dbTeamMembers.getTeamMembers()).first;

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PopScope(
                          canPop: false,
                          child: MatchScouting(
                            team: selections.team,
                            match: selections.match,
                            alliancePosition: _selectedAlliancePosition!,
                            scouter: scouter,
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
          ],
        ),
      ),
    );
  }

  Future<MatchScoutingSelections> getSelectedTeam() async {
    EventMatch match = (await dbMatch.getMatches()).first;

    switch (_selectedAlliancePosition) {
      case "Blue 1":
        _selectedTeam = match.blue1number;
        break;
      case "Blue 2":
        _selectedTeam = match.blue2number;
        break;
      case "Blue 3":
        _selectedTeam = match.blue3number;
        break;
      case "Red 1":
        _selectedTeam = match.red1number;
        break;
      case "Red 2":
        _selectedTeam = match.red2number;
        break;
      default:
        _selectedTeam = match.red3number;
        break;
    }

    Team team = await dbTeam.getTeam(_selectedTeam!);
    return MatchScoutingSelections(team: team, match: match);
  }
}

class MatchScoutingSelections {
  final Team team;
  final EventMatch match;

  const MatchScoutingSelections(
      {required this.team, required this.match});
}
