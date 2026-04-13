//import 'package:kryptopedia/models/game_states.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/teaminfosummary.dart';

class CalculateTeamInfoAverages {
  CalculateTeamInfoAverages() {
    // Do nothing
  }

  static TeamInfoSummary calculateAverages(List<ScoutedMatch> scoutedMatches) {
    TeamInfoSummary teamInfoSummary = TeamInfoSummary();

    teamInfoSummary.numberOfMatches = scoutedMatches.length;

    if (scoutedMatches.isEmpty) {
      teamInfoSummary.autoFuelScoreMin = 0;
      teamInfoSummary.autoFuelScoreMax = 0;
      teamInfoSummary.teleopFuelScoreMin = 0;
      teamInfoSummary.teleopFuelScoreMax = 0;
    }

    for (int i = 0; i < scoutedMatches.length; i++) {
      // Calculate issue totals
      teamInfoSummary.summaryIssuesTotal[scoutedMatches[i].issues]++;

      // Calculate Autonomous Totals
      if (scoutedMatches[i].autoClimbed) teamInfoSummary.autoClimbedTotal++;

      teamInfoSummary.autoFuelScoreTotal += scoutedMatches[i].autoFuelScored;

      // Calculate the Auto Min Values
      if (teamInfoSummary.autoFuelScoreMin > scoutedMatches[i].autoFuelScored) {
        teamInfoSummary.autoFuelScoreMin = scoutedMatches[i].autoFuelScored;
      }

      // Calculate the Auto Max Values
      if (teamInfoSummary.autoFuelScoreMax < scoutedMatches[i].autoFuelScored) {
        teamInfoSummary.autoFuelScoreMax = scoutedMatches[i].autoFuelScored;
      }

      // Calculate Teleop Totals
      teamInfoSummary.teleopFuelScoreTotal +=
          scoutedMatches[i].teleopFuelScored;
      teamInfoSummary.teleopFuelFedTotal +=
          scoutedMatches[i].teleopFuelFed;

      switch (scoutedMatches[i].climbLevel) {
        case ClimbLevel.none:
          teamInfoSummary.teleopClimbedTotals[0]++;
          break;
        case ClimbLevel.L1:
          teamInfoSummary.teleopClimbedTotals[1]++;
          break;
        case ClimbLevel.L2:
          teamInfoSummary.teleopClimbedTotals[2]++;
          break;
        case ClimbLevel.L3:
          teamInfoSummary.teleopClimbedTotals[3]++;
          break;
      }

      // Calculate the Teleop Min Values
      if (teamInfoSummary.teleopFuelScoreMin > scoutedMatches[i].teleopFuelScored) {
        teamInfoSummary.teleopFuelScoreMin = scoutedMatches[i].teleopFuelScored;
      }
      if (teamInfoSummary.teleopFuelFedMin > scoutedMatches[i].teleopFuelFed) {
        teamInfoSummary.teleopFuelFedMin = scoutedMatches[i].teleopFuelFed;
      }

      // Calculate the Teleop Max Values
      if (teamInfoSummary.teleopFuelScoreMax < scoutedMatches[i].teleopFuelScored) {
        teamInfoSummary.teleopFuelScoreMax = scoutedMatches[i].teleopFuelScored;
      }
      if (teamInfoSummary.teleopFuelFedMax < scoutedMatches[i].teleopFuelFed) {
        teamInfoSummary.teleopFuelFedMax = scoutedMatches[i].teleopFuelFed;
      }

    }

    // Calculate Autonomous Averages and Percents
    if (scoutedMatches.isNotEmpty) {
      for (int i = 0; i < teamInfoSummary.summaryIssuesTotal.length; i++) {
        teamInfoSummary.summaryIssuesPercent[i] =
            (teamInfoSummary.summaryIssuesTotal[i] / scoutedMatches.length) *
            100.0;
      }
          
      teamInfoSummary.autoFuelScoreAverage =
          teamInfoSummary.autoFuelScoreTotal / scoutedMatches.length;

      teamInfoSummary.autoClimbedPercent =
          (teamInfoSummary.autoClimbedTotal / scoutedMatches.length) * 100.0;

      // Calculate Teleop Averages and Percents
      teamInfoSummary.teleopFuelScoreAverage =
          teamInfoSummary.teleopFuelScoreTotal / scoutedMatches.length;
      teamInfoSummary.teleopFuelFedAverage =
          teamInfoSummary.teleopFuelFedTotal / scoutedMatches.length;

      for (int i = 0; i < teamInfoSummary.teleopClimbedTotals.length; i++) {
        teamInfoSummary.teleopClimbedPercents[i] =
            (teamInfoSummary.teleopClimbedTotals[i] / scoutedMatches.length) *
            100.0;
      }
    }

    // Return information to caller
    return teamInfoSummary;
  }
}
