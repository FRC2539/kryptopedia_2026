import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/common/checkboxes.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/common/number_field.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';

class PitScoutingGame extends StatefulWidget {
  const PitScoutingGame({super.key});

  @override
  State<PitScoutingGame> createState() => _PitScoutingGameState();
}

class _PitScoutingGameState extends State<PitScoutingGame> {
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Robot Gameplay',
      children: [
        ResponsiveLayout(
          portraitMode: LayoutMode.singleColumn,
          landscapeMode: LayoutMode.twoColumn,
          group1: [
            CheckboxList(
              title: "Robot intakes from:",
              options: [
                MultiSelectOption(
                  value: FuelPickupMethod.ground,
                  label: 'Ground',
                ),
                MultiSelectOption(value: FuelPickupMethod.top, label: 'Top'),
              ],
              initialValues: scoutedPitSingleton.fuelPickupMethods,
              callback: (values) {
                scoutedPitSingleton.fuelPickupMethods = values;
              },
            ),
            CheckboxListTile(
              title: Text(
                "Robot has a turret",
                style: TextStyle(fontSize: Device.fontLabel(context)),
              ),
              value: scoutedPitSingleton.hasTurret,
              onChanged: (value) {
                setState(() {
                  scoutedPitSingleton.hasTurret = value!;
                });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
          ],
          group2: [
            NumberField(
              label: "Max fuel capacity",
            minValue: 0,
            maxValue: 504,
            startValue: scoutedPitSingleton.maxFuelCapacity,
            callback: (value) {
              scoutedPitSingleton.maxFuelCapacity = value;
            },
          ),
            NumberField(
              label: "Number of shooters",
              minValue: 0,
              maxValue: 5,
              startValue: scoutedPitSingleton.shooterNumber,
              callback: (value) {
                scoutedPitSingleton.shooterNumber = value;
              },
            )
        ]),
      ],
    );
  }
}
