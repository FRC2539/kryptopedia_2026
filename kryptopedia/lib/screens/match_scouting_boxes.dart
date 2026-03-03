import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/main.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/screens/match_scouting.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/util/vibrate.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/text_field.dart';

class MatchScoutingBoxesEdition extends StatefulWidget {
  final String alliancePosition;
  final Team team;
  final EventMatch match;
  final TeamMember scouter;

  const MatchScoutingBoxesEdition({
    super.key,
    required this.alliancePosition,
    required this.team,
    required this.match,
    required this.scouter,
  });

  @override
  State<MatchScoutingBoxesEdition> createState() =>
      _MatchScoutingBoxesEditionState();
}

class _MatchScoutingBoxesEditionState extends State<MatchScoutingBoxesEdition> {
  @override
  void initState() {
    super.initState();
    scoutedMatchSingleton.setToDefaults(
      widget.match,
      widget.team.number,
      widget.scouter,
    );
  }

  MatchState state = MatchState.auto;

  @override
  Widget build(BuildContext context) {
    Color allianceColor =
        widget.alliancePosition.toLowerCase().startsWith('red')
        ? Colors.red
        : Colors.blue;
    List<Color> colors = [];
    colors.add(allianceColor);
    switch (state) {
      case MatchState.auto:
        colors.add(Colors.purple);
        break;
      case MatchState.teleop:
        colors.add(Colors.black);
        break;
      default:
        colors.add(allianceColor);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        switch (state) {
          case MatchState.auto:
            bool? confirmation = await showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: "sure?",
                body: "you'll lose everything 😟",
                confirmText: "😟",
              ),
            );
            if (confirmation != true || !context.mounted) {
              return;
            }
            Navigator.pop(context);
          case MatchState.teleop:
            setState(() {
              state = MatchState.auto;
            });
            break;
          case MatchState.end:
            setState(() {
              state = MatchState.teleop;
            });
            break;
          case MatchState.summary:
            setState(() {
              state = MatchState.end;
            });
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kryptopedia - Match Scouting"),
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(), //it works :)
                  AutoSizeText(
                    "Scouter: ${widget.scouter.name}",
                    style: TextStyle(
                      fontSize: Device.fontHeader(context) * 0.7,
                    ),
                    maxLines: 1,
                  ),
                  IconButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchScouting(
                            team: widget.team,
                            match: widget.match,
                            scouter: widget.scouter,
                            alliancePosition: widget.alliancePosition,
                            preserve: true,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.team.number} ${widget.team.nickname} | ${widget.match.name} | ${state == MatchState.auto
                        ? "Auto"
                        : state == MatchState.teleop
                        ? "Teleop"
                        : state == MatchState.end
                        ? "Endgame"
                        : "Summary"}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int rows =
                      (state == MatchState.teleop ||
                          state == MatchState.summary)
                      ? 3
                      : 4;
                  int columns = (state == MatchState.teleop) ? 2 : 1;

                  double itemHeight = constraints.maxHeight / rows;

                  double itemWidth = constraints.maxWidth / columns;

                  double aspectRatio = itemHeight / itemWidth;

                  List<Widget> buttons = switch (state) {
                    MatchState.auto => [
                      _buildGridButton(
                        color: Colors.yellow,
                        label:
                            "Fuel Scored\n${scoutedMatchSingleton.autoFuelScored}",
                        onPressed: () {
                          scoutedMatchSingleton.autoFuelScored++;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.purple,
                        label: "Subtract fuel scored",
                        onPressed: () {
                          if (scoutedMatchSingleton.autoFuelScored <= 1) return;
                          scoutedMatchSingleton.autoFuelScored--;
                          vibrate(HapticsType.warning);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.teal,
                        label: "Next\nCLIMBED",
                        onPressed: () {
                          scoutedMatchSingleton.autoClimbed = true;
                          state = MatchState.teleop;
                          vibrate(HapticsType.success);
                        },
                      ),
                      _buildGridButton(
                        color: cougarOrange,
                        label: "Next\nNOT CLIMBED",
                        onPressed: () {
                          scoutedMatchSingleton.autoClimbed = false;
                          state = MatchState.teleop;
                          vibrate(HapticsType.error);
                        },
                      ),
                    ],
                    MatchState.teleop => [
                      _buildGridButton(
                        color: Colors.yellow,
                        label:
                            "Fuel Scored\n${scoutedMatchSingleton.teleopFuelScored}",
                        onPressed: () {
                          scoutedMatchSingleton.teleopFuelScored++;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.green,
                        label:
                            "Fuel fed\n${scoutedMatchSingleton.teleopFuelFed}",
                        onPressed: () {
                          scoutedMatchSingleton.teleopFuelFed++;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(color: Colors.black),
                      _buildGridButton(
                        color: Colors.purple,
                        label: "Subtract fuel scored",
                        onPressed: () {
                          if (scoutedMatchSingleton.teleopFuelScored <= 1) {
                            return;
                          }
                          scoutedMatchSingleton.teleopFuelScored--;
                          vibrate(HapticsType.warning);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.purple,
                        label: "Subtract fuel fed",
                        onPressed: () {
                          if (scoutedMatchSingleton.teleopFuelFed <= 1) return;
                          scoutedMatchSingleton.teleopFuelFed--;
                          vibrate(HapticsType.warning);
                        },
                      ),
                      _buildGridButton(
                        color: cougarOrange,
                        label: "next",
                        onPressed: () {
                          state = MatchState.end;
                          vibrate(HapticsType.success);
                        },
                      ),
                    ],
                    MatchState.end => [
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Level 3 Climb",
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.L3;
                          state = MatchState.summary;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Level 2 Climb",
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.L2;
                          state = MatchState.summary;
                          vibrate(HapticsType.medium);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Level 1 Climb",
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.L1;
                          state = MatchState.summary;
                          vibrate(HapticsType.light);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "None",
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.none;
                          state = MatchState.summary;
                          vibrate(HapticsType.error);
                        },
                      ),
                    ],
                    MatchState.summary => [
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Offense",
                        onPressed: () {
                          scoutedMatchSingleton.robotRoles = [
                            RobotRole.offense,
                          ];
                          vibrate(HapticsType.medium);
                          comments();
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Defense",
                        onPressed: () {
                          scoutedMatchSingleton.robotRoles = [
                            RobotRole.defense,
                          ];
                          vibrate(HapticsType.rigid);
                          comments();
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Offense AND Defense",
                        onPressed: () {
                          scoutedMatchSingleton.robotRoles = [
                            RobotRole.offense,
                            RobotRole.defense,
                          ];
                          vibrate(HapticsType.rigid);
                          comments();
                        },
                      ),
                    ],
                  };

                  return GridView.count(
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: rows,
                    childAspectRatio: aspectRatio,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4.0),
                    children: buttons,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton({
    required Color color,
    String? label,
    void Function()? onPressed,
    void Function()? onLongPress,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 10) {
            // Swipe Right
          }
        },
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: onPressed != null
              ? () {
                  setState(() {
                    onPressed();
                  });
                }
              : null,
          onLongPress: onLongPress != null
              ? () {
                  setState(() {
                    onLongPress();
                  });
                }
              : null,
          child: Text(
            label ?? "",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> comments() async {
    bool? done = await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInputField(
                label: "comments!",
                hint:
                    "general comments: describe anything eventful, mostly.\nparticularly, please be sure to describe any penalties, issues, or defense.",
                isMultiline: true,
                initialValue: scoutedMatchSingleton.generalComments,
                callback: (comments) =>
                    scoutedMatchSingleton.generalComments = comments,
              ),
              DropdownList(
                label: 'Penalties?',
                initialValue: Penalties.none,
                options: [
                  MultiSelectOption(value: Penalties.none, label: 'None'),
                  MultiSelectOption(value: Penalties.one, label: 'One'),
                  MultiSelectOption(value: Penalties.few, label: 'Few'),
                  MultiSelectOption(value: Penalties.many, label: 'Many'),
                ],
                callback: (newValue) {
                  scoutedMatchSingleton.penalties = newValue;
                },
              ),
              CheckboxListTile(
                title: const Text("Issues?"),
                value: scoutedMatchSingleton.issues,
                onChanged: (value) {
                  setDialogState(() {
                    scoutedMatchSingleton.issues = value!;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onLongPress: () => {
                    Navigator.pop(context, true),
                    vibrate(HapticsType.success),
                  },
                  onPressed: () {},
                  child: Text('save (hold) (no more changes!)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (done == null) {
      return;
    }
    DbScoutedMatches dbScoutedMatches = DbScoutedMatches();
    dbScoutedMatches.upsertScoutedMatch(scoutedMatchSingleton);
    if (!mounted) return;
    Navigator.pop(context);
  }
}

enum MatchState { auto, teleop, end, summary }
