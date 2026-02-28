import 'dart:async';

// import 'package:kryptopedia/models/game_states.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_metrics.dart';

// import 'package:kryptopedia_2025/util/dbhelpers/dbeventinsights.dart';
// import 'package:kryptopedia_2025/util/dbhelpers/dbeventranking.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
// import 'package:kryptopedia_2025/util/dbhelpers/dbstatboticsteamstats.dart';

class CalculateAllTeamMetrics {
  CalculateAllTeamMetrics();

  Future<TeamMetrics> calculateTeamMetrics(
    int teamId, {
    bool removeLowest = false,
  }) async {
    // Initialize Team stats
    TeamMetrics teamMetrics = TeamMetrics();

    // Retrieve Team Information
    DbTeams dbTeams = DbTeams();
    Team team = await dbTeams.getTeam(teamId);

    teamMetrics.teamId = team.number;
    teamMetrics.teamName = team.nickname;

    // Retrieve Pit Information
    DbScoutedPits dbScoutedPits = DbScoutedPits();
    ScoutedPit? scoutedPit = await dbScoutedPits.getScoutedPit(teamId);

    // // Retrieve Event Rankings
    // DbEventRanking dbEventRanking = DbEventRanking();
    // int? ranking = await dbEventRanking.getTeamRanking(eventId, teamId);
    // teamMetrics.teamRanking = (ranking != null) ? ranking : 0;

    // // Retrieve Event OPRS
    // DbEventInsights dbEventInsights = DbEventInsights();
    // double? oprs = await dbEventInsights.getTeamOprs(eventId, teamId);
    // teamMetrics.teamOprs = (oprs != null) ? oprs : 0.0;

    // Retrieve Team Epa
    // DbStatboticsTeamStats dbStatboticsTeamStats = DbStatboticsTeamStats();
    // double? epa = await dbStatboticsTeamStats.getTeamEpa(eventId, teamId);
    // teamMetrics.teamEpa = (epa != null) ? epa : 0.0;

    // Set pit team metric information
    if (scoutedPit != null) {
      switch (scoutedPit.drivetrain) {
        case Drivetrain.swerve:
          teamMetrics.driveTrain = "Swerve";
          break;
        case Drivetrain.tank:
          teamMetrics.driveTrain = "Tank";
          break;
        case Drivetrain.mecanum:
          teamMetrics.driveTrain = "Mecanum";
          break;
        case Drivetrain.other:
          teamMetrics.driveTrain = "Other";
          break;
      }

      teamMetrics.robotWeight = scoutedPit.weight;
    }

    // Calculate Scouted Match information
    DbScoutedMatches dbScoutedMatches = DbScoutedMatches();
    List<ScoutedMatch> scoutedMatches = await dbScoutedMatches
        .getScoutedMatchesForTeam(teamId);

    teamMetrics.matchCount = scoutedMatches.length;

    // Process each scouted match for a given team
    for (int i = 0; i < scoutedMatches.length; i++) {
      // Calculate the total fuel scores
      teamMetrics.autoFuelScoreTotal += scoutedMatches[i].autoFuelScored;
      teamMetrics.teleopFuelScoreTotal += scoutedMatches[i].teleopFuelScored;
      teamMetrics.teleopFuelFedTotal += scoutedMatches[i].teleopFuelFed;

      // Calculate the totals for climbing
      if (scoutedMatches[i].autoClimbed) {
        teamMetrics.autoClimbedTotal++;
      }

      switch (scoutedMatches[i].climbLevel) {
        case ClimbLevel.none:
          teamMetrics.teleopClimbedTotals[0]++;
          break;
        case ClimbLevel.L1:
          teamMetrics.teleopClimbedTotals[1]++;
          break;
        case ClimbLevel.L2:
          teamMetrics.teleopClimbedTotals[2]++;
          break;
        case ClimbLevel.L3:
          teamMetrics.teleopClimbedTotals[3]++;
          break;
      }

      // // Calculate Summary Items
      // for (RobotRole robotRole in scoutedMatches[i].summaryRoles) {
      //   switch (robotRole) {
      //     case RobotRole.offense:
      //       teamMetrics.summaryRolesTotals[0]++;
      //       break;
      //     case RobotRole.defense:
      //       teamMetrics.summaryRolesTotals[1]++;
      //       break;
      //   }
      // }

      // for (OperationalIssue operationIssue
      //     in scoutedMatches[i].summaryOperationalIssues) {
      //   switch (operationIssue) {
      //     case OperationalIssue.disabled:
      //       teamMetrics.summaryOperationalIssuesTotals[0]++;
      //       break;
      //     case OperationalIssue.power:
      //       teamMetrics.summaryOperationalIssuesTotals[1]++;
      //       break;
      //     case OperationalIssue.connection:
      //       teamMetrics.summaryOperationalIssuesTotals[2]++;
      //       break;
      //   }
      // }

      // for (MechanicalIssue mechanicalIssue
      //     in scoutedMatches[i].summaryMechanicalIssues) {
      //   switch (mechanicalIssue) {
      //     case MechanicalIssue.drivebase:
      //       teamMetrics.summaryMechanicalIssuesTotals[0]++;
      //       break;
      //     case MechanicalIssue.coralintake:
      //       teamMetrics.summaryMechanicalIssuesTotals[1]++;
      //       break;
      //     case MechanicalIssue.algaeintake:
      //       teamMetrics.summaryMechanicalIssuesTotals[2]++;
      //       break;
      //     case MechanicalIssue.elevator:
      //       teamMetrics.summaryMechanicalIssuesTotals[3]++;
      //       break;
      //   }
      // }
    }

    // Calculate the averages if the team has been scouted at least once.
    if (scoutedMatches.isNotEmpty) {
      // Calculate fuel averages
      teamMetrics.autoFuelScoreAverage =
          teamMetrics.autoFuelScoreTotal / scoutedMatches.length;
      teamMetrics.teleopFuelScoreAverage =
          teamMetrics.teleopFuelScoreTotal / scoutedMatches.length;
      teamMetrics.teleopFuelFedAverage =
          teamMetrics.teleopFuelFedTotal / scoutedMatches.length;

      // Calculate climbing averages
      teamMetrics.autoClimbedAverage =
          teamMetrics.autoClimbedTotal / scoutedMatches.length;

      for (int i = 0; i < teamMetrics.teleopClimbedTotals.length; i++) {
        teamMetrics.teleopClimbedPercents[i] =
            (teamMetrics.teleopClimbedTotals[i] / scoutedMatches.length) *
            100.0;
      }

      // // Calculate summary averages and percents
      // for (int i = 0; i < teamMetrics.summaryRolesTotals.length; i++) {
      //   teamMetrics.summaryRolesPercent[i] =
      //       teamMetrics.summaryRolesTotals[i] / scoutedMatches.length;
      // }

      // for (
      //   int i = 0;
      //   i < teamMetrics.summaryOperationalIssuesTotals.length;
      //   i++
      // ) {
      //   teamMetrics.summaryOperationalIssuesPercents[i] =
      //       teamMetrics.summaryOperationalIssuesTotals[i] /
      //       scoutedMatches.length;
      // }

      // for (
      //   int i = 0;
      //   i < teamMetrics.summaryMechanicalIssuesTotals.length;
      //   i++
      // ) {
      //   teamMetrics.summaryMechanicalIssuesPercents[i] =
      //       teamMetrics.summaryMechanicalIssuesTotals[i] /
      //       scoutedMatches.length;
      // }
    }

    // Return Team stats to caller
    return teamMetrics;
  }
}
