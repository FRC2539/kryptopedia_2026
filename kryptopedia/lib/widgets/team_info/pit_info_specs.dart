import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/widgets/common/label.dart';
import 'package:kryptopedia/widgets/team_info/team_tables.dart';

class PitInfoRobotSpecs extends StatelessWidget {
  final ScoutedPit scoutedPit;

  const PitInfoRobotSpecs({super.key, required this.scoutedPit});

  @override
  Widget build(BuildContext context) {
    String driveTrain = "Unknown";
    String wheelType = "Unknown";
    switch (scoutedPit.drivetrain) {
      case Drivetrain.swerve:
        driveTrain = "Swerve";
        break;
      case Drivetrain.tank:
        driveTrain = "Tank";
        break;
      case Drivetrain.mecanum:
        driveTrain = "Mecanum";
        break;
      case Drivetrain.other:
        driveTrain = "Other";
        break;
    }
    switch (scoutedPit.wheelType) {
      case WheelType.colson:
        wheelType = "Colson";
        break;
      case WheelType.billet:
        wheelType = "Billet";
        break;
      case WheelType.spike:
        wheelType = "Spike";
        break;
      case WheelType.other:
        wheelType = "Other";
        break;
    }

    return Column(
      children: [
        TextLabel(label: 'Robot Specs', headerLabel: true),
        const SizedBox(height: 5.0),
        Container(
          padding: const EdgeInsets.only(
            top: 0.0,
            right: 5.0,
            left: 0.0,
            bottom: 5.0,
          ),
          height: (30.0 * 5), // # of data rows * Row Height
          child: Table(
            defaultColumnWidth: IntrinsicColumnWidth(),
            children: [
              TableRow(
                children: [
                  TeamInfoTables.displayCell(
                    "Robot Base Dimensions (width / depth): ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    "${scoutedPit.width} / ${scoutedPit.depth}",
                    false,
                    context,
                    140.0,
                    Colors.white,
                    Colors.black,
                    false,
                  ),
                ],
              ),
              TableRow(
                children: [
                  TeamInfoTables.displayCell(
                    "Robot Weight (lbs): ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    "${scoutedPit.weight}",
                    false,
                    context,
                    140.0,
                    Colors.white,
                    Colors.black,
                    false,
                  ),
                ],
              ),
              TableRow(
                children: [
                  TeamInfoTables.displayCell(
                    "Robot Height (start / max): ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    "${scoutedPit.startingHeight} / ${scoutedPit.extendedHeight}",
                    false,
                    context,
                    140.0,
                    Colors.white,
                    Colors.black,
                    false,
                  ),
                ],
              ),
              TableRow(
                children: [
                  TeamInfoTables.displayCell(
                    "Robot Drivetrain: ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    driveTrain,
                    false,
                    context,
                    140.0,
                    Colors.white,
                    Colors.black,
                    false,
                  ),
                ],
              ),
              TableRow(
                children: [
                  TeamInfoTables.displayCell(
                    "Robot Wheel Type: ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    wheelType,
                    false,
                    context,
                    140.0,
                    Colors.white,
                    Colors.black,
                    false,
                  ),
                ],
              ),
              TableRow(
                children: [
                  TeamInfoTables.displayCell(
                    "Robot is a Kit Bot: ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    scoutedPit.isKitBot ? "Yes" : "No",
                    false,
                    context,
                    140.0,
                    Colors.white,
                    Colors.black,
                    false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
