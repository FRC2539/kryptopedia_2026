import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum ColType {
  notUsed,
  teamNumber,
  eventRanking,
  eventOPR,
  drivetrain,
  weight,
  autoCoralScoring,
  autoAlgaeScoring,
  teleopCoralScoring,
  teleopAlgaeScoring,
  totalPredictedScore,
  teleopCoralLevel1,
  teleopCoralLevel2,
  teleopCoralLevel3,
  teleopCoralLevel4,
  teleopCoralPiecesTotal,
  teleopCoralPiecesAverage,
  teleopEndGameShallow,
  teleopEndGameDeep,
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
      width: (75.0 * 21.0) + 85.0,
      child: Row(
        children: [
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          headerCell("Event Info", 3 * 75.0, 30.0, null, ColType.notUsed),
          headerCell("Robot Info", 85.0 + 75.0, 30.0, null, ColType.notUsed),
          headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          // headerCell("Scoring Info", 5 * 75.0, 30.0, null, ColType.notUsed),
          // headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
          // headerCell("End Game Info", 8 * 75.0, 30.0, null, ColType.notUsed),
          // headerCell(" ", 75.0, 30.0, null, ColType.notUsed),
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
      width: (75.0 * 21.0) + 85.0,
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
          headerCell(
            "Drivetrain",
            85.0,
            50.0,
            sortNotifier,
            ColType.drivetrain,
          ),
          headerCell("Weight", 75.0, 50.0, sortNotifier, ColType.weight),
          headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          // headerCell(
          //   "Auto\nCoral",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.autoCoralScoring,
          // ),
          // headerCell(
          //   "Auto\nAlgae",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.autoAlgaeScoring,
          // ),
          // headerCell(
          //   "Teleop\nCoral",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopCoralScoring,
          // ),
          // headerCell(
          //   "Teleop\nAlgae",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopAlgaeScoring,
          // ),
          // headerCell(
          //   "EPA-ish",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.totalPredictedScore,
          // ),
          // headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
          // headerCell(
          //   "Coral Level 1",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopCoralLevel1,
          // ),
          // headerCell(
          //   "Coral Level 2",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopCoralLevel2,
          // ),
          // headerCell(
          //   "Coral Level 3",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopCoralLevel3,
          // ),
          // headerCell(
          //   "Coral Level 4",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopCoralLevel4,
          // ),
          // headerCell(
          //   "Total Coral",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopCoralPiecesTotal,
          // ),
          // headerCell(
          //   "Average Coral",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopCoralPiecesAverage,
          // ),
          // headerCell(
          //   "Shallow Climb",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopEndGameShallow,
          // ),
          // headerCell(
          //   "Deep Climb",
          //   75.0,
          //   50.0,
          //   sortNotifier,
          //   ColType.teleopEndGameDeep,
          // ),
          // headerCell("Team #", 75.0, 50.0, sortNotifier, ColType.teamNumber),
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
