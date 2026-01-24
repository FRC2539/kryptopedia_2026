class Event {
  final int _id;
  final String _code;
  final String _name;
  final int _year;

  static final String tableName = "events";
  static final String idKey = "id";
  static final String codeKey = "code";
  static final String nameKey = "name";
  static final String yearKey = "year";

  Event(this._id, this._name, this._code, this._year);

  int get id => _id;
  String get name => _name;
  String get code => _code;
  int get year => _year;

  Map<String, dynamic> toMap() {
    return {idKey: _id, codeKey: _code, nameKey: _name, yearKey: _year};
  }

  Event.fromMap(Map<String, dynamic> map)
    : _id = map[idKey],
      _code = map[codeKey],
      _name = map[nameKey],
      _year = map[yearKey];
}
