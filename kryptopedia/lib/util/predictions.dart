import 'package:kryptopedia/models/team_metrics.dart';
import 'package:kryptopedia/util/2026helpers/calculate_all_team_metrics.dart';

class MatchScorePrediction {
  final int red1;
  final int red2;
  final int red3;
  final int blue1;
  final int blue2;
  final int blue3;

  late AllianceScorePrediction red;
  late AllianceScorePrediction blue;

  MatchScorePrediction._create(
      this.red1, this.red2, this.red3, this.blue1, this.blue2, this.blue3);

  static Future<MatchScorePrediction> createPrediction(
      int red1, int red2, int red3, int blue1, int blue2, int blue3) async {
    MatchScorePrediction component =
        MatchScorePrediction._create(red1, red2, red3, blue1, blue2, blue3);

    component.red =
        await AllianceScorePrediction.createPrediction(red1, red2, red3);
    component.blue =
        await AllianceScorePrediction.createPrediction(blue1, blue2, blue3);

    component.red.color = "Red";
    component.blue.color = "Blue";

    return component;
  }
}

class AllianceScorePrediction {
  final int team1number;
  final int team2number;
  final int team3number;
  String color;

  late TeamScorePrediction team1;
  late TeamScorePrediction team2;
  late TeamScorePrediction team3;
  List<TeamScorePrediction> get teams => [team1, team2, team3];

  int get autoFuelPoints {
    double points = 0;
    for (TeamScorePrediction team in teams) {
      points += team._averages.autoFuelScoreAverage;
    }
    return points.floor();
  }

  int get teleopFuelPoints {
    double points = 0;
    for (TeamScorePrediction team in teams) {
      points += team._averages.teleopFuelScoreAverage;
    }
    return points.floor();
  }

  int get autoClimbPoints {
    int count = 0;
    for (TeamScorePrediction team in teams) {
      count += (team._averages.autoClimbedPercent / 100.0).round();
    }
    return 10 * count;
  }

  int get teleopClimbPoints {
    int points = 0;
    for (TeamScorePrediction team in teams) {
      points += team.climbScored;
    }
    return points;
  }

  int get fuelRankingPoints {
    int total = autoFuelPoints + teleopFuelPoints;
    if (total < 360) {
      return 0;
    } else if (total < 500) {
      return 1;
    } else {
      return 2;
    }
  }

  bool get climbRankingPoint {
    int points = 0;
    for (TeamScorePrediction team in teams) {
      points += team.climbScored;
    }
    return (points >= 50);
  }
  
  int get totalPoints {
    return autoFuelPoints + teleopFuelPoints + autoClimbPoints + teleopClimbPoints;
  }

  bool get enoughForPrediction {
    return team1.enoughForPrediction &&
        team2.enoughForPrediction &&
        team3.enoughForPrediction;
  }

  AllianceScorePrediction._create(
      this.team1number, this.team2number, this.team3number)
      : color = "Red";

  static Future<AllianceScorePrediction> createPrediction(
    int team1,
    int team2,
    int team3,
  ) async {
    AllianceScorePrediction component =
        AllianceScorePrediction._create(team1, team2, team3);

    component.team1 =
        await TeamScorePrediction.createPrediction(component.team1number);
    component.team2 =
        await TeamScorePrediction.createPrediction(component.team2number);
    component.team3 =
        await TeamScorePrediction.createPrediction(component.team3number);

    return component;
  }
}

class TeamScorePrediction {
  final int number;

  int indexOfMax(List<double> list) {
    int maxIndex = 0;
    double maxValue = list[0];

    for (int i = 1; i < list.length; i++) {
      if (list[i] > maxValue) {
        maxValue = list[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  int get climbScored => 10 * indexOfMax(_averages.teleopClimbedPercents);

  /*List<RobotRole> roles;
  List<OperationalIssue> operationalIssues;
  List<MechanicalIssue> mechanicalIssues;*/

  late TeamMetrics _averages;

  bool get enoughForPrediction => _averages.matchCount > 3;

  TeamScorePrediction._create(this.number);
       /*:  roles = [],
        operationalIssues = [],
        mechanicalIssues = [];*/

  static Future<TeamScorePrediction> createPrediction(int number) async {
    TeamScorePrediction component = TeamScorePrediction._create(number);

    // DbScoutedMatch dbScoutedMatch = DbScoutedMatch();
    // List<ScoutedMatch> matches =
    //     await dbScoutedMatch.getScoutedMatchesForTeamAtEvent(event.id, number);

    CalculateAllTeamMetrics calculateAllTeamMetrics = CalculateAllTeamMetrics();
    component._averages = await calculateAllTeamMetrics
        .calculateTeamMetrics(number, removeLowest: true);

    return component;
  }
}
