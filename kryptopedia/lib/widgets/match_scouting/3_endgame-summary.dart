import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/checkboxes.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/text_field.dart';

class EndgameMatchScouting extends StatefulWidget {
  const EndgameMatchScouting({super.key});

  @override
  State<EndgameMatchScouting> createState() => _EndgameMatchScoutingState();
}

class _EndgameMatchScoutingState extends State<EndgameMatchScouting> {

  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Endgame/Summary',
      children: [
        DropdownList(
          label: 'Climb level',
          initialValue: scoutedMatchSingleton.climbLevel,
          options: [
            MultiSelectOption(value: ClimbLevel.none, label: 'No climb'),
            MultiSelectOption(value: ClimbLevel.L1, label: 'L1'),
            MultiSelectOption(value: ClimbLevel.L2, label: 'L2'),
            MultiSelectOption(value: ClimbLevel.L3, label: 'L3'),
          ],
          callback: (newValue) {
            scoutedMatchSingleton.climbLevel = newValue;
          },
        ),
        DropdownList(
          label: 'Penalties',
          initialValue: scoutedMatchSingleton.penalties,
          options: [
            MultiSelectOption(value: Penalties.none, label: 'None'),
            MultiSelectOption(value: Penalties.few, label: 'Few'),
            MultiSelectOption(value: Penalties.many, label: 'Many'),
          ],
          callback: (newValue) {
            scoutedMatchSingleton.penalties = newValue;
          },
        ),
        CheckboxList<RobotRole>(
          title: "Roles",
          options: [
            MultiSelectOption(value: RobotRole.offense, label: "Offense"),
            MultiSelectOption(value: RobotRole.defense, label: "Defense"),
            MultiSelectOption(value: RobotRole.feeder, label: "Feeder"),
          ],
          initialValues: scoutedMatchSingleton.robotRoles,
          callback: (values) => scoutedMatchSingleton.robotRoles = values,
        ),
        DropdownList(
          label: "Issues?",
          initialValue: 0,
          options: [
            MultiSelectOption(value: 0, label: "None"),
            MultiSelectOption(value: 1, label: "Minor"),
            MultiSelectOption(value: 2, label: "Major"),
          ],
          callback: (value) {
            scoutedMatchSingleton.issues = value;
          },
        ),
        TextInputField(
          label: "Comments",
          hint:
              "general comments: describe anything eventful, mostly.\nparticularly, please be sure to describe any penalties, issues, or defense.",
              isMultiline: true,
              initialValue: "",
              callback: (value) {
                scoutedMatchSingleton.generalComments = value;
              },
            ),
      ]
    );
  }
}
