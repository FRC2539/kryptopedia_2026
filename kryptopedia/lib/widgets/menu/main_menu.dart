import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/pit_scouting_select.dart';
import 'package:kryptopedia/widgets/menu/section.dart';
import 'package:kryptopedia/widgets/menu/version_number.dart';


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
            onTap: (context) => showDialog(
              context: context,
              builder: (context) => ScoutPitSelectionDialog(),
            ),
          ),
        ]),

        const VersionNumber(),
      ],
    );
  }
}
