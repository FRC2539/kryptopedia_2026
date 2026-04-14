import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/main.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/screens/match_scouting.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/util/vibrate.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/text_field.dart';
import 'package:kryptopedia/widgets/match_scouting/positions_select.dart';
import 'dart:math';

List<Color> rainbowFromBlue = [];

class MatchScoutingBoxesEdition extends StatefulWidget {
  final AlliancePosition alliancePosition;
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
  late TeamMember _selectedScouter;
  late Future<List<TeamMember>> scouters;
  DbEvents dbEvents = DbEvents();

  bool setStartPosition = false;
  bool setAutoClimb = false;
  bool setEndgameClimb = false;

  Future<List<TeamMember>> _future() async {
    DbTeamMembers dbTeamMembers = DbTeamMembers();
    List<TeamMember> teamMembers = await dbTeamMembers.getTeamMembers();

    return teamMembers;
  }

  @override
  void initState() {
    super.initState();
    scoutedMatchSingleton.setToDefaults(
      widget.match,
      widget.team.number,
      widget.scouter,
    );
    scouters = _future();
    _selectedScouter = widget.scouter;
  }

  MatchState state = MatchState.start;

  void _toggleRobotRole(RobotRole role) {
    final updatedRoles = List<RobotRole>.from(scoutedMatchSingleton.robotRoles);
    if (updatedRoles.contains(role)) {
      updatedRoles.remove(role);
    } else {
      updatedRoles.add(role);
    }
    scoutedMatchSingleton.robotRoles = updatedRoles;
  }

  @override
  Widget build(BuildContext context) {
    Color allianceColor = redAlliancePositions.contains(widget.alliancePosition)
        ? Colors.red
        : Colors.blue;
    List<Color> colors = [];
    colors.add(allianceColor);
    switch (state) {
      case MatchState.start:
        colors.add(switch (allianceColor) {
          Colors.blue => Colors.orangeAccent,
          _ => Colors.lightGreenAccent,
        });
        break;
      case MatchState.auto:
        colors.add(Colors.purple);
        break;
      case MatchState.teleop:
        colors.add(Colors.black);
        break;
      case MatchState.summary:
        if (!rainbowMode) {
          colors.add(index2 != null ? Colors.accents[index2!] : Colors.green);
          colors.add(allianceColor);
        } else {
          colors.add(allianceColor);
          if (allianceColor == Colors.red) {
            colors.addAll(Colors.accents.reversed.toList());
          } else {
            for (int i = 0; i < Colors.accents.length; i++) {
              if (Colors.accents[i] == Colors.blueAccent) {
                rainbowFromBlue = [
                  ...Colors.accents.sublist(i),
                  ...Colors.accents.sublist(0, i),
                ];
                break;
              }
            }
            colors.addAll(rainbowFromBlue.reversed.toList());
          }
          colors.add(allianceColor);
        }
        break;
      case MatchState.end:
        if (!rainbowMode) {
          colors.add(index2 != null ? Colors.accents[index2!] : Colors.green);
          colors.add(allianceColor);
        } else {
          colors.add(allianceColor);
          if (allianceColor == Colors.red) {
            colors.addAll(Colors.accents.reversed.toList());
          } else {
            for (int i = 0; i < Colors.accents.length; i++) {
              if (Colors.accents[i] == Colors.blueAccent) {
                rainbowFromBlue = [
                  ...Colors.accents.sublist(i),
                  ...Colors.accents.sublist(0, i),
                ];
                break;
              }
            }
            colors.addAll(rainbowFromBlue.reversed.toList());
          }
          colors.add(allianceColor);
        }
        break;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        switch (state) {
          case MatchState.start:
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
            rainbowMode = false;
            index2 = null;
            Navigator.pop(context);
          case MatchState.auto:
            setState(() {
              state = MatchState.start;
            });
            break;
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
                  Container(),
                  FutureBuilder(
                    future: scouters,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("an error! ${snapshot.error}");
                      }
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return DropdownButton<String>(
                        value: _selectedScouter.id,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedScouter = snapshot.data!.firstWhere(
                              (scouter) => scouter.id == newValue,
                            );
                            scoutedMatchSingleton.scouterId = newValue!;
                            dbEvents.updateLastScouter(newValue);
                          });
                        },
                        items: snapshot.data!
                            .map(
                              (scouter) => DropdownMenuItem<String>(
                                value: scouter.id,
                                child: AutoSizeText(
                                  scouter.name,
                                  style: TextStyle(
                                    fontSize: Device.fontSize(
                                      context,
                                      12.0,
                                      22.0,
                                    ),
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.format_color_reset),
                        color:
                            (state == MatchState.summary ||
                                state == MatchState.end)
                            ? (index2 == null
                                  ? allianceColor
                                  : (rainbowMode
                                        ? allianceColor
                                        : Colors.accents[index2!]))
                            : Colors.transparent,
                        onPressed: () {
                          setState(() {
                            rainbowMode = false;
                            index2 = null;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.colorize),
                        color:
                            (state == MatchState.summary ||
                                state == MatchState.end)
                            ? (index2 == null
                                  ? allianceColor
                                  : (rainbowMode
                                        ? allianceColor
                                        : Colors.accents[index2!]))
                            : Colors.transparent,
                        onPressed: () {
                          setState(() {
                            rainbowMode = false;
                            int? nindex = index2;
                            while (index2 == nindex) {
                              nindex = Random().nextInt(Colors.accents.length);
                            }
                            index2 = nindex;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            rainbowMode = !rainbowMode;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MatchScouting(
                                team: widget.team,
                                match: widget.match,
                                scouter: _selectedScouter,
                                alliancePosition: widget.alliancePosition,
                                preserve: true,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      Visibility(
                        visible: state == MatchState.teleop,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              state = MatchState.end;
                            });
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: index != null
            ? Colors.accents[index!]
            : Colors.transparent,
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
                    "${widget.team.number} ${widget.team.nickname} | ${widget.match.name} | ${state == MatchState.start
                        ? "Start"
                        : state == MatchState.auto
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
                  int rows = switch (state) {
                    MatchState.start => 6,
                    MatchState.auto => 5,
                    MatchState.teleop => 3,
                    _ => 4,
                  };
                  (state == MatchState.teleop) ? 3 : 4;
                  int columns = (state == MatchState.teleop) ? 2 : 1;

                  double itemHeight = constraints.maxHeight / rows;

                  double itemWidth = constraints.maxWidth / columns;

                  double aspectRatio = itemHeight / itemWidth;

                  Alliance alliance =
                      redAlliancePositions.contains(widget.alliancePosition)
                      ? Alliance.red
                      : Alliance.blue;
                  String station1Label = alliance == Alliance.red
                      ? widget.match.red1number.toString()
                      : widget.match.blue1number.toString();
                  String station2Label = alliance == Alliance.red
                      ? widget.match.red2number.toString()
                      : widget.match.blue2number.toString();
                  String station3Label = alliance == Alliance.red
                      ? widget.match.red3number.toString()
                      : widget.match.blue3number.toString();

                  List<Widget> buttons = switch (state) {
                    MatchState.start => [],
                    MatchState.auto => [
                      _buildGridButton(
                        color: Colors.yellow,
                        label: "Fuel Scored +3",
                        onPressed: () {
                          scoutedMatchSingleton.autoFuelScored += 3;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.yellow,
                        label:
                            "Fuel Scored\n${scoutedMatchSingleton.autoFuelScored}",
                        onPressed: () {
                          scoutedMatchSingleton.autoFuelScored++;
                          vibrate(HapticsType.medium);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.purple,
                        label: "Subtract fuel scored",
                        onPressed: () {
                          if (scoutedMatchSingleton.autoFuelScored <= 0) return;
                          scoutedMatchSingleton.autoFuelScored--;
                          vibrate(HapticsType.warning);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.teal,
                        label: "Next\nCLIMBED",
                        filled: scoutedMatchSingleton.autoClimbed == true,
                        onPressed: () {
                          scoutedMatchSingleton.autoClimbed = true;
                          state = MatchState.teleop;
                          vibrate(HapticsType.success);
                        },
                      ),
                      _buildGridButton(
                        color: cougarOrange,
                        label: "Next\nNOT CLIMBED",
                        filled:
                            scoutedMatchSingleton.autoClimbed == false &&
                            setAutoClimb,
                        onPressed: () {
                          scoutedMatchSingleton.autoClimbed = false;
                          state = MatchState.teleop;
                          vibrate(HapticsType.error);
                          setAutoClimb = true;
                        },
                      ),
                    ],
                    MatchState.teleop => [
                      _buildGridButton(
                        color: Colors.yellow,
                        label: "Fuel Scored +3",
                        onPressed: () {
                          scoutedMatchSingleton.teleopFuelScored += 3;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.yellow,
                        label:
                            "Fuel Scored\n${scoutedMatchSingleton.teleopFuelScored}",
                        onPressed: () {
                          scoutedMatchSingleton.teleopFuelScored++;
                          vibrate(HapticsType.medium);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.purple,
                        label: "Subtract fuel scored",
                        onPressed: () {
                          if (scoutedMatchSingleton.teleopFuelScored <= 0) {
                            return;
                          }
                          scoutedMatchSingleton.teleopFuelScored--;
                          vibrate(HapticsType.warning);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.green,
                        label: "Fuel Fed +3",
                        onPressed: () {
                          scoutedMatchSingleton.teleopFuelFed += 3;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.green,
                        label:
                            "Fuel fed\n${scoutedMatchSingleton.teleopFuelFed}",
                        onPressed: () {
                          scoutedMatchSingleton.teleopFuelFed++;
                          vibrate(HapticsType.medium);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.purple,
                        label: "Subtract fuel fed",
                        onPressed: () {
                          if (scoutedMatchSingleton.teleopFuelFed <= 0) return;
                          scoutedMatchSingleton.teleopFuelFed--;
                          vibrate(HapticsType.warning);
                        },
                      ),
                    ],
                    MatchState.end => [
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Level 3 Climb",
                        description: "bumpers completely above second rung",
                        filled:
                            scoutedMatchSingleton.climbLevel == ClimbLevel.L3,
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.L3;
                          state = MatchState.summary;
                          vibrate(HapticsType.heavy);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Level 2 Climb",
                        description: "bumpers completely above first rung",
                        filled:
                            scoutedMatchSingleton.climbLevel == ClimbLevel.L2,
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.L2;
                          state = MatchState.summary;
                          vibrate(HapticsType.medium);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Level 1 Climb",
                        description: "completely off the ground",
                        filled:
                            scoutedMatchSingleton.climbLevel == ClimbLevel.L1,
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.L1;
                          state = MatchState.summary;
                          vibrate(HapticsType.light);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "None",
                        filled:
                            scoutedMatchSingleton.climbLevel ==
                                ClimbLevel.none &&
                            setEndgameClimb,
                        onPressed: () {
                          scoutedMatchSingleton.climbLevel = ClimbLevel.none;
                          state = MatchState.summary;
                          vibrate(HapticsType.error);
                          setEndgameClimb = true;
                        },
                      ),
                    ],
                    MatchState.summary => [
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Offense",
                        filled: scoutedMatchSingleton.robotRoles.contains(
                          RobotRole.offense,
                        ),
                        onPressed: () {
                          setState(() {
                            _toggleRobotRole(RobotRole.offense);
                          });
                          vibrate(HapticsType.medium);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Defense",
                        filled: scoutedMatchSingleton.robotRoles.contains(
                          RobotRole.defense,
                        ),
                        onPressed: () {
                          setState(() {
                            _toggleRobotRole(RobotRole.defense);
                          });
                          vibrate(HapticsType.rigid);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "Feeder",
                        filled: scoutedMatchSingleton.robotRoles.contains(
                          RobotRole.feeder,
                        ),
                        onPressed: () {
                          setState(() {
                            _toggleRobotRole(RobotRole.feeder);
                          });
                          vibrate(HapticsType.rigid);
                        },
                      ),
                      _buildGridButton(
                        color: Colors.blueAccent,
                        label: "next",
                        onPressed: () {
                          comments();
                          vibrate(HapticsType.success);
                        },
                      ),
                    ],
                  };

                  if (state == MatchState.start) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: StartPositionsSelect(
                            alliance: alliance,
                            station1Label: station1Label,
                            station2Label: station2Label,
                            station3Label: station3Label,
                            value: setStartPosition
                                ? ValueNotifier(
                                    scoutedMatchSingleton.startPosition,
                                  )
                                : null,
                            onPositionSelected: (pos) {
                              scoutedMatchSingleton.startPosition = pos;
                              setStartPosition = true;
                              vibrate(HapticsType.medium);
                              setState(() {
                                state = MatchState.auto;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox.expand(
                              child: _buildGridButton(
                                color: Colors.redAccent,
                                label: "No-show",
                                filled:
                                    scoutedMatchSingleton.startPosition ==
                                    StartPosition.none,
                                onPressed: () {
                                  scoutedMatchSingleton.startPosition =
                                      StartPosition.none;
                                  scoutedMatchSingleton.issues = 2;
                                  vibrate(HapticsType.error);
                                  comments();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

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
    bool filled = false,
    String? label,
    String? description,
    void Function()? onPressed,
    void Function()? onLongPress,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
          foregroundColor: index == null ? color : Colors.black,
          backgroundColor: color.withAlpha(filled ? 100 : 0),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (description != null)
                Text(
                  description,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
          ],
        ),
      ),
    );
  }

  Future<void> comments() async {
    bool? done = await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Device.dialogHeight(context, 3 / 4, 500),
              maxWidth: Device.dialogWidth(context, 3 / 4, 800),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInputField(
                  label: "comments!",
                  hint:
                      "general comments: describe anything eventful, mostly.\nparticularly, please be sure to describe any penalties, issues, or defense.",
                  isMultiline: true,
                  minLines: 2,
                  maxLines: 6,
                  initialValue: scoutedMatchSingleton.generalComments,
                  callback: (comments) =>
                      scoutedMatchSingleton.generalComments = comments,
                ),
                DropdownList(
                  label: 'Penalties?',
                  initialValue: Penalties.none,
                  options: [
                    MultiSelectOption(value: Penalties.none, label: 'None'),
                    MultiSelectOption(value: Penalties.few, label: 'Few'),
                    MultiSelectOption(value: Penalties.many, label: 'Many'),
                  ],
                  callback: (newValue) {
                    scoutedMatchSingleton.penalties = newValue;
                  },
                ),
                DropdownList(
                  label: "Issues?",
                  initialValue: 0,
                  options: [
                    MultiSelectOption(value: 0, label: "None"),
                    MultiSelectOption(value: 1, label: "Minor"),
                    MultiSelectOption(value: 2, label: "Major"),
                  ],
                  callback: (value) {
                    scoutedMatchSingleton.issues = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onLongPress: () => {
                      Navigator.pop(context, true),
                      index2 = null,
                      rainbowMode = false,
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

enum MatchState { start, auto, teleop, end, summary }
