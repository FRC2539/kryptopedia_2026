import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:uuid/uuid.dart';

class ScoutedMatch {
  String scouterId = "";
  String uid = "";

  String matchCompLevel = "q";
  int matchNumber = 0;
  int teamNumber = 0;

  int _local = 0;
  bool get local => _local == 1;
  set local(bool value) {
    _local = value ? 1 : 0;
  }

  int autoFuelScored = 0;

  int _autoClimbed = 0;
  bool get autoClimbed => _autoClimbed == 1;
  set autoClimbed(bool value) {
    _autoClimbed = value ? 1 : 0;
  }

  int teleopFuelScored = 0;
  int teleopFuelFed = 0;

  int _climbLevel = 0; //enum index
  ClimbLevel get climbLevel => ClimbLevel.values[_climbLevel];
  set climbLevel(ClimbLevel value) {
    _climbLevel = value.index;
  }

  int _robotRoles = 0; // 1 << enum index
  List<RobotRole> get robotRoles => [
    if (_robotRoles & 1 != 0) RobotRole.offense,
    if (_robotRoles & 2 != 0) RobotRole.defense,
    if (_robotRoles & 4 != 0) RobotRole.feeder,
  ];
  set robotRoles(List<RobotRole> value) {
    _robotRoles = 0;
    for (var element in value) {
      _robotRoles += 1 << element.index;
    }
  }

  int _issues = 0;
  bool get issues => _issues == 1;
  set issues(bool value) {
    _issues = value ? 1 : 0;
  }

  int _penalties = 0; //enum index
  Penalties get penalties => Penalties.values[_penalties];
  set penalties(Penalties value) {
    _penalties = value.index;
  }

  String generalComments = "";

  Uuid uuid = Uuid();

  void setToDefaults(EventMatch match, int teamNumber, TeamMember scouter) {
    scouterId = scouter.id;
    uid = uuid.v1();

    matchCompLevel = match.compLevel;
    matchNumber = match.number;
    this.teamNumber = teamNumber;

    local = true;

    autoFuelScored = 0;
    autoClimbed = false;

    teleopFuelScored = 0;
    teleopFuelFed = 0;

    climbLevel = ClimbLevel.none;
    robotRoles = [];
    issues = false;
    penalties = Penalties.none;

    generalComments = "";
  }

  static final scouterIdKey = "scouter_id";
  static final uidKey = "uid";
  static final tableName = "scouted_matches";
  static final matchCompLevelKey = "match_comp_level";
  static final matchNumberKey = "match_number";
  static final teamNumberKey = "team_number";
  static final localKey = "local";
  static final autoFuelScoredKey = "auto_fuel_scored";
  static final autoClimbedKey = "auto_climbed";
  static final teleopFuelScoredKey = "teleop_fuel_scored";
  static final teleopFuelFedKey = "teleop_fuel_fed";
  static final climbLevelKey = "climb_level";
  static final robotRolesKey = "robot_roles";
  static final issuesKey = "issues";
  static final penaltiesKey = "penalties";
  static final generalCommentsKey = "general_comments";

  ScoutedMatch();

  Map<String, dynamic> toMap() {
    return {
      scouterIdKey: scouterId,
      uidKey: uid,
      matchCompLevelKey: matchCompLevel,
      matchNumberKey: matchNumber,
      teamNumberKey: teamNumber,
      localKey: _local,
      autoFuelScoredKey: autoFuelScored,
      autoClimbedKey: _autoClimbed,
      teleopFuelScoredKey: teleopFuelScored,
      teleopFuelFedKey: teleopFuelFed,
      climbLevelKey: _climbLevel,
      robotRolesKey: _robotRoles,
      issuesKey: _issues,
      penaltiesKey: _penalties,
      generalCommentsKey: generalComments,
    };
  }

  ScoutedMatch.fromMap(Map<String, dynamic> map)
    : scouterId = map[scouterIdKey],
      uid = map[uidKey],
      matchCompLevel = map[matchCompLevelKey],
      matchNumber = map[matchNumberKey],
      teamNumber = map[teamNumberKey],
      _local = map[localKey] == 1 ? 1 : 0,
      autoFuelScored = map[autoFuelScoredKey],
      _autoClimbed = map[autoClimbedKey],
      teleopFuelScored = map[teleopFuelScoredKey],
      teleopFuelFed = map[teleopFuelFedKey],
      _climbLevel = map[climbLevelKey],
      _issues = map[issuesKey],
      _penalties = map[penaltiesKey],
      generalComments = map[generalCommentsKey];

  SyncDataItem toSyncDataItem() {
    Map<String, dynamic> map = toMap();
    map.remove(localKey);

    return SyncDataItem(type: "scouted_match", data: map);
  }
}

enum ClimbLevel { none, L1, L2, L3 }

enum Penalties { none, one, few, many }

enum RobotRole { offense, defense, feeder }
