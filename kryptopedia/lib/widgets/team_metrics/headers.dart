import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum ColType {
  notUsed,
  teamNumber,
  eventRanking,
  eventOPR,
  kitBot,
  drivetrain,
  wheels,
  weight,
  autoFuelScored,
  autoFuelAverage,
  autoClimbedTotal,
  // autoClimbedPercent,
  teleopFuelScored,
  teleopFuelAverage,
  teleopFuelFed,
  teleopFuelFedAverage,
  teleopClimbedL1,
  teleopClimbedL2,
  teleopClimbedL3,
  offensePercent,
  defensePercent,
  feederPercent,
  startPositionLTrench,
  startPositionLBump,
  startPositionCenter,
  startPositionRBump,
  startPositionRTrench,
  startPositionNone,
}

class ColumnSelector {
  bool ascending = true;
  ColType columnHeader = ColType.teamNumber;
  ColType previousHeader = ColType.teamNumber;
}

class TopHeaderRow extends StatelessWidget {
  const TopHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (75.0 * 31.0) + 85.0,
      child: Row(
        children: [
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          headerCell("Event Info", 3 * 75.0, 30.0, null, ColType.notUsed),
          headerCell(
            "Robot Info",
            85.0 + (2 * 75.0),
            30.0,
            null,
            ColType.notUsed,
          ),
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          headerCell("Fuel Info", 6 * 75.0, 30.0, null, ColType.notUsed),
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          headerCell("Climbing Info", 4 * 75.0, 30.0, null, ColType.notUsed),
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          headerCell("Roles Info", 3 * 75.0, 30.0, null, ColType.notUsed),
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          headerCell(
            "Start Positions Info",
            6 * 75.0,
            30.0,
            null,
            ColType.notUsed,
          ),
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
        ],
      ),
    );
  }
}

class BottomHeaderRow extends StatelessWidget {
  final ValueNotifier<ColumnSelector> sortNotifier;

  const BottomHeaderRow({super.key, required this.sortNotifier});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (75.0 * 30.0) + 85.0,
      child: Row(
        children: [
          headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          headerCell("Match\nCount", 75.0, 50.0, null, ColType.notUsed),
          headerCell(
            "Event\nRanking",
            75.0,
            50.0,
            sortNotifier,
            ColType.eventRanking,
          ),
          headerCell("Event\nOPR", 75.0, 50.0, sortNotifier, ColType.eventOPR),
          headerCell("Kit\nBot", 75.0, 50.0, sortNotifier, ColType.kitBot),
          headerCell(
            "Drivetrain",
            85.0,
            50.0,
            sortNotifier,
            ColType.drivetrain,
          ),
          headerCell("Weight", 75.0, 50.0, sortNotifier, ColType.weight),
          headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          headerCell(
            "Auto\nTotals",
            75.0,
            50.0,
            sortNotifier,
            ColType.autoFuelScored,
          ),
          headerCell(
            "Auto\nAverage",
            75.0,
            50.0,
            sortNotifier,
            ColType.autoFuelAverage,
          ),
          headerCell(
            "Teleop\nTotals",
            75.0,
            50.0,
            sortNotifier,
            ColType.teleopFuelScored,
          ),
          headerCell(
            "Teleop\nAverage",
            75.0,
            50.0,
            sortNotifier,
            ColType.teleopFuelAverage,
          ),
          headerCell(
            "Fed\nTotals",
            75.0,
            50.0,
            sortNotifier,
            ColType.teleopFuelFed,
          ),
          headerCell(
            "Fed\nAverage",
            75.0,
            50.0,
            sortNotifier,
            ColType.teleopFuelFedAverage,
          ),
          headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          headerCell(
            "Auto\nL1",
            75.0,
            50.0,
            sortNotifier,
            ColType.autoClimbedTotal,
          ),
          // headerCell(
          //   "Auto\nL1 %",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.autoClimbedPercent,
          // ),
          headerCell(
            "Teleop\nL1",
            75.0,
            50.0,
            sortNotifier,
            ColType.teleopClimbedL1,
          ),
          // headerCell(
          //   "Teleop\nL1 %",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopClimbedL1,
          // ),
          headerCell(
            "Teleop\nL2",
            75.0,
            50.0,
            sortNotifier,
            ColType.teleopClimbedL2,
          ),
          // headerCell(
          //   "Teleop\nL2 %",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopClimbedL2,
          // ),
          headerCell(
            "Teleop\nL3",
            75.0,
            50.0,
            sortNotifier,
            ColType.teleopClimbedL3,
          ),
          // headerCell(
          //   "Teleop\nL3 %",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopClimbedL3,
          // ),
          headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          headerCell(
            "Offense",
            75.0,
            50.0,
            sortNotifier,
            ColType.offensePercent,
          ),
          headerCell(
            "Defense",
            75.0,
            50.0,
            sortNotifier,
            ColType.defensePercent,
          ),
          headerCell("Feeder", 75.0, 50.0, sortNotifier, ColType.feederPercent),
          headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          headerCell(
            "Left Trench",
            75.0,
            50.0,
            sortNotifier,
            ColType.startPositionLTrench,
          ),
          headerCell(
            "Left Bump",
            75.0,
            50.0,
            sortNotifier,
            ColType.startPositionLBump,
          ),
          headerCell(
            "Center",
            75.0,
            50.0,
            sortNotifier,
            ColType.startPositionCenter,
          ),
          headerCell(
            "Right Bump",
            75.0,
            50.0,
            sortNotifier,
            ColType.startPositionRBump,
          ),
          headerCell(
            "Right Trench",
            75.0,
            50.0,
            sortNotifier,
            ColType.startPositionRTrench,
          ),
          headerCell(
            "No Show",
            75.0,
            50.0,
            sortNotifier,
            ColType.startPositionNone,
          ),
          headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          // headerCell(
          //   "EPA-ish",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.totalPredictedScore,
          // ),
        ],
      ),
    );
  }
}

SizedBox headerCell(
  String label,
  double cellWidth,
  double cellHeight,
  ValueNotifier<ColumnSelector>? sortNotifier,
  ColType colType,
) {
  Align headerText = Align(
    alignment: Alignment.center,
    child: AutoSizeText(
      label,
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
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        color: Colors.white,
      ),
      child: (colType != ColType.notUsed)
          ? GestureDetector(
              onTap: () {
                // Determine the sort order
                ColumnSelector tempSelector = ColumnSelector();

                tempSelector.ascending =
                    (sortNotifier!.value.columnHeader == colType)
                    ? !(sortNotifier.value.ascending)
                    : true;
                tempSelector.columnHeader = colType;

                sortNotifier.value = tempSelector;
              },
              child: headerText,
            )
          : headerText,
    ),
  );
}
