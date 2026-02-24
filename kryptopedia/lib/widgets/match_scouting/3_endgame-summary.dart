import 'package:flutter/material.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
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
