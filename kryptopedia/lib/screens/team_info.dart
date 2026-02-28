import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/team_info/team_chooser.dart';
import 'package:kryptopedia/widgets/team_info/match_info.dart';
import 'package:kryptopedia/widgets/team_info/pit_info.dart';
import 'package:kryptopedia/widgets/team_info/comments.dart';

class TeamInfo extends StatefulWidget {
  final int passedTeamID;
  const TeamInfo({super.key, required this.passedTeamID});

  @override
  State<TeamInfo> createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  final ValueNotifier<int> _teamChangedNotifier = ValueNotifier<int>(0);

  List<Event> _eventList = [];
  List<Team> _teamList = [];

  List<ScoutedMatch> scoutedMatches = [];
  ScoutedPit? scoutedPit = ScoutedPit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Kryptopedia - Team Information",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
      ),
      body: ValueListenableBuilder<int>(
        builder: (BuildContext context, int value, Widget? child) {
          return FutureBuilder<bool>(
            future: retrieveInformation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    TeamInfoChooser(
                      teamList: _teamList,
                      teamChangedNotifier: _teamChangedNotifier,
                    ),
                    Expanded(
                      child: ListView(
                        addAutomaticKeepAlives: true,
                        children: [
                          TeamInfoMatches(scoutedMatches: scoutedMatches),
                          TeamInfoPitInfo(
                            scoutedPit: scoutedPit,
                            team: _teamList.firstWhere(
                              (team) =>
                                  team.number == _teamChangedNotifier.value,
                            ),
                          ),
                          TeamInfoComments(
                            scoutedMatches: scoutedMatches,
                            scoutedPit: scoutedPit,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          );
        },
        valueListenable: _teamChangedNotifier,
      ),
    );
  }

  Future<bool> retrieveInformation() async {
    // Retrieve list of sorted list of teams at the event.  If a specific team was passed,
    // generate a list with only that team as it's content.
    if (_teamList.isEmpty) {
      DbTeams dbTeams = DbTeams();
      _teamList = await dbTeams.getTeams();

      if (widget.passedTeamID != -1) {
        List<Team> tempTeamList = [];

        for (Team team in _teamList) {
          if (team.number == widget.passedTeamID) {
            tempTeamList.add(team);
            break;
          }
        }

        _teamList = tempTeamList.map((v) => v).toList();
      } else {
        _teamList.sort((a, b) => a.number.compareTo(b.number));
      }
    }

    if (_teamChangedNotifier.value == 0) {
      _teamChangedNotifier.value = _teamList[0].number;
    }

    // Grab all of the scouted matches for requested team.
    DbScoutedMatches dbScoutedMatches = DbScoutedMatches();
    scoutedMatches = await dbScoutedMatches.getScoutedMatchesForTeam(
      _teamChangedNotifier.value,
    );

    scoutedMatches.sort((a, b) => a.matchNumber.compareTo(b.matchNumber));

    // Grab the Scouted Pit information
    DbScoutedPits dbScoutedPits = DbScoutedPits();
    scoutedPit = await dbScoutedPits.getScoutedPit(_teamChangedNotifier.value);

    return true;
  }
}
