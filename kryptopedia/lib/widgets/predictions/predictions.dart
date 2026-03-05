import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/teaminfosummary.dart';
import 'package:kryptopedia/widgets/predictions/1_overview.dart';
import 'package:kryptopedia/widgets/predictions/2_alliance_overview.dart';
import 'package:kryptopedia/util/2026helpers/calculate_all_team_metrics.dart';
import 'package:kryptopedia/util/2026helpers/calculate_teaminfo_averages.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/predictions.dart';

class MatchPredictionViewer extends StatelessWidget {
  final int red1;
  final int red2;
  final int red3;
  final int blue1;
  final int blue2;
  final int blue3;
  final bool adhoc;

  MatchPredictionViewer(
      {super.key,
      required this.red1,
      required this.red2,
      required this.red3,
      required this.blue1,
      required this.blue2,
      required this.blue3,
      required this.adhoc});

  TeamInfoSummary red1Summary = TeamInfoSummary();
  TeamInfoSummary red2Summary = TeamInfoSummary();
  TeamInfoSummary red3Summary = TeamInfoSummary();
  TeamInfoSummary blue1Summary = TeamInfoSummary();
  TeamInfoSummary blue2Summary = TeamInfoSummary();
  TeamInfoSummary blue3Summary = TeamInfoSummary();

  Future<MatchScorePrediction> _getPrediction() async {
    DbEvents dbEvent = DbEvents();
    int eventId = (await dbEvent.getEvent()).id;

    DbScoutedMatches dbScoutedMatch = DbScoutedMatches();

    List<ScoutedMatch> blue1ScoutedMatches = await dbScoutedMatch.getScoutedMatchesForTeam(blue1);
    blue1Summary = CalculateTeamInfoAverages.calculateAverages(blue1ScoutedMatches);
    List<ScoutedMatch> blue2ScoutedMatches = await dbScoutedMatch.getScoutedMatchesForTeam(blue2);
    blue2Summary = CalculateTeamInfoAverages.calculateAverages(blue2ScoutedMatches);
    List<ScoutedMatch> blue3ScoutedMatches = await dbScoutedMatch.getScoutedMatchesForTeam(blue3);
    blue3Summary = CalculateTeamInfoAverages.calculateAverages(blue3ScoutedMatches);

    List<ScoutedMatch> red1ScoutedMatches = await dbScoutedMatch.getScoutedMatchesForTeam(red1);
    red1Summary = CalculateTeamInfoAverages.calculateAverages(red1ScoutedMatches);
    List<ScoutedMatch> red2ScoutedMatches = await dbScoutedMatch.getScoutedMatchesForTeam(red2);
    red2Summary = CalculateTeamInfoAverages.calculateAverages(red2ScoutedMatches);
    List<ScoutedMatch> red3ScoutedMatches = await dbScoutedMatch.getScoutedMatchesForTeam(red3);
    red3Summary = CalculateTeamInfoAverages.calculateAverages(red3ScoutedMatches);

    return await MatchScorePrediction.createPrediction(
        red1, red2, red3, blue1, blue2, blue3);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MatchScorePrediction>(
      future: _getPrediction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              Text("Loading prediction..."),
              const CircularProgressIndicator(),
            ],
          );
        } else if (snapshot.hasData) {
          return SizedBox(
            height: (!adhoc) ?
              MediaQuery.sizeOf(context).height - 175.0 :
              MediaQuery.sizeOf(context).height - 275.0,
            child: Padding(   
            // return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                // shrinkWrap: true,
                children: [
                  PredictionOverview(snapshot.data!),
                  AllianceOverview("Blue", blue1, blue2, blue3, blue1Summary, blue2Summary, blue3Summary),
                  AllianceOverview("Red", red1, red2, red3, red1Summary, red2Summary, red3Summary),
                ],
              ),
            ),
            );
          // );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
