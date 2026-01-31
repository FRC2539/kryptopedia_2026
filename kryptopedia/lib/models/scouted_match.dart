class ScoutedMatch {
  int teamNumber = 0;

  int _local = 0;
  bool get local => _local == 1;
  set local(bool value) {
    _local = value ? 1 : 0;
  }

  int autoFuelScored = 0;
  int autoFuelFinal = 0;

  int _autoClimbed = 0;
  bool get autoClimbed => _autoClimbed == 1;
  set autoClimbed(bool value) {
    _autoClimbed = value ? 1 : 0;
  }

  String autoComments = "";

  String generalComments = "";

  void setToDefaults(int team) {
    teamNumber = team;
    local = true;

    autoFuelScored = 0;
    autoFuelFinal = 0;
    autoClimbed = false;

    autoComments = "";
    generalComments = "";
  }

  static final tableName = "scouted_pits";
  static final teamNumberKey = "team_number";
  static final localKey = "local";
  static final autoFuelScoredKey = "auto_fuel_scored";
  static final autoFuelFinalKey = "auto_fuel_final";
  static final autoClimbedKey = "auto_climbed";
  static final autoCommentsKey = "auto_comments";
  static final generalCommentsKey = "general_comments";

  ScoutedMatch();

  Map<String, dynamic> toMap() {
    return {
      teamNumberKey: teamNumber,
      localKey: _local,
      autoFuelScoredKey: autoFuelScored,
      autoFuelFinalKey: autoFuelFinal,
      autoClimbedKey: autoClimbed,
      autoCommentsKey: autoComments,
      generalCommentsKey: generalComments,
    };
  }

  ScoutedMatch.fromMap(Map<String, dynamic> map)
    : teamNumber = map[teamNumberKey],
      _local = map[localKey],
      autoFuelScored = map[autoFuelScoredKey],
      autoFuelFinal = map[autoFuelFinalKey],
      _autoClimbed = map[autoClimbedKey],
      autoComments = map[autoCommentsKey],
      generalComments = map[generalCommentsKey];
}
