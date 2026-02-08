import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/common/banners.dart';
import 'package:kryptopedia/widgets/common/save.dart';
import 'package:kryptopedia/widgets/pit_scouting/1_specs.dart';
import 'package:kryptopedia/widgets/pit_scouting/2_game.dart';
import 'package:kryptopedia/widgets/pit_scouting/3_summary.dart';

class PitScouting extends StatefulWidget {
  final Team team;
  final TeamMember scouter;

  const PitScouting({super.key, required this.team, required this.scouter});

  @override
  State<PitScouting> createState() => _PitScoutingState();
}

class _PitScoutingState extends State<PitScouting> {
  @override
  void initState() {
    super.initState();
    scoutedPitSingleton.setToDefaults(widget.team.number, widget.scouter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AutoSizeText(
              "Kryptopedia - Pit Scouting",
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
        leading: Container(),
      ),
      body: Column(
        children: [
          PitBanner("${widget.team.number} - ${widget.team.nickname}"),
          Expanded(
            child: ListView(
              children: [
                PitScoutingSpecs(),
                PitScoutingGame(),
                PitScoutingSummary(),
                ScoutingSave(
                  saveFunction: () async {
                    DbScoutedPits dbScoutedPit = DbScoutedPits();
                    await dbScoutedPit.upsertScoutedPit(scoutedPitSingleton);
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
