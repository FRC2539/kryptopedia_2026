class TeamMetrics {
  int teamId = 0;
  String teamName = "";

  int matchCount = 0;
  int teamRanking = 0;
  double teamOprs = 0.0;
  // double teamEpa = 0.0;

  // Information Match Scoring
  int autoFuelScoreTotal = 0;
  double autoFuelScoreAverage = 0.0;
  int teleopFuelScoreTotal = 0;
  double teleopFuelScoreAverage = 0.0;
  int teleopFuelFedTotal = 0;
  double teleopFuelFedAverage = 0.0;

  int autoClimbedTotal = 0;
  double autoClimbedAverage = 0.0;
  List<int> teleopClimbedTotals = [0, 0, 0, 0];
  List<double> teleopClimbedPercents = [0.0, 0.0, 0.0, 0.0];

  // List<int> summaryRolesTotals = [ 0, 0 ];
  // List<double> summaryRolesPercent = [ 0.0, 0.0 ];
  // List<int> summaryOperationalIssuesTotals = [ 0, 0, 0 ];
  // List<double> summaryOperationalIssuesPercents = [ 0.0, 0.0, 0.0 ];
  // List<int> summaryMechanicalIssuesTotals = [ 0, 0, 0, 0 ];
  // List<double> summaryMechanicalIssuesPercents = [ 0.0, 0.0, 0.0, 0.0 ];

  // Information Gathered from Pit Scouting
  String driveTrain = "";
  int robotWeight = -1;

  static int calculateIntMax(int a, int b) {
    return (a >= b) ?  a :  b;
  }

  static double calculateDoubleMax(double a, double b) {
    return (a >= b) ? a : b;
  }

  void calculateMaxValues(TeamMetrics teamMetrics) {
    robotWeight = calculateIntMax(robotWeight, teamMetrics.robotWeight);

    autoFuelScoreTotal = calculateIntMax(
      autoFuelScoreTotal,
      teamMetrics.autoFuelScoreTotal,
    );
    autoFuelScoreAverage = calculateDoubleMax(
      autoFuelScoreAverage,
      teamMetrics.autoFuelScoreAverage,
    );
  
    teleopFuelScoreTotal = calculateIntMax(
      teleopFuelScoreTotal,
      teamMetrics.teleopFuelScoreTotal,
    );
    teleopFuelScoreAverage = calculateDoubleMax(
      teleopFuelScoreAverage,
      teamMetrics.teleopFuelScoreAverage,
    );

    // for (int i = 0; i < teleopEndGameTotals.length; i++) {
    //   teleopEndGameTotals[i] = calculateIntMax(teleopEndGameTotals[i], teamMetrics.teleopEndGameTotals[i]);
    //   teleopEndGamePercents[i] = calculateDoubleMax(teleopEndGamePercents[i], teamMetrics.teleopEndGamePercents[i]);
    // }

    // for (int i = 0; i < summaryRolesTotals.length; i++) {
    //   summaryRolesTotals[i] = calculateIntMax(summaryRolesTotals[i], teamMetrics.summaryRolesTotals[i]);
    //   summaryRolesPercent[i] = calculateDoubleMax(summaryRolesPercent[i], teamMetrics.summaryRolesPercent[i]);
    // }

    // for (int i = 0; i < summaryOperationalIssuesTotals.length; i++) {
    //   summaryOperationalIssuesTotals[i] =
    //     calculateIntMax(summaryOperationalIssuesTotals[i], teamMetrics.summaryOperationalIssuesTotals[i]);
    //   summaryOperationalIssuesPercents[i] =
    //     calculateDoubleMax(summaryOperationalIssuesPercents[i], teamMetrics.summaryOperationalIssuesPercents[i]);
    // }

    // for (int i = 0; i < summaryMechanicalIssuesTotals.length; i++) {
    //   summaryMechanicalIssuesTotals[i] =
    //     calculateIntMax(summaryMechanicalIssuesTotals[i], teamMetrics.summaryMechanicalIssuesTotals[i]);
    //   summaryMechanicalIssuesPercents[i] =
    //     calculateDoubleMax(summaryMechanicalIssuesPercents[i], teamMetrics.summaryMechanicalIssuesPercents[i]);
    // }
  }
}
