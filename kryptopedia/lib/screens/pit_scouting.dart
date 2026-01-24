import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/singletons.dart';
// import 'package:kryptopedia/util/dbhelpers/dbscoutedpit.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/common/banners.dart';
import 'package:kryptopedia/widgets/common/save.dart';
import 'package:kryptopedia/widgets/pit_scouting/1_specs.dart';
import 'package:kryptopedia/widgets/pit_scouting/2_game.dart';
import 'package:kryptopedia/widgets/pit_scouting/3_summary.dart';

class PitScouting extends StatefulWidget {
  final Event event;
  final Team team;

  const PitScouting({super.key, required this.event, required this.team});

  @override
  State<PitScouting> createState() => _PitScoutingState();
}

class _PitScoutingState extends State<PitScouting> {
  // final DbScoutedPit dbScoutedPit = DbScoutedPit();

  @override
  void initState() {
    super.initState();
    scoutedPitSingleton.setToDefaults(
      widget.event.id,
      widget.team.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            "Kryptopedia - Pit Scouting",
            style: TextStyle(fontSize: Device.fontHeader(context)),
            maxLines: 1,
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
                  ScoutingSave(saveFunction: () {
                    // DbScoutedPit dbScoutedPit = DbScoutedPit();
                    // dbScoutedPit.insertScoutedPit(scoutedPitSingleton);
                    return "Event: ${widget.event.id}\nTeam: ${widget.team.number}\n${widget.team.nickname}";
                  })
                ],
              ),
            )
          ],
        ));
  }
}
