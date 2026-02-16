import 'package:kryptopedia/util/api.dart';

// "application" as in an instance of this flag being applied to a team
class TeamFlagApplication {
  final String name;
  final int teamNumber;

  final int _local;
  bool get local => _local == 1;

  final int _deleted;
  bool get deleted => _deleted == 1;

  // local- needs to be synced
  // deleted- sync needs to delete this
  // deleted should only ever be true with local being true!

  TeamFlagApplication(this.name, this.teamNumber, bool local, bool deleted)
    : _local = local ? 1 : 0,
      _deleted = deleted ? 1 : 0;

  static const String tableName = "team_flag_applications";
  static const String nameKey = "name";
  static const String teamNumberKey = "team_number";
  static const String localKey = "local";
  static const String deletedKey = "deleted";

  Map<String, dynamic> toMap() {
    return {
      nameKey: name,
      teamNumberKey: teamNumber,
      localKey: _local,
      deletedKey: _deleted,
    };
  }

  TeamFlagApplication.fromMap(Map<String, dynamic> map)
    : name = map[nameKey],
      teamNumber = map[teamNumberKey],
      _local = map[localKey],
      _deleted = map[deletedKey];

  SyncDataItem toSyncDataItem() {
    Map<String, dynamic> map = toMap();
    map.remove(localKey);
    map.remove(deletedKey);
    map["uid"] = "$name-$teamNumber";

    return SyncDataItem(
      type: "team_flag_application",
      data: map,
      deleted: deleted,
    );
  }
}
