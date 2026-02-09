// 'Match' already exists in dart
class EventMatch {
  int number;
  String compLevel;
  int red1number;
  int red2number;
  int red3number;
  int blue1number;
  int blue2number;
  int blue3number;

  static const String tableName = "matches";
  static const String numberKey = "number";
  static const String compLevelKey = "comp_level";
  static const String red1numberKey = "red1number";
  static const String red2numberKey = "red2number";
  static const String red3numberKey = "red3number";
  static const String blue1numberKey = "blue1number";
  static const String blue2numberKey = "blue2number";
  static const String blue3numberKey = "blue3number";

  EventMatch(
    this.number,
    this.compLevel,
    this.red1number,
    this.red2number,
    this.red3number,
    this.blue1number,
    this.blue2number,
    this.blue3number,
  );

  Map<String, dynamic> toMap() {
    return {
      numberKey: number,
      compLevelKey: compLevel,
      red1numberKey: red1number,
      red2numberKey: red2number,
      red3numberKey: red3number,
      blue1numberKey: blue1number,
      blue2numberKey: blue2number,
      blue3numberKey: blue3number,
    };
  }

  EventMatch.fromMap(Map<String, dynamic> map)
    : number = map[numberKey],
      compLevel = map[compLevelKey],
      red1number = map[red1numberKey],
      red2number = map[red2numberKey],
      red3number = map[red3numberKey],
      blue1number = map[blue1numberKey],
      blue2number = map[blue2numberKey],
      blue3number = map[blue3numberKey];
}
