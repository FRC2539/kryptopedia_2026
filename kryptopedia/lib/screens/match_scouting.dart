import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team.dart';
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
  final String alliance;
  final String match;

  const MatchScouting({
    super.key,
    required this.team,
    required this.alliance,
    required this.match,
  });

  @override
  State<MatchScouting> createState() => _MatchScoutingState();
}

class _MatchScoutingState extends State<MatchScouting> {
  // final DbScoutedMatch dbScoutedMatch = DbScoutedMatch();

  @override
  void initState() {
    super.initState();
    scoutedMatchSingleton.setToDefaults(widget.team.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Kryptopedia - Match Scouting",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
        leading: Container(),
      ),
      body: Column(
        children: [
          MatchBanner(
            team: widget.team.nickname,
            match: widget.match,
            alliance: widget.alliance,
          ),
          Expanded(
            child: ListView(
              children: [
                AutoMatchScouting(),
                TeleopMatchScouting(),
                EndgameMatchScouting(),
                ScoutingSave(
                  saveFunction: () async {
                    DbScoutedMatches dbScoutedMatch = DbScoutedMatches();
                    await dbScoutedMatch.insertScoutedmatch(
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
