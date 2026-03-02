class TBASortOrderInfo {
  TBASortOrderInfo({required this.precision, required this.name});

  final int precision;
  final String name;

  factory TBASortOrderInfo.fromJson(Map<String, dynamic> data) {
    final precision = data["precision"] as int;
    final name = data["name"] as String;
    return TBASortOrderInfo(precision: precision, name: name);
  }
}
