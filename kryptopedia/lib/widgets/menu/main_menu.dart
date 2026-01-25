import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/screens/pit_scouting.dart';
import 'package:kryptopedia/widgets/menu/section.dart';
import 'package:kryptopedia/widgets/menu/version_number.dart';

var defaultTeam = Team(0, "Default Team");
var defaultEvent = Event(0, "Default Event", "", 0);

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext c) {
    return ListView(
      children: [
        // Scouting
        MenuSection([
          MenuItemDefinition(
            title: "Pit Scouting",
            icon: Icons.construction,
            landscapeWidget: PitScouting(
              team: defaultTeam,
              event: defaultEvent,
            ),
            portraitWidget: PitScouting(event: defaultEvent, team: defaultTeam),
          ),
        ]),

        const VersionNumber(),
      ],
    );
  }
}
