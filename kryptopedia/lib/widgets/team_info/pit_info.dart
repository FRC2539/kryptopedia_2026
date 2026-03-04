import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/team_info/pit_info_photo.dart';
import 'package:kryptopedia/widgets/team_info/pit_info_robot_capabilities.dart';
import 'package:kryptopedia/widgets/team_info/pit_info_specs.dart';

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
              PitInfoRobotPhoto(scoutedPit: widget.scoutedPit!),
              PitInfoRobotSpecs(scoutedPit: widget.scoutedPit!),
              PitInfoRobotCapabilities(scoutedPit: widget.scoutedPit!),
            ],
          ),
      ],
    );
  }
}
