/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:kryptopedia/util/dbhelpers/dbevents.dart';
import 'package:kryptopedia/util/dbhelpers/dbmatch.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/util/predictions.dart';

class MatchPredictionsDebug extends StatefulWidget {
  const MatchPredictionsDebug({super.key});

  @override
  State<MatchPredictionsDebug> createState() => _MatchPredictionsDebugState();
}

class _MatchPredictionsDebugState extends State<MatchPredictionsDebug> {
  int matchesTested = 0;
  int totalMatches = 0;
  int correct = 0;
  int incorrect = 0;

  DbEvent dbEvent = DbEvent();
  DbMatch dbMatch = DbMatch();

  void getInfo() async {
    Event event = (await dbEvent.getActiveEvents()).first;
    List<Match> matches = await dbMatch.getMatchesAtEvent(event.id);
    totalMatches = matches.length;
    matchesTested = 0;

    for (int i = 0; i < matches.length; i += 10) {
      var futures = matches.skip(i).take(10).map((match) async {
        print(match.name.split(' ')[2]);

        MatchScorePrediction prediction =
            await MatchScorePrediction.createPrediction(
                match.red1teamid,
                match.red2teamid,
                match.red3teamid,
                match.blue1teamid,
                match.blue2teamid,
                match.blue3teamid);

        var actualResultRequest = await http.get(
            Uri.parse(
                "https://www.thebluealliance.com/api/v3/match/${event.code}_qm${match.name.split(' ')[2]}"),
            headers: {
              "X-TBA-Auth-Key":
                  "WPzUFYmmSy8xyxxysdXT258MnSE7y1piZBZQYv21rrWMDawjFFBaKhMcXLxpgLih"
            });
        var actualResult = await json.decode(actualResultRequest.body);

        print(actualResult);

        setState(() {
          matchesTested++;
          if (actualResult["alliances"]["red"]["score"] == -1) {
            return;
          }

          if (prediction.red.totalPoints > prediction.blue.totalPoints) {
            if (actualResult["alliances"]["red"]["score"] >
                actualResult["alliances"]["blue"]["score"]) {
              correct++;
            } else {
              incorrect++;
            }
          } else if (prediction.red.totalPoints < prediction.blue.totalPoints) {
            if (actualResult["alliances"]["red"]["score"] <
                actualResult["alliances"]["blue"]["score"]) {
              correct++;
            } else {
              incorrect++;
            }
          }
        });
      }).toList();

      await Future.wait(futures);
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(
      children: [
        Text("Tested prediction $matchesTested/$totalMatches"),
        Text("Correct: $correct"),
        Text("Incorrect: $incorrect"),
        Text("Accuracy: ${correct / (correct + incorrect)}"),
      ],
    ));
  }
}
*/