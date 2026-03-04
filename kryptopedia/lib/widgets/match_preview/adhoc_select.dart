import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class AdhocSelect extends StatefulWidget {
  final AdhocSelection selection;
  final ValueChanged<AdhocSelection> callback;

  const AdhocSelect({
    super.key,
    required this.selection,
    required this.callback,
  });

  @override
  State<AdhocSelect> createState() => _AdhocSelectState();
}

class _AdhocSelectState extends State<AdhocSelect> {
  DbEvents dbEvent = DbEvents();
  DbTeams dbTeam = DbTeams();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTeamList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.0,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 5.0,
                    right: 10.0,
                    left: 10.0,
                  ),
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: AutoSizeText(
                              "Blue Team #1:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device.fontLabel(context),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: widget.selection.blue1,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selection.blue1 = newValue!;
                                    widget.callback(widget.selection);
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<int>>((Team team) {
                                      return DropdownMenuItem<int>(
                                        value: team.number,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: AutoSizeText(
                                            "${team.number} - ${team.nickname}",
                                            style: TextStyle(
                                              fontSize: Device.fontLabel(
                                                context,
                                              ),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: AutoSizeText(
                              "Blue Team #2:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device.fontLabel(context),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: widget.selection.blue2,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selection.blue2 = newValue!;
                                    widget.callback(widget.selection);
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<int>>((Team team) {
                                      return DropdownMenuItem<int>(
                                        value: team.number,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: AutoSizeText(
                                            "${team.number} - ${team.nickname}",
                                            style: TextStyle(
                                              fontSize: Device.fontLabel(
                                                context,
                                              ),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: AutoSizeText(
                              "Blue Team #3:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device.fontLabel(context),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: widget.selection.blue3,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selection.blue3 = newValue!;
                                    widget.callback(widget.selection);
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<int>>((Team team) {
                                      return DropdownMenuItem<int>(
                                        value: team.number,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: AutoSizeText(
                                            "${team.number} - ${team.nickname}",
                                            style: TextStyle(
                                              fontSize: Device.fontLabel(
                                                context,
                                              ),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 5.0,
                    right: 10.0,
                    left: 10.0,
                  ),
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: AutoSizeText(
                              "Red Team #1:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device.fontLabel(context),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: widget.selection.red1,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selection.red1 = newValue!;
                                    widget.callback(widget.selection);
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<int>>((Team team) {
                                      return DropdownMenuItem<int>(
                                        value: team.number,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: AutoSizeText(
                                            "${team.number} - ${team.nickname}",
                                            style: TextStyle(
                                              fontSize: Device.fontLabel(
                                                context,
                                              ),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: AutoSizeText(
                              "Red Team #2:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device.fontLabel(context),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: widget.selection.red2,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selection.red2 = newValue!;
                                    widget.callback(widget.selection);
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<int>>((Team team) {
                                      return DropdownMenuItem<int>(
                                        value: team.number,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: AutoSizeText(
                                            "${team.number} - ${team.nickname}",
                                            style: TextStyle(
                                              fontSize: Device.fontLabel(
                                                context,
                                              ),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: AutoSizeText(
                              "Red Team #3:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device.fontLabel(context),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: widget.selection.red3,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selection.red3 = newValue!;
                                    widget.callback(widget.selection);
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<int>>((Team team) {
                                      return DropdownMenuItem<int>(
                                        value: team.number,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                          ),
                                          child: AutoSizeText(
                                            "${team.number} - ${team.nickname}",
                                            style: TextStyle(
                                              fontSize: Device.fontLabel(
                                                context,
                                              ),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<Team>> getTeamList() async {
    List<Team> teams = await dbTeam.getTeams();

    teams.sort((a, b) {
      return (a.number).compareTo(b.number);
    });

    return teams;
  }
}

class AdhocSelection {
  int red1;
  int red2;
  int red3;
  int blue1;
  int blue2;
  int blue3;

  AdhocSelection({
    required this.red1,
    required this.red2,
    required this.red3,
    required this.blue1,
    required this.blue2,
    required this.blue3,
  });
}
