import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/common/banners.dart';
import 'package:kryptopedia/widgets/common/save.dart';
import 'package:kryptopedia/widgets/match_scouting/1_auto.dart';
import 'package:kryptopedia/widgets/match_scouting/2_teleop.dart';
import 'package:kryptopedia/widgets/match_scouting/3_endgame-summary.dart';

class MatchScouting extends StatefulWidget {
  final Team team;
  final EventMatch match;
  final String alliancePosition;
  final TeamMember scouter;
  final bool preserve;

  const MatchScouting({
    super.key,
    required this.team,
    required this.alliancePosition,
    required this.match,
    required this.scouter,
    this.preserve = false,
  });

  @override
  State<MatchScouting> createState() => _MatchScoutingState();
}

class _MatchScoutingState extends State<MatchScouting> {
  // final DbScoutedMatch dbScoutedMatch = DbScoutedMatch();

  @override
  void initState() {
    super.initState();
    if (!widget.preserve) {
      scoutedMatchSingleton.setToDefaults(
        widget.match,
        widget.team.number,
        widget.scouter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AutoSizeText(
              "Kryptopedia - Match Scouting",
              style: TextStyle(fontSize: Device.fontHeader(context)),
              maxLines: 1,
            ),
            Spacer(),
            AutoSizeText(
              "Scouter: ${widget.scouter.name}",
              style: TextStyle(fontSize: Device.fontHeader(context) * 0.7),
              maxLines: 1,
            ),
          ],
        ),
        leading: widget.preserve ? null : Container(),
      ),
      body: Column(
        children: [
          MatchBanner(
            team: widget.team.nickname,
            match: widget.match,
            alliancePosition: widget.alliancePosition,
          ),
          Expanded(
            child: ListView(
              children: [
                AutoMatchScouting(),
                TeleopMatchScouting(),
                EndgameMatchScouting(),
                if (!widget.preserve)
                  ScoutingSave(
                  saveFunction: () async {
                    DbScoutedMatches dbScoutedMatch = DbScoutedMatches();
                    await dbScoutedMatch.upsertScoutedMatch(
                      scoutedMatchSingleton,
                    );
                    return "Team: ${widget.team.number}\n${widget.team.nickname}";
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
