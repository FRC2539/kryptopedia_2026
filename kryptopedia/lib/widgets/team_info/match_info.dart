import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';

class TeamInfoMatches extends StatefulWidget {
  final List<ScoutedMatch> scoutedMatches;

  const TeamInfoMatches({super.key, required this.scoutedMatches});

  @override
  State<TeamInfoMatches> createState() => _TeamInfoMatchesState();
}

class _TeamInfoMatchesState extends State<TeamInfoMatches> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
