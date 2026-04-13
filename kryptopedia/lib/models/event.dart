import 'dart:convert';

class Event {
  int id = 0;
  String code;
  String name;
  int year;
  String? serverURL;
  String? authToken;
  int teamNumber;
  String? lastScouter;

  int? _defaultAlliancePosition; //enum index
  AlliancePosition? get defaultAlliancePosition =>
      _defaultAlliancePosition == null
      ? null
      : AlliancePosition.values[_defaultAlliancePosition!];
  set defaultAlliancePosition(AlliancePosition? value) {
    _defaultAlliancePosition = value?.index;
  }

  int? _defaultFieldSide; //enum index
  FieldSide? get defaultFieldSide =>
      _defaultFieldSide == null ? null : FieldSide.values[_defaultFieldSide!];
  set defaultFieldSide(FieldSide? value) {
    _defaultFieldSide = value?.index;
  }

  String? _pitMapDataJSON;
  Map<String, dynamic>? get pitMapDataJSON =>
      _pitMapDataJSON == null ? null : jsonDecode(_pitMapDataJSON!);

  int _lastSync;
  DateTime? get lastSync =>
      _lastSync == 0 ? null : DateTime.fromMillisecondsSinceEpoch(_lastSync);
  set lastSync(DateTime value) {
    _lastSync = value.millisecondsSinceEpoch;
  }

  static const String tableName = "events";
  static const String idKey = "id";
  static const String codeKey = "code";
  static const String nameKey = "name";
  static const String yearKey = "year";
  static const String serverURLKey = "server_URL";
  static const String authTokenKey = "auth_token";
  static const String teamNumberKey = "team_number";
  static const String lastSyncKey = "last_sync";
  static const String lastScouterKey = "last_scouter";
  static const String defaultAlliancePositionKey = "default_alliance_position";
  static const String defaultFieldSideKey = "default_field_side";
  static const String pitMapDataJSONKey = "pit_map_data_json";

  Event(
    this.name,
    this.code,
    this.year,
    this.serverURL,
    this.authToken,
    this.teamNumber,
    this._lastSync,
    this.lastScouter,
  );

  bool get syncEnabled => (serverURL != null && authToken != null);

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      codeKey: code,
      nameKey: name,
      yearKey: year,
      serverURLKey: serverURL,
      authTokenKey: authToken,
      teamNumberKey: teamNumber,
      lastSyncKey: _lastSync,
      lastScouterKey: lastScouter,
      defaultAlliancePositionKey: _defaultAlliancePosition,
      defaultFieldSideKey: _defaultFieldSide,
      pitMapDataJSONKey: _pitMapDataJSON,
    };
  }

  Event.fromMap(Map<String, dynamic> map)
    : id = map[idKey],
      code = map[codeKey],
      name = map[nameKey],
      year = map[yearKey],
      serverURL = map[serverURLKey],
      authToken = map[authTokenKey],
      teamNumber = map[teamNumberKey],
      _lastSync = map[lastSyncKey],
      lastScouter = map[lastScouterKey],
      _defaultAlliancePosition = map[defaultAlliancePositionKey],
      _defaultFieldSide = map[defaultFieldSideKey],
      _pitMapDataJSON = map[pitMapDataJSONKey];
}

enum AlliancePosition { red1, red2, red3, blue1, blue2, blue3 }

final List<AlliancePosition> redAlliancePositions = [
  AlliancePosition.red1,
  AlliancePosition.red2,
  AlliancePosition.red3,
];

final List<AlliancePosition> blueAlliancePositions = [
  AlliancePosition.blue1,
  AlliancePosition.blue2,
  AlliancePosition.blue3,
];

Map<AlliancePosition, String> alliancePositionNames = {
  AlliancePosition.red1: "Red 1",
  AlliancePosition.red2: "Red 2",
  AlliancePosition.red3: "Red 3",
  AlliancePosition.blue1: "Blue 1",
  AlliancePosition.blue2: "Blue 2",
  AlliancePosition.blue3: "Blue 3",
};


enum FieldSide { scoringTableSide, oppositeScoringTableSide }
