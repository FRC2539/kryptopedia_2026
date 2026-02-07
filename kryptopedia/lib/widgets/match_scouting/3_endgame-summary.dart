import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/common/number_field.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/super_number_field.dart';
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
        ResponsiveLayout(
          portraitMode: LayoutMode.singleColumn,
          landscapeMode: LayoutMode.twoColumn,
          group1: [
            TextInputField(
              hint: "auto comments",
              isMultiline: true,
              initialValue: "",
              callback: (value) {
                scoutedMatchSingleton.autoComments = value;
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
            TextInputField(
              hint: "general comments: penalties, strategies, issues",
              isMultiline: true,
              initialValue: "",
              callback: (value) {
                scoutedMatchSingleton.generalComments = value;
              },
            ),
          ],
        ),
      ],
    );
  }
}
