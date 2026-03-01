import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/team_metrics/matrix.dart';

class TeamMetrics extends StatefulWidget {
  const TeamMetrics({super.key});

  @override
  State<TeamMetrics> createState() => _TeamMetricsState();
}

class _TeamMetricsState extends State<TeamMetrics> {
  bool showFlags = false;
  List<String> activeFlags = [];
  int updateCount = 0;
  List<int> teams = [];
  ValueNotifier<TeamsToShow> teamsToShowNotifier = ValueNotifier<TeamsToShow>(
    TeamsToShow.init([], false),
  );

  Future<List<Widget>> getFlags() async {
    DbTeams dbTeams = DbTeams();
    DbTeamFlagApplications dbTeamFlagApplications = DbTeamFlagApplications();

    List<Team> eventTeams = await dbTeams.getTeams();
    List<TeamFlagApplication> teamFlagApplication = await dbTeamFlagApplications
        .getActiveTeamFlagApplications();

    // If the teams to show is empty, add the list of teams at the event.
    if (teamsToShowNotifier.value.teams.isEmpty) {
      List<int> teams = [];
      for (Team team in eventTeams) {
        teams.add(team.number);
      }
      teamsToShowNotifier.value = TeamsToShow.init(teams, false);
    }

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

    // for (TeamFlagApplication teamFlag in teamFlagApplication) {
    //   if (teamFlag.teamNumbers.isNotEmpty) {
    //     if (context.mounted) {
    //       chips.add(
    //         Padding(
    //           padding: const EdgeInsets.all(5.0),
    //           child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: (activeFlags.contains(teamFlag.name))
    //                   ? Colors.orange.shade300
    //                   : Colors.black,
    //               side: BorderSide(width: 2.0, color: Colors.orange.shade300),
    //             ),
    //             child: AutoSizeText(
    //               teamFlag.name,
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 color: (activeFlags.contains(teamFlag.name))
    //                     ? Colors.black
    //                     : Colors.white,
    //                 fontSize: 14.0,
    //               ),
    //             ),
    //             onPressed: () async {
    //               setState(() {
    //                 (!activeFlags.contains(teamFlag.name))
    //                     ? activeFlags.add(teamFlag.name)
    //                     : activeFlags.remove(teamFlag.name);

    //                 teams = [];
    //                 for (Team team in eventTeams) {
    //                   bool teamFound = true;
    //                   for (TeamFlagApplication teamFlag in teamFlagApplication) {
    //                     if (activeFlags.contains(teamFlag.name) &&
    //                         !teamFlag.teamNumbers.contains(team.teamnumber)) {
    //                       teamFound = false;
    //                     }
    //                   }
    //                   if (teamFound) teams.add(team.teamnumber);
    //                 }

    //                 teamsToShowNotifier.value = TeamsToShow.init(teams, true);
    //               });
    //             },
    //           ),
    //         ),
    //       );
    //     }
    //   }
    // }

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
          IconButton(
            icon: Icon(
              showFlags ? Icons.flag : Icons.flag_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showFlags = !showFlags;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getFlags(),
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
                TeamMetricsMatrix(teamstoShowNotifer: teamsToShowNotifier),
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
