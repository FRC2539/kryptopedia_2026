import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/util/predictions.dart';
import 'package:kryptopedia/widgets/common/box_header.dart';

class PredictionOverview extends StatelessWidget {
  final MatchScorePrediction prediction;
  const PredictionOverview(this.prediction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(25.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxHeader("Predicted Match Overview", Colors.white, Colors.black),
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
              height: 150.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(50.0),
                      1: FixedColumnWidth(65.0 * 4.0 + 15.0),
                      2: FixedColumnWidth(50.0),
                      3: FixedColumnWidth(70.0 * 3.0 + 80.0),
                      4: FixedColumnWidth(50.0),
                      5: FixedColumnWidth(85.0 * 4),
                      6: FixedColumnWidth(90.0),
                    },
                    children: [
                      TableRow(children: [
                        emptyCell(),
                        columnMajorHeaders("Auto Points", context),
                        emptyCell(),
                        columnMajorHeaders(
                            "Teleop and Endgame Points", context),
                        emptyCell(),
                        columnMajorHeaders("Bonus Ranking Points", context),
                        emptyCell(),
                      ]),
                      TableRow(children: [
                        emptyCell(),
                        autonomousDetails(
                            " \nFuel",
                            " \nClimb",
                            Colors.white,
                            Colors.black,
                            true,
                            context),
                        emptyCell(),
                        teleopDetails(
                            " \nFuel",
                            " \nClimb",
                            Colors.white,
                            Colors.black,
                            true,
                            context),
                        emptyCell(),
                        rankingPointDetails(
                            "1st Fuel\nRP",
                            "2nd Fuel\nRP",
                            "Climb\nRP",
                            Colors.white,
                            Colors.black,
                            true,
                            context),
                        finalScoreDetails("Total\nPoints", Colors.white,
                            Colors.black, true, context),
                      ]),
                      displayAllianceInfo(prediction.blue, context),
                      displayAllianceInfo(prediction.red, context),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
                left: 20.0,
                bottom: 20.0,
              ),
              child: Row(
                children: <Widget>[
                  AutoSizeText(
                    "Predicted Result:  ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: Device.fontHeader2(context),
                    ),
                    maxLines: 1,
                  ),
                  announceWinner(context),
                ],
              ))
        ],
      ),
    );
  }

  Container announceWinner(BuildContext context) {
    String allianceWinner;
    Color backgroundColor;
    Color foregroundColor;

    if (!prediction.blue.enoughForPrediction ||
        !prediction.red.enoughForPrediction) {
      allianceWinner = "Not enough information available";
      backgroundColor = Colors.grey;
      foregroundColor = Colors.black;
    } else if ((prediction.blue.totalPoints - prediction.red.totalPoints)
            .abs() <=
        10) {
      allianceWinner = "Too close to call";
      backgroundColor = Colors.grey;
      foregroundColor = Colors.black;
    } else if (prediction.blue.totalPoints == prediction.red.totalPoints) {
      allianceWinner = "Tie";
      backgroundColor = Colors.grey;
      foregroundColor = Colors.black;
    } else if (prediction.blue.totalPoints > prediction.red.totalPoints) {
      allianceWinner = "Blue Alliance Wins";
      backgroundColor = Colors.blue;
      foregroundColor = Colors.white;
    } else {
      allianceWinner = "Red Alliance Wins";
      backgroundColor = Colors.red;
      foregroundColor = Colors.white;
    }

    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      // padding: const EdgeInsets.only(top: 0.0, bottom: 15.0, right: 0.0, left: 20.0),
      child: AutoSizeText(
        allianceWinner,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
          fontSize: Device.fontHeader2(context),
        ),
        maxLines: 1,
      ),
    );
  }

  TableCell emptyCell() {
    return TableCell(
      child: Container(),
    );
  }

  TableCell columnMajorHeaders(String header, BuildContext context) {
    return TableCell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: AutoSizeText(
              header,
              style: TextStyle(
                  fontSize: Device.fontTable(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  TableCell autonomousDetails(
      String value1,
      String value2,
      Color backgroundColor,
      Color textColor,
      bool headers,
      BuildContext context) {
    return TableCell(
      child: Row(children: <Widget>[
        smallCellContainer(
            65.0, value1, backgroundColor, textColor, headers, context),
        smallCellContainer(
            65.0, value2, backgroundColor, textColor, headers, context),
      ]),
    );
  }

  TableCell teleopDetails(
      String value1,
      String value2,
      Color backgroundColor,
      Color textColor,
      bool headers,
      BuildContext context) {
    return TableCell(
      child: Row(children: <Widget>[
        smallCellContainer(
            70.0, value1, backgroundColor, textColor, headers, context),
        smallCellContainer(
            80.0, value2, backgroundColor, textColor, headers, context),
      ]),
    );
  }

  TableCell rankingPointDetails(
      String value1,
      String value2,
      String value3,
      Color backgroundColor,
      Color textColor,
      bool headers,
      BuildContext context) {
    return TableCell(
      child: Row(children: <Widget>[
        smallCellContainer(
            85.0, value1, backgroundColor, textColor, headers, context),
        smallCellContainer(
            85.0, value2, backgroundColor, textColor, headers, context),
        smallCellContainer(
            85.0, value3, backgroundColor, textColor, headers, context),
      ]),
    );
  }

  TableCell finalScoreDetails(String value1, Color backgroundColor,
      Color textColor, bool headers, BuildContext context) {
    return TableCell(
      child: smallCellContainer(
          100.0, value1, backgroundColor, textColor, headers, context),
    );
  }

  Container smallCellContainer(
      double cellWidth,
      String value,
      Color backgroundColor,
      Color textColor,
      bool headers,
      BuildContext context) {
    // if (value == "0") {
    return Container(
      width: cellWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: AutoSizeText(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Device.fontTable(context),
          color: textColor,
          fontWeight: headers ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  TableRow displayAllianceInfo(
      AllianceScorePrediction allianceStats, BuildContext context) {
    Color color = (allianceStats.color == "Blue") ? Colors.blue : Colors.red;

    return TableRow(children: [
      leadLabel(allianceStats.color, color, context),
      autonomousDetails(
          allianceStats.autoFuelPoints.toString(),
          allianceStats.autoClimbPoints.toString(),
          Colors.white,
          Colors.black,
          false,
          context),
      leadLabel(allianceStats.color, color, context),
      teleopDetails(
          allianceStats.teleopFuelPoints.toString(),
          allianceStats.teleopClimbPoints.toString(),
          Colors.white,
          Colors.black,
          false,
          context),
      leadLabel(allianceStats.color, color, context),
      rankingPointDetails(
          (allianceStats.fuelRankingPoints > 0) ? "\u2713" : "--",
          (allianceStats.fuelRankingPoints > 1) ? "\u2713" : "--",
          (allianceStats.climbRankingPoint) ? "\u2713" : "--",
          Colors.white,
          Colors.black,
          false,
          context),
      finalScoreDetails(allianceStats.totalPoints.toString(), Colors.white,
          Colors.black, false, context),
    ]);
  }

  TableCell leadLabel(
      String bannerLabel, Color backgroundColor, BuildContext context) {
    return TableCell(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(5.0),
        child: AutoSizeText(
          bannerLabel,
          style: TextStyle(
            fontSize: Device.fontTable(context),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
