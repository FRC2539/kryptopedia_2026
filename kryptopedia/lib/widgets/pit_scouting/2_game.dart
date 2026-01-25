import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/util/singletons.dart';
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
              MultiSelectOption(value: FuelPickupMethod.ground, label: 'Ground'),
              MultiSelectOption(value: FuelPickupMethod.top, label: 'Top'),
            ],
            initialValues: scoutedPitSingleton.fuelPickupMethods,
            callback: (values) {
              scoutedPitSingleton.fuelPickupMethods = values;
            }
          ),
          DropdownList(
            label: "Shooter type",
            options: [
              MultiSelectOption(value: ShooterType.noTurret, label: 'No Turret'),
              MultiSelectOption(value: ShooterType.singleTurret, label: 'Single Turret'),
              MultiSelectOption(value: ShooterType.doubleTurret, label: 'Double Turret'),
            ],
            initialValue: scoutedPitSingleton.shooterType,
            callback: (value) {
              scoutedPitSingleton.shooterType = value;
            },
          )
          ],
          group2: [
          NumberField(label: "Max Fuel Capacity",
            minValue: 0,
            maxValue: 504,
            startValue: scoutedPitSingleton.maxFuelCapacity,
            callback: (value) {
              scoutedPitSingleton.maxFuelCapacity = value;
            },
          ),
        ]),
      ],
    );
  }
}
