import 'dart:async';

// import 'package:kryptopedia/models/game_states.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_insights_record.dart';
import 'package:kryptopedia/models/team_metrics.dart';

import 'package:kryptopedia/util/db/team_insights.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';

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

    // Retrieve ranking & OPR
    DbTeamInsightsRecords dbTeamInsightsRecords = DbTeamInsightsRecords();
    TeamInsightsRecord? insights = await dbTeamInsightsRecords.getTeamInsights(
      teamId,
    );

    teamMetrics.teamRanking = (insights?.ranking != null)
        ? insights!.ranking!
        : 0;
    teamMetrics.teamOPR = (insights?.opr != null) ? insights!.opr! : 0.0;

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

      teamMetrics.kitBot = scoutedPit.isKitBot;
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

      // Calculate Summary Items
      for (RobotRole robotRole in scoutedMatches[i].robotRoles) {
        switch (robotRole) {
          case RobotRole.offense:
            teamMetrics.summaryRolesTotals[0]++;
            break;
          case RobotRole.defense:
            teamMetrics.summaryRolesTotals[1]++;
            break;
          case RobotRole.feeder:
            teamMetrics.summaryRolesTotals[2]++;
            break;
        }
      }

      switch (scoutedMatches[i].penalties) {
        case Penalties.none:
          teamMetrics.summaryPenaltiesTotals[0]++;
          break;
        case Penalties.one:
          teamMetrics.summaryPenaltiesTotals[1]++;
          break;
        case Penalties.few:
          teamMetrics.summaryPenaltiesTotals[2]++;
          break;
        case Penalties.many:
          teamMetrics.summaryPenaltiesTotals[3]++;
          break;
      }

      if (scoutedMatches[i].issues) {
        teamMetrics.summaryIssuesTotal++;
      }

      // Calculate the totals for start positions
      switch (scoutedMatches[i].startPosition) {
        case StartPosition.lTrench:
          teamMetrics.startPositionTotals[0]++;
          break;
        case StartPosition.lBump:
          teamMetrics.startPositionTotals[1]++;
          break;
        case StartPosition.center:
          teamMetrics.startPositionTotals[2]++;
          break;
        case StartPosition.rBump:
          teamMetrics.startPositionTotals[3]++;
          break;
        case StartPosition.rTrench:
          teamMetrics.startPositionTotals[4]++;
          break;
        case StartPosition.none:
          teamMetrics.startPositionTotals[5]++;
          break;
      }
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
      teamMetrics.autoClimbedPercent =
          (teamMetrics.autoClimbedTotal / scoutedMatches.length) * 100.0;

      for (int i = 0; i < teamMetrics.teleopClimbedTotals.length; i++) {
        teamMetrics.teleopClimbedPercents[i] =
            (teamMetrics.teleopClimbedTotals[i] / scoutedMatches.length) *
            100.0;
      }

      // Calculate summary averages and percents
      for (int i = 0; i < teamMetrics.summaryRolesTotals.length; i++) {
        teamMetrics.summaryRolesPercent[i] =
            (teamMetrics.summaryRolesTotals[i] / scoutedMatches.length) * 100.0;
      }

      for (int i = 0; i < teamMetrics.summaryPenaltiesTotals.length; i++) {
        teamMetrics.summaryPenaltiesPercents[i] =
            (teamMetrics.summaryPenaltiesTotals[i] / scoutedMatches.length) *
            100.0;
      }

      teamMetrics.summaryIssuesPercent =
          (teamMetrics.summaryIssuesTotal / scoutedMatches.length) * 100.0;

      // Calculate start position averages
      for (int i = 0; i < teamMetrics.startPositionTotals.length; i++) {
        teamMetrics.startPositionPercents[i] =
            (teamMetrics.startPositionTotals[i] / scoutedMatches.length) *
            100.0;
      }

    }

    // Return Team stats to caller
    return teamMetrics;
  }
}
