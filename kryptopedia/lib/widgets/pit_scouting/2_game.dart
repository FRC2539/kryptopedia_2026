import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scoutedpit.dart';
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
        CombinedColumnLayout(column1: [
          CheckboxList(
            title: "Robot intakes from:",
            options: [
              // the two values are linked and they must be unlinked. i think they both update the first value in the list.
              MultiSelectOption(value: FuelPickupMethod.ground, label: 'Ground'),
              MultiSelectOption(value: FuelPickupMethod.top, label: 'Top'),
            ],
            initialValues: scoutedPitSingleton.fuelPickupMethods,
            callback: (values) {
              scoutedPitSingleton.fuelPickupMethods = values;
            }
          ),
        ], column2: [
          
        ]),
      ],
    );
  }
}
