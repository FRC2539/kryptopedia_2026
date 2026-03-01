class EventRanking {
  int teamid;
  int ranking;

  // EventRanking Table Information
  static String tblEventRankingInfo = "eventranking_info";
  static String colEventRankingTeamId = "teamid";
  static String colEventRankingTeamRank = "ranking";

  EventRanking(this.teamid, this.ranking);

  Map<String, dynamic> toMap() {
    return {"teamid": teamid, "ranking": ranking};
  }

  EventRanking.fromMap(Map<String, dynamic> map)
    : teamid = map[colEventRankingTeamId],
      ranking = map[colEventRankingTeamRank];
}
