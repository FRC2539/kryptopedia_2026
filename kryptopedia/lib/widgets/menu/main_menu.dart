import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scoutedpit.dart';
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
            landscapeWidget: PitScouting(team: defaultTeam, event: defaultEvent),
            dev: true,
          ),
          MenuItemDefinition(
            title: "show a snack bar",
            icon: Icons.food_bank,
            onTap: (context) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("oh bingo i got action")),
            ),
          ),
        ]),

        const VersionNumber(),
      ],
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Placeholder")),
      body: const Center(child: Placeholder()),
    );
  }
}
