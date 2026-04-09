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

  String? _defaultAlliancePosition = "Red 1";
  String? get defaultAlliancePosition => _defaultAlliancePosition;
  set defaultAlliancePosition(AlliancePosition? value) {
    _defaultAlliancePosition = alliancePositionNames[value];
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

  static const tableName = "events";
  static const idKey = "id";
  static const codeKey = "code";
  static const nameKey = "name";
  static const yearKey = "year";
  static const serverURLKey = "server_URL";
  static const authTokenKey = "auth_token";
  static const teamNumberKey = "team_number";
  static const lastSyncKey = "last_sync";
  static const lastScouterKey = "last_scouter";
  static const defaultAlliancePositionKey = "default_alliance_position";
  static const pitMapDataJSONKey = "pit_map_data_json";

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
