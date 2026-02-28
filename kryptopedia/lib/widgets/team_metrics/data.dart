import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:kryptopedia/screens/team_info.dart';
import 'package:kryptopedia/models/team_metrics.dart';

class DataGrid extends StatelessWidget {
  final List<TeamMetrics> currentTeamStats;
  final TeamMetrics maxTeamStats;
  // final List<TeamScorePrediction> teamScorePredictions;
  final int maxPredictedScore;

  const DataGrid({
    super.key,
    required this.currentTeamStats,
    required this.maxTeamStats,
    // required this.teamScorePredictions,
    required this.maxPredictedScore,
  });

  @override
  Widget build(BuildContext context) {
    // Clear out the metrics table
    List<Row> metricsTeamRows = [];

    for (int i = 0; i < currentTeamStats.length; i++) {
      metricsTeamRows.add(
        Row(
          children: [
            leadLabel(
              context,
              currentTeamStats[i].teamId.toString(),
              75.0,
              Colors.grey.shade200,
            ),

            smallCellContainer(
              currentTeamStats[i].matchCount.toString(),
              75.0,
              CellColoring(Colors.white, Colors.black),
              false,
              true,
            ),
            smallCellContainer(
              currentTeamStats[i].teamRanking.toString(),
              75.0,
              getRankingShading(
                currentTeamStats[i].teamRanking,
                currentTeamStats.length,
              ),
              true,
              true,
            ),
            smallCellContainer(
              currentTeamStats[i].teamOprs.toStringAsFixed(2),
              75.0,
              getIntShading(currentTeamStats[i].teamOprs.round(), 65),
              true,
              true,
            ),

            smallCellContainer(
              currentTeamStats[i].driveTrain,
              85.0,
              getIntShading(
                getDrivetrainValue(currentTeamStats[i].driveTrain),
                10,
              ),
              true,
              true,
            ),
            smallCellContainer(
              "TBD", 75.0, getIntShading(10, 10), true, true),
            smallCellContainer(
              (currentTeamStats[i].robotWeight >= 0)
                  ? currentTeamStats[i].robotWeight.toString()
                  : "--",
              75.0,
              getIntShading(currentTeamStats[i].robotWeight, 115),
              true,
              true,
            ),
            leadLabel(
              context,
              currentTeamStats[i].teamId.toString(),
              75.0,
              Colors.grey.shade200,
            ),
            smallCellContainer(
              currentTeamStats[i].autoFuelScoreTotal.toString(),
              75.0,
              getIntShading(
                currentTeamStats[i].autoFuelScoreTotal,
                maxTeamStats.autoFuelScoreTotal,
              ),
              true,
              true,
            ),
            smallCellContainer(
              currentTeamStats[i].autoFuelScoreAverage.toString(),
              75.0,
              getDoubleShading(
                currentTeamStats[i].autoFuelScoreAverage,
                maxTeamStats.autoFuelScoreAverage,
              ),
              true,
              true,
            ),
            smallCellContainer(
              currentTeamStats[i].teleopFuelScoreTotal.toString(),
              75.0,
              getIntShading(
                currentTeamStats[i].teleopFuelScoreTotal,
                maxTeamStats.teleopFuelScoreTotal,
              ),
              true,
              true,
            ),
            smallCellContainer(
              currentTeamStats[i].teleopFuelScoreAverage.toString(),
              75.0,
              getDoubleShading(
                currentTeamStats[i].teleopFuelScoreAverage,
                maxTeamStats.teleopFuelScoreAverage,
              ),
              true,
              true,
            ),
            smallCellContainer(
              currentTeamStats[i].teleopFuelFedTotal.toString(),
              75.0,
              getIntShading(
                currentTeamStats[i].teleopFuelFedTotal,
                maxTeamStats.teleopFuelFedTotal,
              ),
              true,
              true,
            ),
            smallCellContainer(
              currentTeamStats[i].teleopFuelFedAverage.toString(),
              75.0,
              getDoubleShading(
                currentTeamStats[i].teleopFuelFedAverage,
                maxTeamStats.teleopFuelFedAverage,
              ),
              true,
              true,
            ),
            leadLabel(
              context,
              currentTeamStats[i].teamId.toString(),
              75.0,
              Colors.grey.shade200,
            ),

            // smallCellContainer(
            //   currentTeamStats[i].autoCoralScoreAverage.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].autoCoralScoreAverage,
            //     maxTeamStats.autoCoralScoreAverage,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].autoAlgaeScoreAverage.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].autoAlgaeScoreAverage,
            //     maxTeamStats.autoAlgaeScoreAverage,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopCoralScoreAverage.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopCoralScoreAverage,
            //     maxTeamStats.teleopCoralScoreAverage,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopAlgaeScoreAverage.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopAlgaeScoreAverage,
            //     maxTeamStats.teleopAlgaeScoreAverage,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   teamScorePredictions[i].totalPoints.toStringAsFixed(2),
            //   75.0,
            //   getIntShading(
            //     teamScorePredictions[i].totalPoints,
            //     maxPredictedScore,
            //   ),
            //   true,
            //   true,
            // ),

            // leadLabel(
            //   context,
            //   currentTeamStats[i].teamId.toString(),
            //   75.0,
            //   Colors.grey.shade200,
            // ),

            // smallCellContainer(
            //   currentTeamStats[i].teleopCoralLevel1Average.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopCoralLevel1Average,
            //     maxTeamStats.teleopCoralLevel1Average,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopCoralLevel2Average.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopCoralLevel2Average,
            //     maxTeamStats.teleopCoralLevel2Average,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopCoralLevel3Average.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopCoralLevel3Average,
            //     maxTeamStats.teleopCoralLevel3Average,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopCoralLevel4Average.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopCoralLevel4Average,
            //     maxTeamStats.teleopCoralLevel4Average,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   "${currentTeamStats[i].teleopCoralPiecesTotal}",
            //   75.0,
            //   getIntShading(
            //     currentTeamStats[i].teleopCoralPiecesTotal,
            //     maxTeamStats.teleopCoralPiecesTotal,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopCoralPiecesAverage.toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopCoralPiecesAverage,
            //     maxTeamStats.teleopCoralPiecesAverage,
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopEndGamePercents[2].toStringAsFixed(2),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopEndGamePercents[2],
            //     maxTeamStats.teleopEndGamePercents[2],
            //   ),
            //   true,
            //   true,
            // ),
            // smallCellContainer(
            //   currentTeamStats[i].teleopEndGamePercents[3].toStringAsFixed(3),
            //   75.0,
            //   getDoubleShading(
            //     currentTeamStats[i].teleopEndGamePercents[3],
            //     maxTeamStats.teleopEndGamePercents[3],
            //   ),
            //   true,
            //   true,
            // ),

            // leadLabel(
            //   context,
            //   currentTeamStats[i].teamId.toString(),
            //   75.0,
            //   Colors.grey.shade200,
            // ),
          ],
        ),
      );
    }

    return Expanded(
      child: Container(
        width: (75.0 * 21.0) + 85.0,
        padding: EdgeInsets.only(top: 10.0),
        child: ListView(children: [Column(children: metricsTeamRows)]),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         TeamInfo(passedTeamID: int.parse(bannerLabel)),
          //   ),
          // );
        },
        child: AutoSizeText(
          bannerLabel,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue,
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
    CellColoring cellColoring,
    bool headers,
    bool center,
  ) {
    return Container(
      width: cellWidth,
      height: 30.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        color: cellColoring.backgroundColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: AutoSizeText(
        value,
        textAlign: (center) ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontSize: 18.0,
          color: cellColoring.textColor,
          fontWeight: headers ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  CellColoring getRankingShading(int cellValue, int cellMax) {
    return getIntShading(cellMax - (cellValue - 1), cellMax);
  }

  CellColoring getDimensionShading(int cellValue) {
    return getIntShading(40 - (cellValue - 22), 40);
  }

  CellColoring getIntShading(int cellValue, int cellMax) {
    return getDoubleShading(cellValue.toDouble(), cellMax.toDouble());
  }

  CellColoring getRobotHeightShading(int cellValue, int cellMax) {
    CellColoring cellColoring = getIntShading(
      cellMax - (cellValue - 20),
      cellMax,
    );
    // if (cellValue <= 27) {
    //   cellColoring.textColor = Colors.green;
    // }
    return cellColoring;
  }

  CellColoring getDoubleShading(double cellValue, double cellMax) {
    CellColoring cellColoring = CellColoring(Colors.white, Colors.black);

    double rankPercent = (cellValue / cellMax) * 100;
    if (rankPercent > 90.0) {
      cellColoring.backgroundColor = Colors.orange.shade900;
      cellColoring.textColor = Colors.white;
    } else if (rankPercent > 80.0) {
      cellColoring.backgroundColor = Colors.orange.shade800;
    } else if (rankPercent > 70.0) {
      cellColoring.backgroundColor = Colors.orange.shade700;
    } else if (rankPercent > 60.0) {
      cellColoring.backgroundColor = Colors.orange.shade600;
    } else if (rankPercent > 50.0) {
      cellColoring.backgroundColor = Colors.orange.shade500;
    } else if (rankPercent > 40.0) {
      cellColoring.backgroundColor = Colors.orange.shade400;
    } else if (rankPercent > 20.0) {
      cellColoring.backgroundColor = Colors.orange.shade300;
    } else {
      cellColoring.backgroundColor = Colors.orange.shade200;
      cellColoring.textColor = Colors.black;
    }

    return cellColoring;
  }

  int getDrivetrainValue(String driveTrain) {
    switch (driveTrain) {
      case "Swerve":
        return 10;
      case "Tank":
        return 7;
      case "Mecanum":
        return 5;
      case "Other":
        return 3;
    }

    return 0;
  }
}

class CellColoring {
  Color? backgroundColor = Colors.white;
  Color? textColor = Colors.black;

  CellColoring(Color? bg, Color? fg) {
    backgroundColor = bg;
    textColor = fg;
  }
}
