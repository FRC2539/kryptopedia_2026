class TeamMetrics {
  int teamId = 0;
  String teamName = "";

  int matchCount = 0;
  int teamRanking = 0;
  double teamOprs = 0.0;
  // double teamEpa = 0.0;

  // Information Match Scoring
  int autoCoralScoreTotal = 0;
  double autoCoralScoreAverage = 0.0;
  int autoAlgaeScoreTotal = 0;
  double autoAlgaeScoreAverage = 0.0;
  int teleopCoralScoreTotal = 0;
  double teleopCoralScoreAverage = 0.0;
  int teleopAlgaeScoreTotal = 0;
  double teleopAlgaeScoreAverage = 0.0;

  // Information Gathered from Match Scouting
  int autoLeaveZoneTotal = 0;
  double autoLeaveZonePercent = 0.0;
  int autoLeaveZoneAssistTotal = 0;
  double autoLeaveZoneAssistPercent = 0.0;
  int autoCoralLevel1Total = 0;
  double autoCoralLevel1Average = 0.0;
  int autoCoralLevel2Total = 0;
  double autoCoralLevel2Average = 0.0;
  int autoCoralLevel3Total = 0;
  double autoCoralLevel3Average = 0.0;
  int autoCoralLevel4Total = 0;
  double autoCoralLevel4Average = 0.0;
  int autoAlgaeRemovedFromReefTotal = 0;
  double autoAlgaeRemovedFromReefAverage = 0.0;
  int autoAlgaeProcessorTotal = 0;
  double autoAlgaeProcessorAverage = 0.0;
  int autoAlgaeCargoNetTotal = 0;
  double autoAlgaeCargoNetAverage = 0.0;

  int teleopCoralLevel1Total = 0;
  double teleopCoralLevel1Average = 0.0;
  int teleopCoralLevel2Total = 0;
  double teleopCoralLevel2Average = 0.0;
  int teleopCoralLevel3Total = 0;
  double teleopCoralLevel3Average = 0.0;
  int teleopCoralLevel4Total = 0;
  double teleopCoralLevel4Average = 0.0;
  int teleopCoralPiecesTotal = 0;
  double teleopCoralPiecesAverage = 0.0;
  int teleopAlgaeRemovedFromReefTotal = 0;
  double teleopAlgaeRemovedFromReefAverage = 0.0;
  int teleopAlgaeProcessorTotal = 0;
  double teleopAlgaeProcessorAverage = 0.0;
  int teleopAlgaeCargoNetTotal = 0;
  double teleopAlgaeCargoNetAverage = 0.0;
  List<int> teleopEndGameTotals = [ 0, 0, 0, 0 ];
  List<double> teleopEndGamePercents = [ 0.0, 0.0, 0.0, 0.0 ];

  List<int> summaryRolesTotals = [ 0, 0 ];
  List<double> summaryRolesPercent = [ 0.0, 0.0 ];
  List<int> summaryOperationalIssuesTotals = [ 0, 0, 0 ];
  List<double> summaryOperationalIssuesPercents = [ 0.0, 0.0, 0.0 ];
  List<int> summaryMechanicalIssuesTotals = [ 0, 0, 0, 0 ];
  List<double> summaryMechanicalIssuesPercents = [ 0.0, 0.0, 0.0, 0.0 ];

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

    autoCoralScoreTotal = calculateIntMax(autoCoralScoreTotal, teamMetrics.autoCoralScoreTotal);
    autoCoralScoreAverage = calculateDoubleMax(autoCoralScoreAverage, teamMetrics.autoCoralScoreAverage);
    autoAlgaeScoreTotal = calculateIntMax(autoAlgaeScoreTotal, teamMetrics.autoAlgaeScoreTotal);
    autoAlgaeScoreAverage = calculateDoubleMax(autoAlgaeScoreAverage, teamMetrics.autoAlgaeScoreAverage);

    teleopCoralPiecesTotal = calculateIntMax(teleopCoralPiecesTotal, teamMetrics.teleopCoralPiecesTotal);
    teleopCoralPiecesAverage = calculateDoubleMax(teleopCoralPiecesAverage, teamMetrics.teleopCoralPiecesAverage);
  
    teleopCoralScoreTotal = calculateIntMax(teleopCoralScoreTotal, teamMetrics.teleopCoralScoreTotal);
    teleopCoralScoreAverage = calculateDoubleMax(teleopCoralScoreAverage, teamMetrics.teleopCoralScoreAverage);
    teleopAlgaeScoreTotal = calculateIntMax(teleopAlgaeScoreTotal, teamMetrics.teleopAlgaeScoreTotal);
    teleopAlgaeScoreAverage = calculateDoubleMax(teleopAlgaeScoreAverage, teamMetrics.teleopAlgaeScoreAverage);

    autoLeaveZoneTotal = calculateIntMax(autoLeaveZoneTotal, teamMetrics.autoLeaveZoneTotal);
    autoLeaveZonePercent = calculateDoubleMax(autoLeaveZonePercent, teamMetrics.autoLeaveZonePercent);
    autoLeaveZoneAssistTotal = calculateIntMax(autoLeaveZoneAssistTotal, teamMetrics.autoLeaveZoneAssistTotal);
    autoLeaveZoneAssistPercent = calculateDoubleMax(autoLeaveZoneAssistPercent, teamMetrics.autoLeaveZoneAssistPercent);
    autoCoralLevel1Total = calculateIntMax(autoCoralLevel1Total, teamMetrics.autoCoralLevel1Total);
    autoCoralLevel1Average = calculateDoubleMax(autoCoralLevel1Average, teamMetrics.autoCoralLevel1Average);
    autoCoralLevel2Total = calculateIntMax(autoCoralLevel2Total, teamMetrics.autoCoralLevel2Total);
    autoCoralLevel2Average = calculateDoubleMax(autoCoralLevel2Average, teamMetrics.autoCoralLevel2Average);
    autoCoralLevel3Total = calculateIntMax(autoCoralLevel3Total, teamMetrics.autoCoralLevel3Total);
    autoCoralLevel3Average = calculateDoubleMax(autoCoralLevel3Average, teamMetrics.autoCoralLevel3Average);
    autoCoralLevel4Total = calculateIntMax(autoCoralLevel4Total, teamMetrics.autoCoralLevel4Total);
    autoCoralLevel4Average = calculateDoubleMax(autoCoralLevel4Average, teamMetrics.autoCoralLevel4Average);
    autoAlgaeRemovedFromReefTotal = calculateIntMax(autoAlgaeRemovedFromReefTotal, teamMetrics.autoAlgaeRemovedFromReefTotal);
    autoAlgaeRemovedFromReefAverage = calculateDoubleMax(autoAlgaeRemovedFromReefAverage, teamMetrics.autoAlgaeRemovedFromReefAverage);
    autoAlgaeProcessorTotal = calculateIntMax(autoAlgaeProcessorTotal, teamMetrics.autoAlgaeProcessorTotal);
    autoAlgaeProcessorAverage = calculateDoubleMax(autoAlgaeProcessorAverage, teamMetrics.autoAlgaeProcessorAverage);
    autoAlgaeCargoNetTotal = calculateIntMax(autoAlgaeCargoNetTotal, teamMetrics.autoAlgaeCargoNetTotal);
    autoAlgaeCargoNetAverage = calculateDoubleMax(autoAlgaeCargoNetAverage, teamMetrics.autoAlgaeCargoNetAverage);

    teleopCoralLevel1Total = calculateIntMax(teleopCoralLevel1Total, teamMetrics.teleopCoralLevel1Total);
    teleopCoralLevel1Average = calculateDoubleMax(teleopCoralLevel1Average, teamMetrics.teleopCoralLevel1Average);
    teleopCoralLevel2Total = calculateIntMax(teleopCoralLevel2Total, teamMetrics.teleopCoralLevel2Total);
    teleopCoralLevel2Average = calculateDoubleMax(teleopCoralLevel2Average, teamMetrics.teleopCoralLevel2Average);
    teleopCoralLevel3Total = calculateIntMax(teleopCoralLevel3Total, teamMetrics.teleopCoralLevel3Total);
    teleopCoralLevel3Average = calculateDoubleMax(teleopCoralLevel3Average, teamMetrics.teleopCoralLevel3Average);
    teleopCoralLevel4Total = calculateIntMax(teleopCoralLevel4Total, teamMetrics.teleopCoralLevel4Total);
    teleopCoralLevel4Average = calculateDoubleMax(teleopCoralLevel4Average, teamMetrics.teleopCoralLevel4Average);
    teleopAlgaeRemovedFromReefTotal = calculateIntMax(teleopAlgaeRemovedFromReefTotal, teamMetrics.teleopAlgaeRemovedFromReefTotal);
    teleopAlgaeRemovedFromReefAverage = calculateDoubleMax(teleopAlgaeRemovedFromReefAverage, teamMetrics.teleopAlgaeRemovedFromReefAverage);
    teleopAlgaeProcessorTotal = calculateIntMax(teleopAlgaeProcessorTotal, teamMetrics.teleopAlgaeProcessorTotal);
    teleopAlgaeProcessorAverage = calculateDoubleMax(teleopAlgaeProcessorAverage, teamMetrics.teleopAlgaeProcessorAverage);
    teleopAlgaeCargoNetTotal = calculateIntMax(teleopAlgaeCargoNetTotal, teamMetrics.teleopAlgaeCargoNetTotal);
    teleopAlgaeCargoNetAverage = calculateDoubleMax(teleopAlgaeCargoNetAverage, teamMetrics.teleopAlgaeCargoNetAverage);

    for (int i = 0; i < teleopEndGameTotals.length; i++) {
      teleopEndGameTotals[i] = calculateIntMax(teleopEndGameTotals[i], teamMetrics.teleopEndGameTotals[i]);
      teleopEndGamePercents[i] = calculateDoubleMax(teleopEndGamePercents[i], teamMetrics.teleopEndGamePercents[i]);
    }

    for (int i = 0; i < summaryRolesTotals.length; i++) {
      summaryRolesTotals[i] = calculateIntMax(summaryRolesTotals[i], teamMetrics.summaryRolesTotals[i]);
      summaryRolesPercent[i] = calculateDoubleMax(summaryRolesPercent[i], teamMetrics.summaryRolesPercent[i]);
    }

    for (int i = 0; i < summaryOperationalIssuesTotals.length; i++) {
      summaryOperationalIssuesTotals[i] = 
        calculateIntMax(summaryOperationalIssuesTotals[i], teamMetrics.summaryOperationalIssuesTotals[i]);
      summaryOperationalIssuesPercents[i] = 
        calculateDoubleMax(summaryOperationalIssuesPercents[i], teamMetrics.summaryOperationalIssuesPercents[i]);
    }

    for (int i = 0; i < summaryMechanicalIssuesTotals.length; i++) {
      summaryMechanicalIssuesTotals[i] = 
        calculateIntMax(summaryMechanicalIssuesTotals[i], teamMetrics.summaryMechanicalIssuesTotals[i]);
      summaryMechanicalIssuesPercents[i] = 
        calculateDoubleMax(summaryMechanicalIssuesPercents[i], teamMetrics.summaryMechanicalIssuesPercents[i]);
    }
  }
}
