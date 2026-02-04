class Team {
  final int number;
  final String nickname;

  static const String tableName = "teams";
  static const String numberKey = "number";
  static const String nicknameKey = "nickname";

  Team(this.number, this.nickname);

  Map<String, dynamic> toMap() {
    return {numberKey: number, nicknameKey: nickname};
  }

  Team.fromMap(Map<String, dynamic> map)
    : number = map[numberKey],
      nickname = map[nicknameKey];
}
