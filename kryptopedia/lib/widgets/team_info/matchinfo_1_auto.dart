import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/widgets/common/label.dart';
import 'package:kryptopedia/widgets/team_info/team_tables.dart';

class TeamInfoMatchesAuto extends StatelessWidget {
  final List<ScoutedMatch> scoutedMatches;
  //final TeamInfoSummary teamInfoSummary;

  const TeamInfoMatchesAuto({
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
          future: createAutonomousTable(context),
          builder: (context, snapshot) {
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

  Future<List<TableRow>> createAutonomousTable(BuildContext context) async {
    DbMatches dbMatch = DbMatches();

    List<TableRow> autonomousTable = [];

    // Display table headers
    autonomousTable.add(
      TableRow(
        children: [
          TeamInfoTables.topHeader(
            context,
            140.0,
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
            "Climb Level",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Robot Roles",
            Colors.white,
            false,
            true,
          ),
          TeamInfoTables.topHeader(
            context,
            70.0,
            "Penalties",
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
        autonomousTable.add(
          TableRow(
            children: [
              TeamInfoTables.displayCell(
                match.number.toString(),
                false,
                context,
                140.0,
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
                scoutedMatches[i].climbLevel.name,
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].robotRoles
                    .map((role) => role.name[0].toUpperCase())
                    .join(", "),
                false,
                context,
                70.0,
                Colors.white,
                Colors.black,
                true,
              ),
              TeamInfoTables.displayCell(
                scoutedMatches[i].penalties.name,
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

    //autonomousTable.add(TeamInfoTables.createSeparatorRow(10));

    /*if (context.mounted) {
      autonomousTable.add(TableRow(children: [
        TeamInfoTables.sideHeader(context, 140.0, "Avg / %", Colors.white, false, false),

        TeamInfoTables.displayCell(
          "${(teamInfoSummary.autoLeaveZonePercent * 100.0).toStringAsFixed(2)}%",
          false, context, 70.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          "${(teamInfoSummary.autoLeaveZoneAssistPercent * 100.0).toStringAsFixed(2)}%",
          false, context, 70.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          teamInfoSummary.autoCoralLevel1Average.toStringAsFixed(2),
          false, context, 70.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          teamInfoSummary.autoCoralLevel2Average.toStringAsFixed(2),
          false, context, 70.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          teamInfoSummary.autoCoralLevel3Average.toStringAsFixed(2),
          false, context, 70.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          teamInfoSummary.autoCoralLevel4Average.toStringAsFixed(2),
          false, context, 70.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          teamInfoSummary.autoAlgaeRemovedFromReefAverage.toStringAsFixed(2),
          false, context, 80.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          teamInfoSummary.autoAlgaeProcessorAverage.toStringAsFixed(2),
          false, context, 80.0, Colors.white, Colors.black, true),
        TeamInfoTables.displayCell(
          teamInfoSummary.autoAlgaeCargoNetAverage.toStringAsFixed(2),
          false, context, 80.0, Colors.white, Colors.black, true),
      ]));
    }*/

    return autonomousTable;
  }
}
