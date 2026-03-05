class TeamInfoSummary {
  int numberOfMatches = 0;
  // Properties
  int autoFuelScoreTotal = 0;
  double autoFuelScoreAverage = 0.0;
  int autoFuelScoreMin = 0;
  int autoFuelScoreMax = 0;
  int teleopFuelScoreTotal = 0;
  double teleopFuelScoreAverage = 0.0;
  int teleopFuelScoreMin = 0;
  int teleopFuelScoreMax = 0;
  int teleopFuelFedTotal = 0;
  double teleopFuelFedAverage = 0.0;
  int teleopFuelFedMin = 0;
  int teleopFuelFedMax = 0;

  int autoClimbedTotal = 0;
  double autoClimbedPercent = 0.0;
  List<int> teleopClimbedTotals = [0, 0, 0, 0];
  List<double> teleopClimbedPercents = [0.0, 0.0, 0.0, 0.0];

  TeamInfoSummary() {
    // Do nothing
  }
}
