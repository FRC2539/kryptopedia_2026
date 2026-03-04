class EventInsights {
  int teamid;
  double oprs;
  double dprs;
  double ccwms;

  // EventInsights Table Information
  static String tblEventInsightsInfo = "eventinsights_info";
  static String colEventInsightsTeamId = "teamid";
  static String colEventInsightsTeamOprs = "oprs";
  static String colEventInsightsTeamDprs = "dprs";
  static String colEventInsightsTeamCcwms = "ccwms";

  EventInsights(this.teamid, this.oprs, this.dprs, this.ccwms);

  Map<String, dynamic> toMap() {
    return {"teamid": teamid, "oprs": oprs, "dprs": dprs, "ccwms": ccwms};
  }

  EventInsights.fromMap(Map<String, dynamic> map)
    : teamid = map[colEventInsightsTeamId],
      oprs = map[colEventInsightsTeamOprs],
      dprs = map[colEventInsightsTeamDprs],
      ccwms = map[colEventInsightsTeamCcwms];
}
