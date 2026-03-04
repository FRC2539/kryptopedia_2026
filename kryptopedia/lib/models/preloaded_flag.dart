class PreloadedFlag {
  String name;

  static const String tableName = "preloaded_flags";
  static const String nameKey = "name";

  PreloadedFlag(this.name);

  Map<String, dynamic> toMap() {
    return {nameKey: name};
  }

  PreloadedFlag.fromMap(Map<String, dynamic> map) : name = map[nameKey];
}
