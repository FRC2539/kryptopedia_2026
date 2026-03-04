import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/alliance_selection_team.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/tba_ranking.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/widgets/alliance_selection/alliance_picks.dart';
import 'package:kryptopedia/widgets/alliance_selection/available_teams.dart';
import 'package:kryptopedia/widgets/team_metrics/matrix.dart';

class AllianceSelection extends StatefulWidget {
  const AllianceSelection({super.key});

  @override
  State<AllianceSelection> createState() => _AllianceSelectionState();
}

class _AllianceSelectionState extends State<AllianceSelection> {
  DbTeams dbTeams = DbTeams();

  int _activeAlliance = 1;
  final int _numberOfTeamsPerAlliance = 3;

  String teamSort = "rank";
  List<Team> teamsAtEvent = [];
  List<AllianceSelectionEventTeam> eventTeams = [];
  List<AllianceSelectionEventTeam> availableTeams = [];
  List<Container> selectableTeams = [];
  Map<String, List<int>> teamFlags = {};
  List<String> activeFlags = [];
  List<int> filteredTeamList = [];

  List<AllianceTeam> allianceTeams = [
    AllianceTeam(),
    AllianceTeam(),
    AllianceTeam(),
    AllianceTeam(),
    AllianceTeam(),
    AllianceTeam(),
    AllianceTeam(),
    AllianceTeam(),
  ];

  List<Widget> allAlliances = [];
  List<Widget> allianceButtons = [];

  ValueNotifier<TeamsToShow> teamsToShowNotifier = ValueNotifier<TeamsToShow>(
    TeamsToShow.init([], false),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Kryptopedia - Alliance Selection",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
      ),
      body: FutureBuilder(
        future: getTeamList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 5.0,
                              right: 10.0,
                              left: 10.0,
                            ),
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              right: 20.0,
                              left: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(width: 1.0),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            child: SizedBox(
                              height: 320.0,
                              width: 250.0,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          "Alliance Picks",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontSize: Device.fontHeader2(
                                              context,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 30.0),
                                        GestureDetector(
                                          onTap: () {
                                            if (allianceTeams[_activeAlliance -
                                                    1]
                                                .alliancePartners
                                                .isNotEmpty) {
                                              setState(() {
                                                // Mark the team as not picked.
                                                bool itemFound = false;
                                                for (
                                                  int i = 0;
                                                  i < eventTeams.length &&
                                                      !itemFound;
                                                  i++
                                                ) {
                                                  if (eventTeams[i]
                                                          .team
                                                          .number ==
                                                      allianceTeams[_activeAlliance -
                                                              1]
                                                          .alliancePartners
                                                          .last) {
                                                    eventTeams[i].picked =
                                                        false;
                                                    itemFound = true;
                                                  }
                                                }

                                                // Remove the team from the alliance
                                                allianceTeams[_activeAlliance -
                                                        1]
                                                    .alliancePartners
                                                    .removeLast();

                                                // Trigger an updates of the Metrics table
                                                teamsToShowNotifier.value =
                                                    TeamsToShow.init(
                                                      getListOfTeamsToDisplay(),
                                                      activeFlags.isNotEmpty,
                                                    );
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 50.0,
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              border: Border.all(width: 1.0),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(25.0),
                                                  ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: const AutoSizeText(
                                                    'UNDO',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(children: allAlliances),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 330.0,
                              margin: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 5.0,
                                right: 10.0,
                                left: 10.0,
                              ),
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                                right: 0.0,
                                left: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(width: 1.0),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    "Available Teams",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: Device.fontHeader2(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                        ),
                                        child: AutoSizeText(
                                          "Sort Filter:",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Device.fontTable(context),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (teamSort != "rank") {
                                            setState(() {
                                              teamSort = "rank";
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (teamSort == "rank")
                                                ? Colors.orange.shade100
                                                : Colors.black,
                                            border: Border.all(width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                          ),
                                          child: AutoSizeText(
                                            "Team Rank",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: (teamSort == "rank")
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: Device.fontTable(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (teamSort != "team_number") {
                                            setState(() {
                                              teamSort = "team_number";
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (teamSort == "team_number")
                                                ? Colors.orange.shade100
                                                : Colors.black,
                                            border: Border.all(width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                          ),
                                          child: AutoSizeText(
                                            "Team Number",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: (teamSort == "team_number")
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: Device.fontTable(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ListView(
                                        children: selectableTeams,
                                      ),
                                    ),
                                  ),
                                  AutoSizeText(
                                    "Single Tap = Add team to highlighted alliance  |  Double Tap = Toggle Do Not Pick",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Device.fontTable(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 0.0,
                          right: 10.0,
                          left: 10.0,
                        ),
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          bottom: 5.0,
                          right: 20.0,
                          left: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 1.0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100.0,
                              child: AutoSizeText(
                                "Team Flags:",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 50.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: teamFlags.entries.map((entry) {
                                    String key = entry.key;
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              (activeFlags.contains(key))
                                              ? Colors.orange.shade300
                                              : Colors.black,
                                          side: BorderSide(
                                            width: 2.0,
                                            color: Colors.orange.shade300,
                                          ),
                                        ),
                                        child: AutoSizeText(
                                          key,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: (activeFlags.contains(key))
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            (!activeFlags.contains(key))
                                                ? activeFlags.add(key)
                                                : activeFlags.remove(key);

                                            // Trigger an update of the Team Metrics table
                                            teamsToShowNotifier.value =
                                                TeamsToShow.init(
                                                  getListOfTeamsToDisplay(),
                                                  activeFlags.isNotEmpty,
                                                );
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TeamMetricsMatrix(teamstoShowNotifer: teamsToShowNotifier),
                ],
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }

  // -----------------------------------------------------------------------------
  Future<bool> getTeamList() async {
    // Retrieve the teams at the event
    if (eventTeams.isEmpty) {
      teamsAtEvent = await dbTeams.getTeams();

      for (Team team in teamsAtEvent) {
        // Retrieve Event Rankings
        DbEventRanking dbEventRanking = DbEventRanking();
        int? ranking = await dbEventRanking.getTeamRanking(team.number);

        eventTeams.add(
          AllianceSelectionEventTeam(
            team,
            (ranking != null) ? ranking : 0,
            false,
            false,
          ),
        );
      }
    }

    // Sort the available teams
    if (teamSort == "rank") {
      eventTeams.sort((a, b) {
        return (a.rank).compareTo(b.rank);
      });
    } else {
      eventTeams.sort((a, b) {
        return (a.team.number).compareTo(b.team.number);
      });
    }

    // Create the list of available teams
    availableTeams = [];
    for (int i = 0; i < eventTeams.length; i++) {
      if (!eventTeams[i].picked) {
        availableTeams.add(eventTeams[i]);
      }
    }

    // Create the list of teams shown within the UI
    selectableTeams = [];
    for (int i = 0; i < availableTeams.length; i += 7) {
      List<Widget> selectionCells = [];
      for (int j = i; j < availableTeams.length && j < i + 7; j++) {
        if (j % 7 != 0) selectionCells.add(const SizedBox(width: 10.0));
        selectionCells.add(
          AvailableTeams(
            rank: availableTeams[j].rank,
            teamId: availableTeams[j].team.number,
            doNotPick: availableTeams[j].doNotPick,
            singleTapCallback: (int newValue) {
              if (!availableTeams[j].doNotPick &&
                  allianceTeams[_activeAlliance - 1].alliancePartners.length <
                      _numberOfTeamsPerAlliance) {
                setState(() {
                  // Mark the team as picked.
                  bool itemFound = false;
                  for (int i = 0; i < eventTeams.length && !itemFound; i++) {
                    if (eventTeams[i].team.number == newValue) {
                      eventTeams[i].picked = true;
                      itemFound = true;
                    }
                  }

                  // Update the alliance
                  allianceTeams[_activeAlliance - 1].alliancePartners.add(
                    newValue,
                  );

                  // Trigger an update of the Team Metrics table
                  teamsToShowNotifier.value = TeamsToShow.init(
                    getListOfTeamsToDisplay(),
                    activeFlags.isNotEmpty,
                  );
                });
              }
            },
            doubleTapCallback: (int newValue) {
              setState(() {
                // Toggle the DoNotPick setting for team
                bool itemFound = false;
                for (int i = 0; i < eventTeams.length && !itemFound; i++) {
                  if (eventTeams[i].team.number == newValue) {
                    eventTeams[i].doNotPick = !eventTeams[i].doNotPick;
                    itemFound = true;
                  }
                }

                // Trigger an update of the Team Metrics table
                teamsToShowNotifier.value = TeamsToShow.init(
                  getListOfTeamsToDisplay(),
                  activeFlags.isNotEmpty,
                );
              });
            },
          ),
        );
      }

      // Add the cells to the container list
      selectableTeams.add(
        Container(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: selectionCells,
          ),
        ),
      );
    }

    // Create the list of Alliances
    allAlliances = [];

    for (int i = 0; i < allianceTeams.length; i++) {
      allAlliances.add(
        AlliancePicks(
          currentAlliance: i + 1,
          activeAlliance: _activeAlliance == i + 1,
          allianceInfo: allianceTeams[i],
          numberTeamsPerAlliance: _numberOfTeamsPerAlliance,
          singleTapCallback: (int newValue) {
            if (newValue != _activeAlliance) {
              setState(() {
                _activeAlliance = newValue;
              });
            }
          },
        ),
      );

      allAlliances.add(const SizedBox(height: 10.0));
    }

    if (teamFlags.isEmpty) {
      DbTeamFlagApplications dbTeamFlagApplications = DbTeamFlagApplications();
      teamFlags = await dbTeamFlagApplications
          .getActiveTeamFlagApplicationsAsMap();
    }

    // Trigger an update of the Team Metrics table
    teamsToShowNotifier.value = TeamsToShow.init(
      getListOfTeamsToDisplay(),
      activeFlags.isNotEmpty,
    );

    return true;
  }

  List<int> getListOfTeamsToDisplay() {
    List<int> listOfTeamsPhase1 = [];
    List<int> listOfTeamsPhase2 = [];

    for (var eventTeam in eventTeams) {
      if (!eventTeam.picked && !eventTeam.doNotPick) {
        listOfTeamsPhase1.add(eventTeam.team.number);
      }
    }

    for (int teamNumber in listOfTeamsPhase1) {
      bool teamFound = true;
      teamFlags.forEach((key, value) {
        if (activeFlags.contains(key) && !value.contains(teamNumber)) {
          teamFound = false;
        }
      });
      if (teamFound) listOfTeamsPhase2.add(teamNumber);
    }

    return listOfTeamsPhase2;
  }
}
