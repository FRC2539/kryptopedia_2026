import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/match_scouting_select.dart';
import 'package:kryptopedia/dialogs/pit_scouting_select.dart';
import 'package:kryptopedia/screens/manage_team_flags.dart';
import 'package:kryptopedia/screens/pdf_viewer.dart';
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
          MenuItemDefinition(
            title: "Match Scouting",
            icon: Icons.person_4,
            onTap: (context) => showDialog(
              context: context,
              builder: (context) => ScoutmatchSelectionDialog(),
            ),
          ),
          MenuItemDefinition(
            title: "Manage Flags",
            icon: Icons.flag,
            landscapeWidget: ManageTeamFlags(),
          )
        ]),

        // Resources
        MenuSection([
          MenuItemDefinition(
            title: "Game Manual",
            icon: Icons.menu_book,
            portraitWidget: PdfViewerScreen(
              pdfPath: "assets/pdfs/2026GameManual.pdf",
              title: "Game Manual",
            ),
            landscapeWidget: PdfViewerScreen(
              pdfPath: "assets/pdfs/2026GameManual.pdf",
              title: "Game Manual",
            ),
          ),
        ]),

        const VersionNumber(),
      ],
    );
  }
}
