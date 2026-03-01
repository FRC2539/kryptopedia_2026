class TBAEventInsights {
  TBAEventInsights({
    required this.oprs,
    required this.dprs,
    required this.ccwms,
  });

  final Map<String, dynamic> oprs;
  final Map<String, dynamic> dprs;
  final Map<String, dynamic> ccwms;

  factory TBAEventInsights.fromJson(Map<String, dynamic> data) {
    final oprs = data["oprs"] as Map<String, dynamic>;
    final dprs = data["dprs"] as Map<String, dynamic>;
    final ccwms = data["ccwms"] as Map<String, dynamic>;

    return TBAEventInsights(oprs: oprs, dprs: dprs, ccwms: ccwms);
  }
}
