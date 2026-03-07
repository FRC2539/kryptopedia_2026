import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/models/match.dart';

class MatchSelect extends StatefulWidget {
  final ValueChanged<EventMatch> callback;

  const MatchSelect({super.key, required this.callback});

  @override
  State<MatchSelect> createState() => _MatchSelectState();
}

class _MatchSelectState extends State<MatchSelect> {
  int _selectedMatch = -1;

  bool _team2539MatchesOnly = true;

  DbEvents dbEvent = DbEvents();
  DbMatches dbMatch = DbMatches();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMatchList(),
      builder: (context, snapshot) {
        return Container(
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
            color: Colors.black54,
            border: Border.all(width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              snapshot.hasData
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 2.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                "Choose a Match:",
                                style: TextStyle(
                                  fontSize: Device.fontLabel(context),
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              right: 30.0,
                            ),
                            child: DropdownButton(
                              value: _selectedMatch,
                              onChanged: (newValue) async {
                                EventMatch match = await dbMatch
                                    .getQualificationMatch(newValue!);
                                setState(() {
                                  _selectedMatch = newValue;
                                  widget.callback(match);
                                });
                              },
                              items: snapshot.data!.map<DropdownMenuItem<int>>((
                                EventMatch match,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: match.number,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                    ),
                                    child: AutoSizeText(
                                      match.name,
                                      style: TextStyle(
                                        fontSize: Device.fontSize(
                                          context,
                                          10.0,
                                          20.0,
                                        ),
                                      ),
                                      maxFontSize: Device.fontSize(
                                        context,
                                        12.0,
                                        17.0,
                                      ),
                                      minFontSize: Device.fontSize(
                                        context,
                                        5.0,
                                        10.0,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Team 2539 Matches Only?",
                          style: TextStyle(fontSize: Device.fontLabel(context)),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                        right: 20.0,
                      ),
                      child: Switch(
                        value: _team2539MatchesOnly == true,
                        onChanged: (newValue) async {
                          setState(() {
                            _team2539MatchesOnly = newValue;
                            _selectedMatch = 1;
                          });
                          await getMatchList();
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeThumbColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<EventMatch>> getMatchList() async {
    List<EventMatch> matches = await dbMatch.getMatches();

    if (_team2539MatchesOnly == true) {
      matches.removeWhere(
        (match) =>
            [
              match.red1number,
              match.red2number,
              match.red3number,
              match.blue1number,
              match.blue2number,
              match.blue3number,
            ].contains(2539) ==
            false
      );
    }

    matches.sort((a, b) {
      return (a.number).compareTo(b.number);
    });

    if (_selectedMatch == -1) {
      _selectedMatch = matches.first.number;
      widget.callback(matches.first);
    }

    return matches;
  }
}
