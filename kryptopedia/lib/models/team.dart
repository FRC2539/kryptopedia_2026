class Team {
  final int _number;
  final String _nickname;

  static const String tableName = "teams";
  static const String numberKey = "number";
  static const String nicknameKey = "nickname";

  Team(this._number, this._nickname);

  int get number => _number;
  String get nickname => _nickname;

  Map<String, dynamic> toMap() {
    return {numberKey: _number, nicknameKey: _nickname};
  }

  Team.fromMap(Map<String, dynamic> map)
    : _number = map[numberKey],
      _nickname = map[nicknameKey];
}
