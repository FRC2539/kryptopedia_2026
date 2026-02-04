class Event {
  int id;
  String code;
  String name;
  int year;
  String? serverURL;
  String? authToken;
  int teamNumber;

  int _lastSync;
  DateTime get lastSync => DateTime.fromMillisecondsSinceEpoch(_lastSync);
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

  Event(
    this.id,
    this.name,
    this.code,
    this.year,
    this.serverURL,
    this.authToken,
    this.teamNumber,
    this._lastSync,
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
      _lastSync = map[lastSyncKey];
}
