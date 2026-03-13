import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/team_metrics.dart';
import 'package:kryptopedia/util/2026helpers/calculate_all_team_metrics.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/widgets/common/label.dart';
import 'package:kryptopedia/widgets/team_info/team_tables.dart';

class TeamInfoMatchesTable extends StatelessWidget {
  final List<ScoutedMatch> scoutedMatches;
  //final TeamInfoSummary teamInfoSummary;

  const TeamInfoMatchesTable({
    super.key,
    required this.scoutedMatches,
    /*required this.teamInfoSummary*/
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextLabel(label: "Match Information", headerLabel: true),
        FutureBuilder<List<TableRow>>(
          future: createMatchInfoTable(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.only(
                  top: 0.0,
                  right: 5.0,
                  left: 5.0,
                  bottom: 5.0,
                ),
                height:
                    50.0 + // Table Header
                    (30.0 *
                        scoutedMatches
                            .length) + // # of Scouted Matches * Row Height
                    40, // Average + Separator Row Height
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Table(
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      children: snapshot.data!,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 25.0),
      ],
    );
  }

  Future<List<TableRow>> createMatchInfoTable(BuildContext context) async {
    DbMatches dbMatch = DbMatches();

    List<TableRow> table = [];

    CalculateAllTeamMetrics calculateAllTeamMetrics = CalculateAllTeamMetrics();

    TeamMetrics stats = await calculateAllTeamMetrics.calculateTeamMetrics(
      scoutedMatches.first.teamNumber,
    );

    // Display table headers
    table.add(
      TableRow(
        children: [
          TeamInfoTables.topHeader(
            context,
            100.0,
            "Match #",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Auto Fuel Scored",
            Colors.white,
            false,
            false,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Auto Climbed",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Teleop Fuel Scored",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Teleop Fuel Fed",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Didn't climb",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "L1\nClimb",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "L2\nClimb",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "L3\nClimb",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Offense",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Defense",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Feeder",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            80.0,
            "No\nPenalties",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            80.0,
            "One Penalty",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            80.0,
            "Few Penalties",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            80.0,
            "Many Penalties",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Issues",
            Colors.white,
            false,
            true,
          ),
        ],
      ),
    );
    // Display Scouted Match Information
    for (int i = 0; i < scoutedMatches.length; i++) {
      EventMatch match = await dbMatch.getQualificationMatch(
        scoutedMatches[i].matchNumber,
      );

      if (context.mounted) {
        table.add(
          TableRow(
            children: [
              TeamInfoTables.displayCell(
                match.number.toString(),
                false,
                context,
                100.0,
                Colors.white,
                Colors.black,
                false,
              ),
              TeamInfoTables.displayCell(
                "${scoutedMatches[i].autoFuelScored}",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].autoClimbed ? "\u2713" : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                "${scoutedMatches[i].teleopFuelScored}",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                "${scoutedMatches[i].teleopFuelFed}",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].climbLevel == ClimbLevel.none
                    ? "\u2713"
                    : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].climbLevel == ClimbLevel.L1 ? "\u2713" : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].climbLevel == ClimbLevel.L2 ? "\u2713" : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].climbLevel == ClimbLevel.L3 ? "\u2713" : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].robotRoles.contains(RobotRole.offense)
                    ? "\u2713"
                    : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].robotRoles.contains(RobotRole.defense)
                    ? "\u2713"
                    : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].robotRoles.contains(RobotRole.feeder)
                    ? "\u2713"
                    : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].penalties == Penalties.none ? "\u2713" : "--",
                false,
                context,
                80.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].penalties == Penalties.one ? "\u2713" : "--",
                false,
                context,
                80.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].penalties == Penalties.few ? "\u2713" : "--",
                false,
                context,
                80.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].penalties == Penalties.many ? "\u2713" : "--",
                false,
                context,
                80.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].issues ? "\u2713" : "--",
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
            ],
          ),
        );
      }
    }

    table.add(TeamInfoTables.createSeparatorRow(17));

    if (context.mounted) {
      table.add(
        TableRow(
          children: [
            TeamInfoTables.sideHeader(
              context,
              100.0,
              "Avg / %",
              Colors.white,
              false,
              false,
            ),

            TeamInfoTables.displayCell(
              (stats.autoFuelScoreAverage).toStringAsFixed(2),
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${(stats.autoClimbedPercent).toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              stats.teleopFuelScoreAverage.toStringAsFixed(2),
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              stats.teleopFuelFedAverage.toStringAsFixed(2),
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.teleopClimbedPercents[0].toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.teleopClimbedPercents[1].toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.teleopClimbedPercents[2].toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.teleopClimbedPercents[3].toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryRolesPercent[0].toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryRolesPercent[1].toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryRolesPercent[2].toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryPenaltiesPercents[0].toStringAsFixed(0)}%",
              false,
              context,
              80.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryPenaltiesPercents[1].toStringAsFixed(0)}%",
              false,
              context,
              80.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryPenaltiesPercents[2].toStringAsFixed(0)}%",
              false,
              context,
              80.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryPenaltiesPercents[3].toStringAsFixed(0)}%",
              false,
              context,
              80.0,
              Colors.white,
              Colors.black,
              true,
            ),
            TeamInfoTables.displayCell(
              "${stats.summaryIssuesPercent.toStringAsFixed(0)}%",
              false,
              context,
              70.0,
              Colors.white,
              Colors.black,
              true,
            ),
          ],
        ),
      );
    }

    return table;
  }
}
