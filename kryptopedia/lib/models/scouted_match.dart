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
  int autoFuelFinal = 0;

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

  int _penalties = 0; //enum index
  Penalties get penalties => Penalties.values[_penalties];
  set penalties(Penalties value) {
    _penalties = value.index;
  }

  String generalComments = "";

  Uuid uuid = Uuid();

  void setToDefaults(EventMatch match, int teamNumber, TeamMember scouter) {
    matchCompLevel = match.compLevel;
    matchNumber = match.number;
    this.teamNumber = teamNumber;

    scouterId = scouter.id;
    uid = uuid.v1();

    local = true;

    autoFuelScored = 0;
    autoFuelFinal = 0;
    autoClimbed = false;

    teleopFuelScored = 0;
    teleopFuelFed = 0;

    climbLevel = ClimbLevel.none;

    generalComments = "";
  }

  static final tableName = "scouted_matches";
  static final matchCompLevelKey = "match_comp_level";
  static final matchNumberKey = "match_number";
  static final uidKey = "uid";
  static final scouterIdKey = "scouter_id";
  static final teamNumberKey = "team_number";
  static final localKey = "local";
  static final autoFuelScoredKey = "auto_fuel_scored";
  static final autoFuelFinalKey = "auto_fuel_final";
  static final autoClimbedKey = "auto_climbed";
  static final teleopFuelScoredKey = "teleop_fuel_scored";
  static final teleopFuelFedKey = "teleop_fuel_fed";
  static final climbLevelKey = "climb_level";
  static final defenseCommentsKey = "defense_comments";
  static final generalCommentsKey = "general_comments";

  ScoutedMatch();

  Map<String, dynamic> toMap() {
    return {
      matchCompLevelKey: matchCompLevel,
      matchNumberKey: matchNumber,
      teamNumberKey: teamNumber,
      uidKey: uid,
      scouterIdKey: scouterId,
      localKey: _local,
      autoFuelScoredKey: autoFuelScored,
      autoFuelFinalKey: autoFuelFinal,
      autoClimbedKey: autoClimbed,
      teleopFuelScoredKey: teleopFuelScored,
      teleopFuelFedKey: teleopFuelFed,
      climbLevelKey: climbLevel,
      generalCommentsKey: generalComments,
    };
  }

  ScoutedMatch.fromMap(Map<String, dynamic> map)
    : matchCompLevel = map[matchCompLevelKey],
      matchNumber = map[matchNumberKey],
      teamNumber = map[teamNumberKey],
      uid = map[uidKey],
      scouterId = map[scouterIdKey],
      _local = map[localKey],
      autoFuelScored = map[autoFuelScoredKey],
      autoFuelFinal = map[autoFuelFinalKey],
      _autoClimbed = map[autoClimbedKey],
      teleopFuelScored = map[teleopFuelScoredKey],
      teleopFuelFed = map[teleopFuelFedKey],
      _climbLevel = map[climbLevelKey],
      generalComments = map[generalCommentsKey];

  SyncDataItem toSyncDataItem() {
    Map<String, dynamic> map = toMap();
    map.remove(localKey);

    return SyncDataItem(type: "scouted_match", data: map);
  }
}

enum ClimbLevel { none, L1, L2, L3 }

enum Penalties { none, one, few, many }
