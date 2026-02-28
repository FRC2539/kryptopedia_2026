import 'dart:async';

// import 'package:kryptopedia/models/game_states.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_metrics.dart';

import 'package:kryptopedia_2025/util/dbhelpers/dbeventinsights.dart';
import 'package:kryptopedia_2025/util/dbhelpers/dbeventranking.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/db/scouted_matches.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';
// import 'package:kryptopedia_2025/util/dbhelpers/dbstatboticsteamstats.dart';

class CalculateAllTeamMetrics {
  CalculateAllTeamMetrics();

  Future<TeamMetrics> calculateTeamMetrics(
    int eventId,
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

    double average(List<int> items) {
      if (items.isEmpty) return 0;
      items.sort();
      if (removeLowest && items.length > 2) {
        items.removeAt(0);
        items.removeAt(0);
      }

      int total = 0;
      for (int i = 0; i < items.length; i++) {
        total += items[i];
      }
      return (total / items.length);
    }

    // Calculate Scouted Match information
    DbScoutedMatches dbScoutedMatches = DbScoutedMatches();
    List<ScoutedMatch> scoutedMatches = await dbScoutedMatches.getScoutedMatch(teamId);

    for (int i = 0; i < scoutedMatches.length; i++) {
      teamMetrics.matchCount++;

      teamMetrics.autoCoralScoreTotal +=
          (scoutedMatches[i].autoCoralLevel1 * 3) +
          (scoutedMatches[i].autoCoralLevel2 * 4) +
          (scoutedMatches[i].autoCoralLevel3 * 6) +
          (scoutedMatches[i].autoCoralLevel4 * 7);
      teamMetrics.autoAlgaeScoreTotal +=
          (scoutedMatches[i].autoAlgaeProcessor * 6) +
          (scoutedMatches[i].autoAlgaeCargoNet * 4);
      teamMetrics.teleopCoralScoreTotal +=
          (scoutedMatches[i].teleopCoralLevel1 * 2) +
          (scoutedMatches[i].teleopCoralLevel2 * 3) +
          (scoutedMatches[i].teleopCoralLevel3 * 4) +
          (scoutedMatches[i].teleopCoralLevel4 * 5);
      teamMetrics.teleopAlgaeScoreTotal +=
          (scoutedMatches[i].teleopAlgaeProcessor * 6) +
          (scoutedMatches[i].teleopAlgaeCargoNet * 4);

      // Calculate Autonomous items
      if (scoutedMatches[i].autoLeaveZone) teamMetrics.autoLeaveZoneTotal++;
      if (scoutedMatches[i].autoLeaveZoneAssist) {
        teamMetrics.autoLeaveZoneAssistTotal++;
      }

      teamMetrics.autoCoralLevel1Total += scoutedMatches[i].autoCoralLevel1;
      teamMetrics.autoCoralLevel2Total += scoutedMatches[i].autoCoralLevel2;
      teamMetrics.autoCoralLevel3Total += scoutedMatches[i].autoCoralLevel3;
      teamMetrics.autoCoralLevel4Total += scoutedMatches[i].autoCoralLevel4;
      teamMetrics.autoAlgaeRemovedFromReefTotal +=
          scoutedMatches[i].autoAlgaeRemovedFromReef;
      teamMetrics.autoAlgaeProcessorTotal +=
          scoutedMatches[i].autoAlgaeProcessor;
      teamMetrics.autoAlgaeCargoNetTotal += scoutedMatches[i].autoAlgaeCargoNet;

      // Calculate Teleop items
      teamMetrics.teleopCoralPiecesTotal +=
          (scoutedMatches[i].teleopCoralLevel1 +
          scoutedMatches[i].teleopCoralLevel2 +
          scoutedMatches[i].teleopCoralLevel3 +
          scoutedMatches[i].teleopCoralLevel4);

      teamMetrics.teleopCoralLevel1Total += scoutedMatches[i].teleopCoralLevel1;
      teamMetrics.teleopCoralLevel2Total += scoutedMatches[i].teleopCoralLevel2;
      teamMetrics.teleopCoralLevel3Total += scoutedMatches[i].teleopCoralLevel3;
      teamMetrics.teleopCoralLevel4Total += scoutedMatches[i].teleopCoralLevel4;
      teamMetrics.teleopAlgaeRemovedFromReefTotal +=
          scoutedMatches[i].teleopAlgaeRemovedFromReef;
      teamMetrics.teleopAlgaeProcessorTotal +=
          scoutedMatches[i].teleopAlgaeProcessor;
      teamMetrics.teleopAlgaeCargoNetTotal +=
          scoutedMatches[i].teleopAlgaeCargoNet;

      switch (scoutedMatches[i].teleopEndGame) {
        case EndGameStatus.none:
          teamMetrics.teleopEndGameTotals[0]++;
          break;
        case EndGameStatus.parked:
          teamMetrics.teleopEndGameTotals[1]++;
          break;
        case EndGameStatus.shallow:
          teamMetrics.teleopEndGameTotals[2]++;
          break;
        case EndGameStatus.deep:
          teamMetrics.teleopEndGameTotals[3]++;
          break;
      }

      // Calculate Summary Items
      for (RobotRole robotRole in scoutedMatches[i].summaryRoles) {
        switch (robotRole) {
          case RobotRole.offense:
            teamMetrics.summaryRolesTotals[0]++;
            break;
          case RobotRole.defense:
            teamMetrics.summaryRolesTotals[1]++;
            break;
        }
      }

      for (OperationalIssue operationIssue
          in scoutedMatches[i].summaryOperationalIssues) {
        switch (operationIssue) {
          case OperationalIssue.disabled:
            teamMetrics.summaryOperationalIssuesTotals[0]++;
            break;
          case OperationalIssue.power:
            teamMetrics.summaryOperationalIssuesTotals[1]++;
            break;
          case OperationalIssue.connection:
            teamMetrics.summaryOperationalIssuesTotals[2]++;
            break;
        }
      }

      for (MechanicalIssue mechanicalIssue
          in scoutedMatches[i].summaryMechanicalIssues) {
        switch (mechanicalIssue) {
          case MechanicalIssue.drivebase:
            teamMetrics.summaryMechanicalIssuesTotals[0]++;
            break;
          case MechanicalIssue.coralintake:
            teamMetrics.summaryMechanicalIssuesTotals[1]++;
            break;
          case MechanicalIssue.algaeintake:
            teamMetrics.summaryMechanicalIssuesTotals[2]++;
            break;
          case MechanicalIssue.elevator:
            teamMetrics.summaryMechanicalIssuesTotals[3]++;
            break;
        }
      }
    }

    if (scoutedMatches.isNotEmpty) {
      teamMetrics.teleopCoralPiecesAverage =
          teamMetrics.teleopCoralPiecesTotal / scoutedMatches.length;

      // Calculate scoring averages
      teamMetrics.autoCoralScoreAverage = average(
        scoutedMatches
            .map(
              (m) =>
                  m.autoCoralLevel1 * 3 +
                  m.autoCoralLevel2 * 4 +
                  m.autoCoralLevel3 * 6 +
                  m.autoCoralLevel4 * 7,
            )
            .toList(),
      );
      teamMetrics.autoAlgaeScoreAverage = average(
        scoutedMatches
            .map((m) => m.autoAlgaeProcessor * 6 + m.autoAlgaeCargoNet * 4)
            .toList(),
      );
      teamMetrics.teleopCoralScoreAverage = average(
        scoutedMatches
            .map(
              (m) =>
                  m.teleopCoralLevel1 * 2 +
                  m.teleopCoralLevel2 * 3 +
                  m.teleopCoralLevel3 * 4 +
                  m.teleopCoralLevel4 * 5,
            )
            .toList(),
      );
      teamMetrics.teleopAlgaeScoreAverage = average(
        scoutedMatches
            .map((m) => m.teleopAlgaeProcessor * 6 + m.teleopAlgaeCargoNet * 4)
            .toList(),
      );

      // Calculate autonomous averages and percents
      teamMetrics.autoLeaveZonePercent =
          teamMetrics.autoLeaveZoneTotal / scoutedMatches.length;
      teamMetrics.autoLeaveZoneAssistPercent =
          teamMetrics.autoLeaveZoneAssistTotal / scoutedMatches.length;

      teamMetrics.autoCoralLevel1Average = average(
        scoutedMatches.map((m) => m.autoCoralLevel1).toList(),
      );
      teamMetrics.autoCoralLevel2Average = average(
        scoutedMatches.map((m) => m.autoCoralLevel2).toList(),
      );
      teamMetrics.autoCoralLevel3Average = average(
        scoutedMatches.map((m) => m.autoCoralLevel3).toList(),
      );
      teamMetrics.autoCoralLevel4Average = average(
        scoutedMatches.map((m) => m.autoCoralLevel4).toList(),
      );

      teamMetrics.autoAlgaeRemovedFromReefAverage = average(
        scoutedMatches.map((m) => m.autoAlgaeRemovedFromReef).toList(),
      );
      teamMetrics.autoAlgaeProcessorAverage = average(
        scoutedMatches.map((m) => m.autoAlgaeProcessor).toList(),
      );
      teamMetrics.autoAlgaeCargoNetAverage = average(
        scoutedMatches.map((m) => m.autoAlgaeCargoNet).toList(),
      );

      // Calculate teleop averages and percents
      teamMetrics.teleopCoralLevel1Average = average(
        scoutedMatches.map((m) => m.teleopCoralLevel1).toList(),
      );
      teamMetrics.teleopCoralLevel2Average = average(
        scoutedMatches.map((m) => m.teleopCoralLevel2).toList(),
      );
      teamMetrics.teleopCoralLevel3Average = average(
        scoutedMatches.map((m) => m.teleopCoralLevel3).toList(),
      );
      teamMetrics.teleopCoralLevel4Average = average(
        scoutedMatches.map((m) => m.teleopCoralLevel4).toList(),
      );

      teamMetrics.teleopAlgaeRemovedFromReefAverage = average(
        scoutedMatches.map((m) => m.teleopAlgaeRemovedFromReef).toList(),
      );
      teamMetrics.teleopAlgaeProcessorAverage = average(
        scoutedMatches.map((m) => m.teleopAlgaeProcessor).toList(),
      );
      teamMetrics.teleopAlgaeCargoNetAverage = average(
        scoutedMatches.map((m) => m.teleopAlgaeCargoNet).toList(),
      );

      for (int i = 0; i < teamMetrics.teleopEndGameTotals.length; i++) {
        teamMetrics.teleopEndGamePercents[i] =
            teamMetrics.teleopEndGameTotals[i] / scoutedMatches.length;
      }

      // Calculate summary averages and percents
      for (int i = 0; i < teamMetrics.summaryRolesTotals.length; i++) {
        teamMetrics.summaryRolesPercent[i] =
            teamMetrics.summaryRolesTotals[i] / scoutedMatches.length;
      }

      for (
        int i = 0;
        i < teamMetrics.summaryOperationalIssuesTotals.length;
        i++
      ) {
        teamMetrics.summaryOperationalIssuesPercents[i] =
            teamMetrics.summaryOperationalIssuesTotals[i] /
            scoutedMatches.length;
      }

      for (
        int i = 0;
        i < teamMetrics.summaryMechanicalIssuesTotals.length;
        i++
      ) {
        teamMetrics.summaryMechanicalIssuesPercents[i] =
            teamMetrics.summaryMechanicalIssuesTotals[i] /
            scoutedMatches.length;
      }
    }

    // Return Team stats to caller
    return teamMetrics;
  }
}
