import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/teaminfosummary.dart';
import 'package:kryptopedia/screens/team_info.dart';
import 'package:kryptopedia/widgets/common/box_header.dart';
//import 'package:kryptopedia_2025/util/deviceinfo.dart';

class AllianceOverview extends StatelessWidget {
  final String allianceColor;
  final int team1Number;
  final int team2Number;
  final int team3Number;
  final TeamInfoSummary team1Summary;
  final TeamInfoSummary team2Summary;
  final TeamInfoSummary team3Summary;

  const AllianceOverview(
    this.allianceColor,
    this.team1Number,
    this.team2Number,
    this.team3Number,
    this.team1Summary,
    this.team2Summary,
    this.team3Summary,
    {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(25.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxHeader("$allianceColor Alliance Overview", Colors.white, 
            (allianceColor == "Red") ? Colors.red : Colors.blue),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                top: 10.0,
                right: 20.0,
                left: 20.0,
                bottom: 10.0,
              ),
              height: 200.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topHeaderRow(),
                      bottomHeaderRow(),
                      teamRow(context, allianceColor, team1Number, team1Summary),
                      teamRow(context, allianceColor, team2Number, team2Summary),
                      teamRow(context, allianceColor, team3Number, team3Summary),
                    ],
                  ),
                ] ,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topHeaderRow() {
    return SizedBox(
      width: (65.0 * 4) + (75.0 * 11.0) + (95.0 * 12),
      child: Row(
        children: [
          columnMajorHeaders(" ", 65.0, 30.0),
          columnMajorHeaders("Performance", 3 * 75.0, 30.0),
          columnMajorHeaders(" ", 65.0, 30.0),
          columnMajorHeaders("Auto - Min / Max / Avg", 6 * 95.0, 30.0),
          columnMajorHeaders(" ", 65.0, 30.0),
          columnMajorHeaders("Teleop - Min / Max / Avg", 6 * 95.0, 30.0),
          columnMajorHeaders(" ", 65.0, 30.0),
          columnMajorHeaders("Endgame - Counts / Percents", 4 * 75.0, 30.0),
        ],
      ),
    );
  }

  Widget bottomHeaderRow() {
    return SizedBox(
      width: (65.0 * 4) + (75.0 * 11.0) + (95.0 * 12),
      child: Row(
        children: [
          columnMajorHeaders(" ", 65.0, 50.0),
          columnMajorHeaders("Match\nCount", 75.0, 50.0),
          columnMajorHeaders("Ops\nIssues", 75.0, 50.0),
          columnMajorHeaders("Mech\nIssues", 75.0, 50.0),

          columnMajorHeaders(" ", 65.0, 50.0),
          columnMajorHeaders("Coral\nL1", 95.0, 50.0),
          columnMajorHeaders("Coral\nL2", 95.0, 50.0),
          columnMajorHeaders("Coral\nL3", 95.0, 50.0),
          columnMajorHeaders("Coral\nL4", 95.0, 50.0),
          columnMajorHeaders("Algae\nProcessor", 95.0, 50.0),
          columnMajorHeaders("Algae\nNet", 95.0, 50.0),

          columnMajorHeaders(" ", 65.0, 50.0),
          columnMajorHeaders("Coral\nL1", 95.0, 50.0),
          columnMajorHeaders("Coral\nL2", 95.0, 50.0),
          columnMajorHeaders("Coral\nL3", 95.0, 50.0),
          columnMajorHeaders("Coral\nL4", 95.0, 50.0),
          columnMajorHeaders("Algae\nProcessor", 95.0, 50.0),
          columnMajorHeaders("Algae\nNet", 95.0, 50.0),

          columnMajorHeaders(" ", 65.0, 50.0),
          columnMajorHeaders("None", 75.0, 50.0),
          columnMajorHeaders("Parked", 75.0, 50.0),
          columnMajorHeaders("Shallow\nClimb", 75.0, 50.0),
          columnMajorHeaders("Deep\nClimb", 75.0, 50.0),
        ],
      ),
    );
  }

  SizedBox columnMajorHeaders(String header, double cellWidth, double cellHeight) {
    Align headerText = Align(
      alignment: Alignment.center,
      child: AutoSizeText(
        header,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
        maxLines: 2,
      ),
    );

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Container(
        decoration: (header != " ") ?
          BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            color: Colors.white,
          ) :
          BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            color: Colors.grey,
          ),
        child: headerText,
      ),
    );
  }

  Widget teamRow(BuildContext context, String allianceColor, int teamNumber, TeamInfoSummary teamInfoSummary) {
    return SizedBox(
      width: (65.0 * 4) + (75.0 * 11.0) + (95.0 * 12),
      child: Row(
        children: [
          leadLabel(context, teamNumber.toString(), 65.0, (allianceColor == "Red") ? Colors.red : Colors.blue),
          smallCellContainer(teamInfoSummary.numberOfMatches.toString(), 75.0, false, true),
        // smallCellContainer(
        //   "${(teamInfoSummary.summaryOperationalIssuesGamePercents * 100).toStringAsFixed(2)}%", 75.0, false, true),
        // smallCellContainer(
        //  "${(teamInfoSummary.summaryMechanicalIssuesGamePercents * 100).toStringAsFixed(2)}%", 75.0, false, true),

          leadLabel(context, teamNumber.toString(), 65.0, (allianceColor == "Red") ? Colors.red : Colors.blue),
          smallCellContainer(
            "${teamInfoSummary.autoFuelScoreMin} / " 
            "${teamInfoSummary.autoFuelScoreMax} / "
            "${teamInfoSummary.autoFuelScoreAverage.toStringAsFixed(2)}", 95.0, false, true),
          smallCellContainer(
            "${teamInfoSummary.autoClimbedPercent} / " 
            " / "
            "", 95.0, false, true),
          smallCellContainer(
            "${teamInfoSummary.teleopFuelScoreMin} / " 
            "${teamInfoSummary.teleopFuelScoreMax} / "
            "${teamInfoSummary.teleopFuelScoreAverage.toStringAsFixed(2)}", 95.0, false, true),
          smallCellContainer(
            "${teamInfoSummary.teleopClimbedPercents[1]} / " 
            "${teamInfoSummary.teleopClimbedPercents[2]} / "
            "${teamInfoSummary.teleopClimbedPercents[3]}", 95.0, false, true),
        ],
      ),
    );
  }

  Container leadLabel(BuildContext context, String bannerLabel,
      double cellWidth, Color backgroundColor) {
    return Container(
      width: cellWidth,
      height: 30.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TeamInfo(passedTeamID: int.parse(bannerLabel))));
        },
        child: AutoSizeText(
          bannerLabel,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  Container smallCellContainer(String value, double cellWidth, bool headers, bool center) {
    return Container(
      width: cellWidth,
      height: 30.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(5.0),
      child: AutoSizeText(
        value,
        textAlign: (center) ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: headers ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}


