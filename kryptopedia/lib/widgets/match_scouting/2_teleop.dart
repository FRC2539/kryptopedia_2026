import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/common/number_field.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/super_number_field.dart';
import 'package:kryptopedia/widgets/common/text_field.dart';

class TeleopMatchScouting extends StatefulWidget {
  const TeleopMatchScouting({super.key});

  @override
  State<TeleopMatchScouting> createState() => _TeleopMatchScoutingState();
}

class _TeleopMatchScoutingState extends State<TeleopMatchScouting> {
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Teleop Stats',
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
              startValue: scoutedMatchSingleton.teleopFuelScored,
              callback: (int newValue) {
                scoutedMatchSingleton.teleopFuelScored = newValue;
              },
            ),
            TextInputField(
              hint: "defense comments",
              isMultiline: true,
              initialValue: "",
              callback: (value) {
                scoutedMatchSingleton.defenseComments = value;
              },
            ),
          ],
          group2: [
            SuperNumberField(
              label: "Fuel fed",
              minValue: 0,
              maxValue: 6767,
              superStep: 8,
              startValue: scoutedMatchSingleton.teleopFuelFed,
              callback: (int newValue) {
                scoutedMatchSingleton.teleopFuelFed = newValue;
              },
            ),
          ],
        ),
      ],
    );
  }
}
