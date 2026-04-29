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
  final int team1Rank;
  final int team2Rank;
  final int team3Rank;

  const AllianceOverview(
    this.allianceColor,
    this.team1Number,
    this.team2Number,
    this.team3Number,
    this.team1Summary,
    this.team2Summary,
    this.team3Summary, 
    this.team1Rank,
    this.team2Rank,
    this.team3Rank, {
    super.key,
  });

  final double tableWidth =
      90 + (65.0 * 3) + (90.0) + 150 + (120.0 * 2) + (100.0 * 5);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxHeader(
            "$allianceColor Alliance Overview",
            Colors.white,
            (allianceColor == "Red") ? Colors.red : Colors.blue,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                      teamRow(
                        context,
                        allianceColor,
                        team1Number,
                        team1Summary,
                        team1Rank,
                      ),
                      teamRow(
                        context,
                        allianceColor,
                        team2Number,
                        team2Summary,
                        team2Rank,
                      ),
                      teamRow(
                        context,
                        allianceColor,
                        team3Number,
                        team3Summary,
                        team3Rank,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topHeaderRow() {
    return SizedBox(
      width: tableWidth,
      child: Row(
        children: [
          columnMajorHeaders(" ", 65.0 + 90, 30.0),
          columnMajorHeaders("Performance", 90 + 150, 30.0),
          columnMajorHeaders(" ", 65.0, 30.0),
          columnMajorHeaders("Fuel Scoring", 2 * 120.0, 30.0),
          columnMajorHeaders(" ", 65.0, 30.0),
          columnMajorHeaders("Climb - Counts / %", 5 * 100.0, 30.0),
        ],
      ),
    );
  }

  Widget bottomHeaderRow() {
    return SizedBox(
      width: tableWidth,
      child: Row(
        children: [
          columnMajorHeaders(" ", 65.0, 50.0),
          columnMajorHeaders("Team Rank", 90.0, 50.0),
          columnMajorHeaders("Match\nCount", 90.0, 50.0),
          columnMajorHeaders("Robot\nIssues / %", 150.0, 50.0),
          columnMajorHeaders(" ", 65.0, 50.0),
          columnMajorHeaders("Auto", 120.0, 50.0),
          columnMajorHeaders("Teleop", 120.0, 50.0),
          columnMajorHeaders(" ", 65.0, 50.0),
          columnMajorHeaders("Auto", 100.0, 50.0),
          columnMajorHeaders("Endgame\nNone", 100.0, 50.0),
          columnMajorHeaders("Endgame\nL1", 100.0, 50.0),
          columnMajorHeaders("Endgame\nL2", 100.0, 50.0),
          columnMajorHeaders("Endgame\nL3", 100.0, 50.0),
        ],
      ),
    );
  }

  SizedBox columnMajorHeaders(
    String header,
    double cellWidth,
    double cellHeight,
  ) {
    Align headerText = Align(
      alignment: Alignment.center,
      child: AutoSizeText(
        header,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        maxLines: 2,
      ),
    );

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Container(
        decoration: (header != " ")
            ? BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                color: Colors.white,
              )
            : BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                color: Colors.grey,
              ),
        child: headerText,
      ),
    );
  }

  Widget teamRow(
    BuildContext context,
    String allianceColor,
    int teamNumber,
    TeamInfoSummary teamInfoSummary,
    int teamRank,
  ) {
    return SizedBox(
      width: tableWidth,
      child: Row(
        children: [
          leadLabel(
            context,
            teamNumber.toString(),
            65.0,
            (allianceColor == "Red") ? Colors.red : Colors.blue,
          ),

          smallCellContainer(teamRank.toString(), 90.0, false, true),

          smallCellContainer(
            teamInfoSummary.numberOfMatches.toString(),
            90.0,
            false,
            true,
          ),
          smallCellContainer(
            "${(teamInfoSummary.summaryIssuesTotal).toString()} / "
            "${(teamInfoSummary.summaryIssuesPercent[1] + teamInfoSummary.summaryIssuesPercent[2]).toStringAsFixed(2)}%",
            150.0,
            false,
            true,
          ),

          leadLabel(
            context,
            teamNumber.toString(),
            65.0,
            (allianceColor == "Red") ? Colors.red : Colors.blue,
          ),
          smallCellContainer(
            "${teamInfoSummary.autoFuelScoreMin} / "
            "${teamInfoSummary.autoFuelScoreMax} / "
            "${teamInfoSummary.autoFuelScoreAverage.toStringAsFixed(2)}",
            120.0,
            false,
            true,
          ),
          smallCellContainer(
            "${teamInfoSummary.teleopFuelScoreMin} / "
            "${teamInfoSummary.teleopFuelScoreMax} / "
            "${teamInfoSummary.teleopFuelScoreAverage.toStringAsFixed(2)}",
            120.0,
            false,
            true,
          ),

          leadLabel(
            context,
            teamNumber.toString(),
            65.0,
            (allianceColor == "Red") ? Colors.red : Colors.blue,
          ),
          smallCellContainer(
            "${teamInfoSummary.autoClimbedTotal} / "
            "${teamInfoSummary.autoClimbedPercent}%",
            100.0,
            false,
            true,
          ),
          smallCellContainer(
            "${teamInfoSummary.teleopClimbedTotals[0]} / "
            "${teamInfoSummary.teleopClimbedPercents[0]}%",
            100.0,
            false,
            true,
          ),
          smallCellContainer(
            "${teamInfoSummary.teleopClimbedTotals[1]} / "
            "${teamInfoSummary.teleopClimbedPercents[1]}%",
            100.0,
            false,
            true,
          ),
          smallCellContainer(
            "${teamInfoSummary.teleopClimbedTotals[2]} / "
            "${teamInfoSummary.teleopClimbedPercents[2]}%",
            100.0,
            false,
            true,
          ),
          smallCellContainer(
            "${teamInfoSummary.teleopClimbedTotals[3]} / "
            "${teamInfoSummary.teleopClimbedPercents[3]}%",
            100.0,
            false,
            true,
          ),
        ],
      ),
    );
  }

  Container leadLabel(
    BuildContext context,
    String bannerLabel,
    double cellWidth,
    Color backgroundColor,
  ) {
    return Container(
      width: cellWidth,
      height: 30.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TeamInfo(passedTeamID: int.parse(bannerLabel)),
            ),
          );
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

  Container smallCellContainer(
    String value,
    double cellWidth,
    bool headers,
    bool center,
  ) {
    return Container(
      width: cellWidth,
      height: 30.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
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
