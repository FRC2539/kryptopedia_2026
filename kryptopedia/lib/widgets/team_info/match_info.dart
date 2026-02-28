import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';

class TeamInfoMatchInfo extends StatefulWidget {
  final List<ScoutedMatch> scoutedMatches;
  final ScoutedPit? scoutedPit;
  final List<Team> teamList;

  const TeamInfoMatchInfo({
    super.key,
    required this.scoutedMatches,
    required this.scoutedPit,
    required this.teamList,
  });

  @override
  State<TeamInfoMatchInfo> createState() => _TeamInfoMatchInfoState();
}

class _TeamInfoMatchInfoState extends State<TeamInfoMatchInfo> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
