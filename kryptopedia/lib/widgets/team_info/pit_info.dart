import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/scouted_pit.dart';

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
    return const Placeholder();
  }
}
