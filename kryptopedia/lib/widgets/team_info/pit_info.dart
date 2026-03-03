import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/info_not_available.dart';

class TeamInfoPitInfo extends StatefulWidget {
  final ScoutedPit? scoutedPit;
  final Team team;

  const TeamInfoPitInfo({
    super.key,
    required this.scoutedPit,
    required this.team,
  });

  @override
  State<TeamInfoPitInfo> createState() => _TeamInfoPitInfoState();
}

class _TeamInfoPitInfoState extends State<TeamInfoPitInfo> {
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Pit Scouting Information',
      children: [
        if (widget.scoutedPit != null)
          Column(
            children: [
              Text('Robot Weight: ${widget.scoutedPit!.weight}'),
              Text('Drive Type: ${widget.scoutedPit!.drivetrain}'),
            ],
          )
        else
          InformationNotAvailable(infoDescription: 'Pit scouting information'),
      ],
    );
  }
}
