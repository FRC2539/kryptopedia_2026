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
            options: const [
              // the two values are linked and they must be unlinked. i think they both update the first value in the list.
              MultiSelectOption(value: true, label: 'Ground'),
              MultiSelectOption(value: true, label: 'Top'),
            ],
            initialValues: [false, false],
            callback: (List<bool> newValues) {
              scoutedPitSingleton.hasGroundIntake = newValues[0];
              scoutedPitSingleton.hasTopIntake = newValues[1];
            }
          ),
        ], column2: [
          
        ])
      ],
    );
  }
}
