import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/screens/team_info.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/util/predictions.dart';
import 'package:kryptopedia/widgets/common/box_header.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/icons.dart';

class MatchScheduleMatchInfo {
  final EventMatch match;
  final String red1name;
  final String red2name;
  final String red3name;
  final String blue1name;
  final String blue2name;
  final String blue3name;
  final MatchScorePrediction prediction;
  final int haveMatchScoutingDataRed;
  final int haveMatchScoutingDataBlue;

  const MatchScheduleMatchInfo({
    required this.red1name,
    required this.red2name,
    required this.red3name,
    required this.blue1name,
    required this.blue2name,
    required this.blue3name,
    required this.match,
    required this.prediction,
    required this.haveMatchScoutingDataRed,
    required this.haveMatchScoutingDataBlue,
  });
}

class MatchesScheduleInitialData {
  final List<EventMatch> matches;
  final List<ScoutedMatch> scoutedMatches;

  const MatchesScheduleInitialData({
    required this.matches,
    required this.scoutedMatches,
  });
}

class QualificationMatchSchedule extends StatefulWidget {
  const QualificationMatchSchedule({super.key});

  @override
  State<QualificationMatchSchedule> createState() =>
      _QualificationMatchScheduleState();
}

class _QualificationMatchScheduleState
    extends State<QualificationMatchSchedule> {
  DbMatches dbMatches = DbMatches();
  DbScoutedMatches dbScoutedMatches = DbScoutedMatches();

  int _oneTeamOnly = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qualification Match Schedule"),
        actions: [
          Center(
            child: Text("Team", style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Padding(padding: EdgeInsets.only(right: 8.0)),
          SizedBox(
            width: 60,
            child: TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value == "") {
                  setState(() {
                    _oneTeamOnly = 0;
                  });
                  return;
                }
                setState(() {
                  _oneTeamOnly = int.parse(value);
                });
              },
            ),
          ),
          Center(
            child: Text("Only", style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Padding(padding: EdgeInsets.only(right: 8.0)),
        ],
      ),
      body: FutureBuilder(
        future: getInitialData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              addAutomaticKeepAlives: true,
              children: [
                ...snapshot.data!.matches.map(
                  (e) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        border: Border.all(width: 1.0),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          BoxHeader(e.name, Colors.white, Colors.orange),
                          MatchBox(
                            match: e,
                            scoutedMatches: snapshot.data!.scoutedMatches,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text('Loading list of matches...');
          }
        },
      ),
    );
  }

  Future<MatchesScheduleInitialData> getInitialData() async {
    List<EventMatch> matches = await dbMatches.getMatches();
    matches = matches.where((match) => match.compLevel == "qm").toList();
    if (_oneTeamOnly != 0) {
      matches = matches.where((element) {
        return [
          element.red1number,
          element.red2number,
          element.red3number,
          element.blue1number,
          element.blue2number,
          element.blue3number,
        ].contains(_oneTeamOnly);
      }).toList();
    }
    matches.sort((a, b) {
      return (a.number).compareTo(b.number);
    });
    var scoutedMatches = await dbScoutedMatches.getScoutedMatches();

    return MatchesScheduleInitialData(
      matches: matches,
      scoutedMatches: scoutedMatches,
    );
  }
}

class MatchBox extends StatefulWidget {
  final EventMatch match;
  final List<ScoutedMatch> scoutedMatches;
  const MatchBox({
    super.key,
    required this.match,
    required this.scoutedMatches,
  });

  @override
  State<MatchBox> createState() => _MatchBoxState();
}

class _MatchBoxState extends State<MatchBox>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: getMatchInfo(widget.match, widget.scoutedMatches),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
            child: ResponsiveLayout(
              portraitMode: LayoutMode.singleColumn,
              landscapeMode: LayoutMode.singleRow,
              group1: [
                Expanded(
                  flex: landscape(context) ? 1 : 0,
                  child: AllianceBox(
                    team1id: widget.match.red1number,
                    team2id: widget.match.red2number,
                    team3id: widget.match.red3number,
                    team1name: snapshot.data!.red1name,
                    team2name: snapshot.data!.red2name,
                    team3name: snapshot.data!.red3name,
                    prediction: snapshot.data!.prediction,
                    haveMatchScoutingData:
                        snapshot.data!.haveMatchScoutingDataRed,
                    alliance: 0,
                  ),
                ),
              ],
              group2: [
                Expanded(
                  flex: landscape(context) ? 1 : 0,
                  child: AllianceBox(
                    team1id: widget.match.blue1number,
                    team2id: widget.match.blue2number,
                    team3id: widget.match.blue3number,
                    team1name: snapshot.data!.blue1name,
                    team2name: snapshot.data!.blue2name,
                    team3name: snapshot.data!.blue3name,
                    prediction: snapshot.data!.prediction,
                    haveMatchScoutingData:
                        snapshot.data!.haveMatchScoutingDataBlue,
                    alliance: 1,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Loading data...');
        }
      },
    );
  }

  Future<MatchScheduleMatchInfo> getMatchInfo(
    EventMatch match,
    List<ScoutedMatch> scoutedMatches,
  ) async {
    MatchScorePrediction matchScorePrediction =
        await MatchScorePrediction.createPrediction(
          match.red1number,
          match.red2number,
          match.red3number,
          match.blue1number,
          match.blue2number,
          match.blue3number,
        );

    DbTeams dbTeam = DbTeams();

    List<String> teamNames = await Future.wait([
      dbTeam.getTeam(match.red1number).then((team) => team.nickname),
      dbTeam.getTeam(match.red2number).then((team) => team.nickname),
      dbTeam.getTeam(match.red3number).then((team) => team.nickname),
      dbTeam.getTeam(match.blue1number).then((team) => team.nickname),
      dbTeam.getTeam(match.blue2number).then((team) => team.nickname),
      dbTeam.getTeam(match.blue3number).then((team) => team.nickname),
    ]);

    int haveMatchScoutingDataRed = 0;
    int haveMatchScoutingDataBlue = 0;

    if (scoutedMatches
        .where(
          (element) =>
              (element.matchNumber == match.number &&
              element.teamNumber == match.red1number),
        )
        .isNotEmpty) {
      haveMatchScoutingDataRed++;
    }
    if (scoutedMatches
        .where(
          (element) =>
              (element.matchNumber == match.number &&
              element.teamNumber == match.red2number),
        )
        .isNotEmpty) {
      haveMatchScoutingDataRed++;
    }
    if (scoutedMatches
        .where(
          (element) =>
              (element.matchNumber == match.number &&
              element.teamNumber == match.red3number),
        )
        .isNotEmpty) {
      haveMatchScoutingDataRed++;
    }
    if (scoutedMatches
        .where(
          (element) =>
              (element.matchNumber == match.number &&
              element.teamNumber == match.blue1number),
        )
        .isNotEmpty) {
      haveMatchScoutingDataBlue++;
    }
    if (scoutedMatches
        .where(
          (element) =>
              (element.matchNumber == match.number &&
              element.teamNumber == match.blue2number),
        )
        .isNotEmpty) {
      haveMatchScoutingDataBlue++;
    }
    if (scoutedMatches
        .where(
          (element) =>
              (element.matchNumber == match.number &&
              element.teamNumber == match.blue3number),
        )
        .isNotEmpty) {
      haveMatchScoutingDataBlue++;
    }

    return MatchScheduleMatchInfo(
      match: match,
      prediction: matchScorePrediction,
      red1name: teamNames[0],
      red2name: teamNames[1],
      red3name: teamNames[2],
      blue1name: teamNames[3],
      blue2name: teamNames[4],
      blue3name: teamNames[5],
      haveMatchScoutingDataRed: haveMatchScoutingDataRed,
      haveMatchScoutingDataBlue: haveMatchScoutingDataBlue,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AllianceBox extends StatelessWidget {
  final int team1id;
  final int team2id;
  final int team3id;
  final String team1name;
  final String team2name;
  final String team3name;
  final MatchScorePrediction prediction;
  final int haveMatchScoutingData;
  final int alliance;
  const AllianceBox({
    super.key,
    required this.team1id,
    required this.team2id,
    required this.team3id,
    required this.team1name,
    required this.team2name,
    required this.team3name,
    required this.prediction,
    required this.haveMatchScoutingData,
    required this.alliance,
  });

  @override
  Widget build(BuildContext context) {
    String allianceName = alliance == 0 ? "Red" : "Blue";
    Color allianceColor = alliance == 0 ? Colors.red : Colors.blue;

    AllianceScorePrediction alliancePrediction = alliance == 0
        ? prediction.red
        : prediction.blue;
    AllianceScorePrediction otherAlliancePrediction = alliance == 0
        ? prediction.blue
        : prediction.red;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: allianceColor),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$allianceName Alliance',
                    style: TextStyle(
                      color: allianceColor,
                      fontSize: Device.fontHeader(context),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamInfo(passedTeamID: team1id),
                        ),
                      );
                    },
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "$team1id - $team1name",
                      style: TextStyle(fontSize: Device.fontListTitle(context)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamInfo(passedTeamID: team2id),
                        ),
                      );
                    },
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "$team2id - $team2name",
                      style: TextStyle(fontSize: Device.fontListTitle(context)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamInfo(passedTeamID: team3id),
                        ),
                      );
                    },
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "$team3id - $team3name ",
                      style: TextStyle(fontSize: Device.fontListTitle(context)),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    (alliancePrediction.totalPoints >
                            otherAlliancePrediction.totalPoints)
                        ? Row(
                            children: [
                              Icon(Icons.star, color: allianceColor),
                              const Padding(padding: EdgeInsets.only(right: 5)),
                            ],
                          )
                        : Container(),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: allianceColor,
                          fontSize: Device.fontListTitle(context),
                        ),
                        children: [
                          TextSpan(text: "Predicted score: "),
                          TextSpan(
                            text: "${alliancePrediction.totalPoints}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " points"),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  children: [
                    Text(
                      "Predicted RP: ",
                      style: TextStyle(
                        color: allianceColor,
                        fontSize: Device.fontListTitle(context),
                      ),
                    ),
                    alliancePrediction.climbRankingPoint
                        ? TraversalRankingPointIcon(
                            color: alliance == 0 ? Colors.red : Colors.blue,
                          )
                        : Container(),
                    alliancePrediction.fuelRankingPoints >= 1
                        ? EnergizedRankingPointIcon(
                            color: alliance == 0 ? Colors.red : Colors.blue,
                          )
                        : Container(),
                    alliancePrediction.fuelRankingPoints >= 2
                        ? SuperchargedRankingPointIcon(
                            color: alliance == 0 ? Colors.red : Colors.blue,
                          )
                        : Container(),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  children: [
                    (haveMatchScoutingData < 3)
                        ? Row(
                            children: [
                              Icon(Icons.warning, color: allianceColor),
                              const Padding(padding: EdgeInsets.only(right: 5)),
                            ],
                          )
                        : Container(),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: allianceColor,
                          fontSize: Device.fontListTitle(context),
                        ),
                        children: [
                          TextSpan(text: "Scouted "),
                          TextSpan(
                            text: "$haveMatchScoutingData",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "/3 teams"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
