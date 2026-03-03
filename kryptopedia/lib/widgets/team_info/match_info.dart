import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/info_not_available.dart';

class TeamInfoMatches extends StatelessWidget {
  final List<ScoutedMatch> scoutedMatches;

  const TeamInfoMatches({super.key, required this.scoutedMatches});

  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Match Scouting Information',
      children: [
        if (scoutedMatches.isNotEmpty)
          Column(
            // children: [TeamInfoMatchesAuto(scoutedMatches: scoutedMatches)],
          )
        else
          InformationNotAvailable(
            infoDescription: 'Match scouting information',
          ),
      ],
    );
  }
}
