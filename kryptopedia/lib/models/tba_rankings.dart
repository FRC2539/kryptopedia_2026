import 'package:kryptopedia/models/tba_wlt_record.dart';

class TBARankings {
  TBARankings({
    required this.matchesPlayed,
    this.qualAverage,
    this.extraStats,
    this.sortOrders,
    required this.record,
    required this.rank,
    required this.dq,
    required this.teamKey,
  });

  final int matchesPlayed;
  final int? qualAverage;
  final List<int>? extraStats;
  final List<int>? sortOrders;
  final TBAWLTRecord record;
  final int rank;
  final int dq;
  final String teamKey;

  factory TBARankings.fromJson(Map<String, dynamic> data) {
    final matchesPlayed = data["matches_played"] as int;
    final qualAverage = data["qual_average"] as int?;
    final extraStatsData = data["extra_stats"] as List<dynamic>;
    final extraStats = extraStatsData.map((e) => e.round() as int).toList();
    final sortOrdersData = data["sort_orders"] as List<dynamic>;
    final sortOrders = sortOrdersData.map((e) => e.round() as int).toList();
    final record = TBAWLTRecord.fromJson(data["record"]);
    final rank = data["rank"] as int;
    final dq = data["dq"] as int;
    final teamKey = data["team_key"] as String;

    return TBARankings(
      matchesPlayed: matchesPlayed,
      qualAverage: qualAverage,
      extraStats: extraStats,
      sortOrders: sortOrders,
      record: record,
      rank: rank,
      dq: dq,
      teamKey: teamKey,
    );
  }
}
