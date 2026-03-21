import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/scouter_select.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/screens/pit_scouting.dart';
import 'package:kryptopedia/widgets/common/info_not_available.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/team_info/pit_info_photo.dart';
import 'package:kryptopedia/widgets/team_info/pit_info_robot_capabilities.dart';
import 'package:kryptopedia/widgets/team_info/pit_info_specs.dart';

class TeamInfoPitInfo extends StatefulWidget {
  final ScoutedPit? scoutedPit;
  final Team team;
  final Function(BuildContext context)? onUpdate;

  const TeamInfoPitInfo({
    super.key,
    required this.scoutedPit,
    required this.team,
    this.onUpdate,
  });

  @override
  State<TeamInfoPitInfo> createState() => _TeamInfoPitInfoState();
}

class _TeamInfoPitInfoState extends State<TeamInfoPitInfo> {
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Pit Scouting Information',
      children: [
        if (widget.scoutedPit != null)
          Column(
            children: [
              PitInfoRobotPhoto(
                scoutedPit: widget.scoutedPit!,
                team: widget.team,
              ),
              ResponsiveLayout(
                portraitMode: LayoutMode.singleColumn,
                landscapeMode: LayoutMode.twoColumn,
                group1: [PitInfoRobotSpecs(scoutedPit: widget.scoutedPit!)],
                group2: [
                  PitInfoRobotCapabilities(scoutedPit: widget.scoutedPit!),
                ],
              ),
            ],
          )
        else
          Column(
            spacing: 8,
            children: [
              InformationNotAvailable(
                infoDescription: "Pit scouting information",
              ),
              ElevatedButton(
                onPressed: () async {
                  TeamMember? scouter = await showDialog(
                    context: context,
                    builder: (context) => ScouterSelectDialog(),
                  );
                  if (scouter == null || !context.mounted) return;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PopScope(
                        canPop: false,
                        child: PitScouting(team: widget.team, scouter: scouter),
                      ),
                    ),
                  );
                  if (!context.mounted) return;
                  widget.onUpdate?.call(context);
                },
                child: Text("Scout Pit"),
              ),
            ],
          ),
      ],
    );
  }
}
