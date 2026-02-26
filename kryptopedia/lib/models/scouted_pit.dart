import 'dart:io';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ScoutedPit {
  String uid = "";
  String scouterId = "";

  int _local = 0;
  bool get local => _local == 1;
  set local(bool value) {
    _local = value ? 1 : 0;
  }

  int teamNumber = 0;

  int weight = 0;
  int width = 0;
  int depth = 0;
  int startingHeight = 0;
  int extendedHeight = 0;

  int _isKitBot = 0;
  bool get isKitBot => _isKitBot == 1;
  set isKitBot(bool value) {
    _isKitBot = value ? 1 : 0;
  }

  int _drivetrain = 0; //enum index
  Drivetrain get drivetrain => Drivetrain.values[_drivetrain];
  set drivetrain(Drivetrain value) {
    _drivetrain = value.index;
  }

  int _wheelType = 0;
  WheelType get wheelType => WheelType.values[_wheelType];
  set wheelType(WheelType value) {
    _wheelType = value.index;
  }

  int _fuelPickupMethods = 0; //1 << enum index
  List<FuelPickupMethod> get fuelPickupMethods => [
    if (_fuelPickupMethods & 1 != 0) FuelPickupMethod.ground,
    if (_fuelPickupMethods & 2 != 0) FuelPickupMethod.top,
  ];
  set fuelPickupMethods(List<FuelPickupMethod> value) {
    _fuelPickupMethods = 0;
    for (var element in value) {
      _fuelPickupMethods += 1 << element.index;
    }
  }

  int _hasTurret = 0;
  bool get hasTurret => _hasTurret == 1;
  set hasTurret(bool value) {
    _hasTurret = value ? 1 : 0;
  }

  int maxFuelCapacity = 0;
  int shooterNumber = 0;

  String generalComments = "";

  Uuid uuid = Uuid();

  void setToDefaults(int team, TeamMember scouter) {
    uid = uuid.v1();
    scouterId = scouter.id;

    teamNumber = team;
    local = true;

    isKitBot = false;
    weight = 110;
    width = 27;
    depth = 27;
    startingHeight = 20;
    extendedHeight = 28;
    drivetrain = Drivetrain.swerve;
    wheelType = WheelType.colson;

    fuelPickupMethods = [];
    hasTurret = false;
    maxFuelCapacity = 35;
    shooterNumber = 1;

    generalComments = "";
  }

  static const tableName = "scouted_pits";
  static const uidKey = "uid";
  static const scouterIdKey = "scouter_id";
  static const localKey = "local";
  static const teamNumberKey = "team_number";
  static const weightKey = "weight";
  static const widthKey = "width";
  static const depthKey = "depth";
  static const startingHeightKey = "starting_height";
  static const extendedHeightKey = "extended_height";
  static const isKitBotKey = "is_kit_bot";
  static const drivetrainKey = "drivetrain";
  static const fuelPickupMethodsKey = "fuel_pickup_methods";
  static const hasTurretKey = "has_turret";
  static const shooterNumberKey = "shooter_number";
  static const maxFuelCapacityKey = "max_fuel_capacity";
  static const wheelTypeKey = "wheel_type";
  static const generalCommentsKey = "general_comments";

  ScoutedPit();

  Map<String, dynamic> toMap() {
    return {
      uidKey: uid,
      scouterIdKey: scouterId,
      localKey: _local,
      teamNumberKey: teamNumber,
      weightKey: weight,
      widthKey: width,
      depthKey: depth,
      startingHeightKey: startingHeight,
      extendedHeightKey: extendedHeight,
      isKitBotKey: _isKitBot,
      drivetrainKey: _drivetrain,
      wheelTypeKey: _wheelType,
      fuelPickupMethodsKey: _fuelPickupMethods,
      hasTurretKey: _hasTurret,
      maxFuelCapacityKey: maxFuelCapacity,
      shooterNumberKey: shooterNumber,
      generalCommentsKey: generalComments,
    };
  }

  ScoutedPit.fromMap(Map<String, dynamic> map)
    : uid = map[uidKey],
      scouterId = map[scouterIdKey],
      _local = map[localKey] == 1 ? 1 : 0,
      teamNumber = map[teamNumberKey],
      weight = map[weightKey],
      width = map[widthKey],
      depth = map[depthKey],
      startingHeight = map[startingHeightKey],
      extendedHeight = map[extendedHeightKey],
      _isKitBot = map[isKitBotKey],
      _drivetrain = map[drivetrainKey],
      _wheelType = map[wheelTypeKey],
      _hasTurret = map[hasTurretKey],
      maxFuelCapacity = map[maxFuelCapacityKey],
      shooterNumber = map[shooterNumberKey],
      generalComments = map[generalCommentsKey];

  SyncDataItem toSyncDataItem() {
    Map<String, dynamic> map = toMap();
    map.remove(localKey);

    return SyncDataItem(type: "scouted_pit", data: map);
  }

  Future<String> get photoPath async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    Directory robotPicsDir = await Directory(
      "${appDir.path}/Robot_Pics",
    ).create();

    return join(robotPicsDir.path, "pitscout_${uid}.jpg");
  }
}

enum FuelPickupMethod { ground, top }

enum Drivetrain { swerve, tank, mecanum, other }

enum WheelType { colson, billet, spike, other }
