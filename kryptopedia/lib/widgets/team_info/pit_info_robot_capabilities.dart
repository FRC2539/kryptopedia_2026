import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/widgets/common/label.dart';
import 'package:kryptopedia/widgets/team_info/team_tables.dart';

class PitInfoRobotCapabilities extends StatelessWidget {
  final ScoutedPit scoutedPit;

  const PitInfoRobotCapabilities({super.key, required this.scoutedPit});

  @override
  Widget build(BuildContext context) {
    String fuelPickupMethod = "None?????";
    if (scoutedPit.fuelPickupMethods.contains(FuelPickupMethod.top) &&
        scoutedPit.fuelPickupMethods.contains(FuelPickupMethod.ground)) {
      fuelPickupMethod = "Both";
    } else if (scoutedPit.fuelPickupMethods.contains(FuelPickupMethod.top)) {
      fuelPickupMethod = "Top";
    } else if (scoutedPit.fuelPickupMethods.contains(FuelPickupMethod.ground)) {
      fuelPickupMethod = "Ground";
    }

    return Column(
      children: [
        TextLabel(label: 'Robot Capabilities', headerLabel: true),
        const SizedBox(height: 5.0),
        Container(
          padding: const EdgeInsets.only(
            top: 0.0,
            right: 5.0,
            left: 0.0,
            bottom: 5.0,
          ),
          height: (30.0 * 7), // # of data rows * Row Height
          child: Table(
            defaultColumnWidth: IntrinsicColumnWidth(),
            children: [
              TableRow(
                children: [
                  TeamInfoTables.displayCell(
                    "Fuel Pickup Method: ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    fuelPickupMethod,
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
                    "Has turret:",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    scoutedPit.hasTurret ? "Yes" : "No",
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
                    "Max fuel capacity: ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    scoutedPit.maxFuelCapacity.toString(),
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
                    "Number of shooters: ",
                    true,
                    context,
                    200.0,
                    Colors.black,
                    Colors.white,
                    false,
                  ),
                  TeamInfoTables.displayCell(
                    scoutedPit.shooterNumber.toString(),
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
