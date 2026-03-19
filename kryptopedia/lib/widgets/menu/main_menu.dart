import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/match_scouting_select.dart';
import 'package:kryptopedia/dialogs/pit_scouting_select.dart';
import 'package:kryptopedia/dialogs/predictions_debug.dart';
import 'package:kryptopedia/screens/alliance_selection.dart';
import 'package:kryptopedia/screens/match_preview.dart';
import 'package:kryptopedia/screens/manage_team_flags.dart';
import 'package:kryptopedia/screens/pdf_viewer.dart';
import 'package:kryptopedia/screens/pit_map.dart';
import 'package:kryptopedia/screens/qualification_schedule.dart';
import 'package:kryptopedia/screens/team_info.dart';
import 'package:kryptopedia/screens/team_metrics.dart';
import 'package:kryptopedia/screens/test_haptics.dart';
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
              builder: (context) => ScoutMatchSelectionDialog(),
            ),
          ),
          MenuItemDefinition(
            title: "Manage Flags",
            icon: Icons.flag,
            landscapeWidget: ManageTeamFlags(),
            portraitWidget: ManageTeamFlags(),
          ),
        ]),

        //Gameplay
        MenuSection(([
          MenuItemDefinition(
            title: 'Match Preview',
            icon: Icons.batch_prediction,
            landscapeWidget: MatchPreview(),
          ),
          MenuItemDefinition(
            title: "Alliance Selection",
            icon: Icons.dashboard_customize,
            landscapeWidget: AllianceSelection(),
          ),
          MenuItemDefinition(
            title: "Predictions Debug",
            icon: Icons.bug_report,
            onTap: (context) => showDialog(
              context: context,
              builder: (context) => PredictionsDebugDialog(),
            ),
            debugOnly: true,
          ),
        ])),

        // Info
        MenuSection([
          MenuItemDefinition(
            title: "Team Info",
            icon: Icons.info,
            landscapeWidget: TeamInfo(passedTeamID: -1),
            portraitWidget: TeamInfo(passedTeamID: -1),
          ),
          MenuItemDefinition(
            title: "All Team Metrics",
            icon: Icons.table_view,
            landscapeWidget: TeamMetrics(),
            portraitWidget: TeamMetrics(),
          ),
        ]),

        // Resources
        MenuSection([
          MenuItemDefinition(
            title: "Pit Map",
            icon: Icons.map_outlined,
            portraitWidget: PitMapViewer(),
            landscapeWidget: PitMapViewer(),
          ),
          MenuItemDefinition(
            title: "Qualifications Schedule",
            icon: Icons.assignment,
            portraitWidget: QualificationMatchSchedule(),
            landscapeWidget: QualificationMatchSchedule(),
          ),
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
          MenuItemDefinition(
            title: "Test Haptics",
            icon: Icons.vibration,
            portraitWidget: TestHaptics(),
            debugOnly: true,
          ),
        ]),

        const VersionNumber(),
      ],
    );
  }
}
