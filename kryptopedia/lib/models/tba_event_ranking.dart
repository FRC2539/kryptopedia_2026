import 'package:kryptopedia/models/tba_rankings.dart';
import 'package:kryptopedia/models/tba_extra_stats_info.dart';
import 'package:kryptopedia/models/tba_sort_order_info.dart';

class TBAEventRanking {
  TBAEventRanking({
    required this.rankings,
    this.extraStatsInfo,
    required this.sortOrderInfo,
  });

  final List<TBARankings> rankings;
  final List<TBAExtraStatsInfo>? extraStatsInfo;
  final List<TBASortOrderInfo> sortOrderInfo;

  factory TBAEventRanking.fromJson(Map<String, dynamic> data) {
    final rankingsData = data["rankings"] as List<dynamic>;
    final rankings = rankingsData.map((e) => TBARankings.fromJson(e)).toList();
    final extraStatsInfoData = data["extra_stats_info"] as List<dynamic>;
    final extraStatsInfo = extraStatsInfoData
        .map((e) => TBAExtraStatsInfo.fromJson(e))
        .toList();
    final sortOrderInfoData = data["sort_order_info"] as List<dynamic>;
    final sortOrderInfo = sortOrderInfoData
        .map((e) => TBASortOrderInfo.fromJson(e))
        .toList();

    return TBAEventRanking(
      rankings: rankings,
      extraStatsInfo: extraStatsInfo,
      sortOrderInfo: sortOrderInfo,
    );
  }
}
