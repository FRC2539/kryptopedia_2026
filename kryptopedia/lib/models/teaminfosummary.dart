class TeamInfoSummary {
  int numberOfMatches = 0;

  // Properties
  int autoFuelScoreTotal = 0;
  double autoFuelScoreAverage = 0.0;
  int autoFuelScoreMin = 100;
  int autoFuelScoreMax = 0;
  int teleopFuelScoreTotal = 0;
  double teleopFuelScoreAverage = 0.0;
  int teleopFuelScoreMin = 100;
  int teleopFuelScoreMax = 0;
  int teleopFuelFedTotal = 0;
  double teleopFuelFedAverage = 0.0;
  int teleopFuelFedMin = 100;
  int teleopFuelFedMax = 0;

  int autoClimbedTotal = 0;
  double autoClimbedPercent = 0.0;
  List<int> teleopClimbedTotals = [0, 0, 0, 0];
  List<double> teleopClimbedPercents = [0.0, 0.0, 0.0, 0.0];

  int summaryIssuesTotal = 0;
  double summaryIssuesPercent = 0.0;
  
  TeamInfoSummary() {
    // Do nothing
  }
}
