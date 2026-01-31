import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/common/number_field.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/super_number_field.dart';

class AutoMatchScouting extends StatefulWidget {
  const AutoMatchScouting({super.key});

  @override
  State<AutoMatchScouting> createState() => _AutoMatchScoutingState();
}

class _AutoMatchScoutingState extends State<AutoMatchScouting> {
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Auto Stats',
      children: [
        ResponsiveLayout(
          portraitMode: LayoutMode.singleColumn,
          landscapeMode: LayoutMode.twoColumn,
          group1: [
            SuperNumberField(
              label: "Fuel scored",
              minValue: 0,
              maxValue: 6767,
              superStep: 8,
              startValue: scoutedMatchSingleton.autoFuelScored,
              callback: (int newValue) {
                scoutedMatchSingleton.autoFuelScored = newValue;
              },
            ),
            CheckboxListTile(
              title: const Text("Robot climbed at end of auto"),
              value: scoutedMatchSingleton.autoClimbed,
              onChanged: (value) {
                setState(() {
                  scoutedMatchSingleton.autoClimbed = value!;
                });
              },
            ),
          ],
          group2: [
            SuperNumberField(
              label: "Fuel stored at end of auto",
              minValue: 0,
              maxValue: 6767,
              superStep: 10,
              startValue: scoutedMatchSingleton.autoFuelFinal,
              callback: (int newValue) {
                scoutedMatchSingleton.autoFuelFinal = newValue;
              },
            ),
          ],
        ),
      ],
    );
  }
}
