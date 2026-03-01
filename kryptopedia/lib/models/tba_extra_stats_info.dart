class TBAExtraStatsInfo {
  TBAExtraStatsInfo({required this.precision, required this.name});

  final int precision;
  final String name;

  factory TBAExtraStatsInfo.fromJson(Map<String, dynamic> data) {
    final precision = data["precision"] as int;
    final name = data["name"] as String;
    return TBAExtraStatsInfo(precision: precision, name: name);
  }
}
