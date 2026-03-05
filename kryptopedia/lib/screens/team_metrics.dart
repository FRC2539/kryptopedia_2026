import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/eventinsights.dart';
import 'package:kryptopedia/models/eventranking.dart';
import 'package:kryptopedia/models/tba_event_insights.dart';
import 'package:kryptopedia/models/tba_event_ranking.dart';
import 'package:kryptopedia/models/tba_rankings.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/tba_insights.dart';
import 'package:kryptopedia/util/db/tba_ranking.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/team_metrics/matrix.dart';

class TeamMetrics extends StatefulWidget {
  const TeamMetrics({super.key});

  @override
  State<TeamMetrics> createState() => _TeamMetricsState();
}

class _TeamMetricsState extends State<TeamMetrics> {
  bool showFlags = false;
  bool importTBAInfo = false;

  int updateCount = 0;
  List<int> teams = [];

  List<String> activeFlags = [];
  Map<String, List<int>> teamFlags = {};

  ValueNotifier<TeamsToShow> teamsToShowNotifier = ValueNotifier<TeamsToShow>(
    TeamsToShow.init([], false),
  );
  ValueNotifier<int> tbaUpdateNotifier = ValueNotifier<int>(0);

  Future<List<Widget>> processActions(BuildContext context) async {
    DbTeams dbTeams = DbTeams();
    DbTeamFlagApplications dbTeamFlagApplications = DbTeamFlagApplications();

    List<Team> eventTeams = await dbTeams.getTeams();

    // If the teams to show is empty, add the list of teams at the event.
    if (teamsToShowNotifier.value.teams.isEmpty) {
      List<int> teams = [];
      for (Team team in eventTeams) {
        teams.add(team.number);
      }
      teamsToShowNotifier.value = TeamsToShow.init(teams, false);
    }

    // Check if we should be pulling TBA information
    if (importTBAInfo) {
      DbEvents dbEvents = DbEvents();
      Event activeEvent = (await dbEvents.getEvent());

      // Pull current rankings from the Blue Alliance
      APIResponse eventRankingResponse = await Api.getTBATeamRankings(
        activeEvent.code,
      );

      if (eventRankingResponse.success && eventRankingResponse.data != null) {
        // Create the table
        DbEventRanking dbEventRanking = DbEventRanking();
        await dbEventRanking.createEventRankingTable();

        // Decode the the response
        TBAEventRanking tbaEventRanking = TBAEventRanking.fromJson(
          eventRankingResponse.data,
        );

        for (TBARankings tbaRankings in tbaEventRanking.rankings) {
          await dbEventRanking.insertEventRanking(
            EventRanking(
              int.parse(tbaRankings.teamKey.substring(3)),
              tbaRankings.rank,
            ),
          );
        }
      }

      // Pull current rankings from the Blue Alliance
      APIResponse eventInsightsResponse = await Api.getTBATeamInsights(
        activeEvent.code,
      );

      if (eventInsightsResponse.success && eventInsightsResponse.data != null) {
        // Create the table
        DbEventInsights dbEventInsights = DbEventInsights();
        await dbEventInsights.createEventInsightsTable();

        // Decode the the response
        TBAEventInsights tbaEventInsights = TBAEventInsights.fromJson(
          eventInsightsResponse.data,
        );

        for (MapEntry<String, dynamic> oprsItem
            in tbaEventInsights.oprs.entries) {
          double oprsValue = oprsItem.value as double;
          double dprsValue = tbaEventInsights.dprs[oprsItem.key] as double;
          double ccwmsValue = tbaEventInsights.ccwms[oprsItem.key] as double;

          await dbEventInsights.insertEventInsights(
            EventInsights(
              int.parse(oprsItem.key.substring(3)),
              oprsValue,
              dprsValue,
              ccwmsValue,
            ),
          );
        }
      }

      SnackBar? snackBar;
      if (eventRankingResponse.success) {
        snackBar = SnackBar(
          content: Text(
            'TBA information successfully pulled.',
            style: TextStyle(fontSize: 16),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.greenAccent,
          showCloseIcon: true,
        );

        // Let the matrix know that potential changes to tba information have been made.
        tbaUpdateNotifier.value = 1;
      } else {
        snackBar = SnackBar(
          content: Text(
            'TBA information failed to be pulled.',
            style: TextStyle(fontSize: 16),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
          showCloseIcon: true,
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      importTBAInfo = false;
    }

    // Create Flag Section
    List<TeamFlagApplication> teamFlagApplication = await dbTeamFlagApplications
        .getActiveTeamFlagApplications();

    List<Widget> chips = [];
    chips.add(
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            'Flags:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.orange.shade300,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );

    // Get a list of active flags (flags with teams assigned)
    if (teamFlags.isEmpty) {
      teamFlags = await dbTeamFlagApplications
          .getActiveTeamFlagApplicationsAsMap();
    }

    List<String> flagsWithTeams = [];
    for (TeamFlagApplication teamFlagApplication in teamFlagApplication) {
      if (!flagsWithTeams.contains(teamFlagApplication.name)) {
        flagsWithTeams.add(teamFlagApplication.name);
      }
    }

    // Determine the list of teams to display
    List<int> listOfTeamsToDisplay = [];

    for (Team team in eventTeams) {
      bool teamFound = true;
      teamFlags.forEach((key, value) {
        if (activeFlags.contains(key) && !value.contains(team.number)) {
          teamFound = false;
        }
      });
      if (teamFound) listOfTeamsToDisplay.add(team.number);
    }

    // Trigger an update of the Team Metrics table
    teamsToShowNotifier.value = TeamsToShow.init(
      listOfTeamsToDisplay,
      activeFlags.isNotEmpty,
    );

    // Create the Flag chips
    for (String key in teamFlags.keys) {
      if (context.mounted) {
        chips.add(
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (activeFlags.contains(key))
                    ? Colors.orange.shade300
                    : Colors.black,
                side: BorderSide(width: 2.0, color: Colors.orange.shade300),
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

                  teamsToShowNotifier.value = TeamsToShow.init(teams, true);
                });
              },
            ),
          ),
        );
      }
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Kryptopedia - Team Metrics",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.leaderboard, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (!importTBAInfo) importTBAInfo = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  showFlags ? Icons.flag : Icons.flag_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    showFlags = !showFlags;
                    activeFlags = [];
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: processActions(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Visibility(
                  visible: showFlags,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 0.0,
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
                      color: Colors.black54,
                      border: Border.all(width: 1.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    child: SizedBox(
                      height: 40.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!,
                      ),
                    ),
                  ),
                ),
                TeamMetricsMatrix(
                  teamstoShowNotifer: teamsToShowNotifier,
                  tbaUpdateNotifier: tbaUpdateNotifier,
                ),
              ],
            );
          } else {
            return Text('Working ...');
          }
        },
      ),
    );
  }
}
