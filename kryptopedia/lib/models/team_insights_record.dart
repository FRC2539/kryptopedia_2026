class TeamInsightsRecord {
  int teamNumber;
  double? opr;
  double? dpr;
  double? ccwm;
  int? ranking;
  double? epa;

  static const String tableName = "team_insights";
  static const String teamNumberKey = "team_number";
  static const String oprKey = "opr";
  static const String dprKey = "dpr";
  static const String ccwmKey = "ccwm";
  static const String rankingKey = "ranking";
  static const String epaKey = "epa";

  TeamInsightsRecord(
    this.teamNumber,
    this.opr,
    this.dpr,
    this.ccwm,
    this.ranking,
    this.epa,
  );

  Map<String, dynamic> toMap() {
    return {
      teamNumberKey: teamNumber,
      oprKey: opr,
      dprKey: dpr,
      ccwmKey: ccwm,
      rankingKey: ranking,
      epaKey: epa,
    };
  }

  TeamInsightsRecord.fromMap(Map<String, dynamic> map)
    : teamNumber = map[teamNumberKey],
      opr = map[oprKey],
      dpr = map[dprKey],
      ccwm = map[ccwmKey],
      ranking = map[rankingKey],
      epa = map[epaKey];
}

// now that ive moved this all here: it would be cool if we just stored this as part of the team model
