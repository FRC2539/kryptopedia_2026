class ScoutedPit {
  int teamNumber = 0;

  int _local = 0;
  bool get local => _local == 1;
  set local(bool value) {
    _local = value ? 1 : 0;
  }

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

  String autoComments = "";

  String generalComments = "";

  void setToDefaults(int team) {
    teamNumber = team;
    local = true;

    isKitBot = false;
    weight = 110;
    width = 27;
    depth = 27;
    startingHeight = 20;
    extendedHeight = 28;
    drivetrain = Drivetrain.swerve;

    fuelPickupMethods = [];
    hasTurret = false;
    maxFuelCapacity = 35;
    shooterNumber = 1;

    autoComments = "";
    generalComments = "";
  }

  static final tableName = "scouted_pits";
  static final teamNumberKey = "team_number";
  static final localKey = "local";
  static final weightKey = "weight";
  static final widthKey = "width";
  static final depthKey = "depth";
  static final startingHeightKey = "starting_height";
  static final extendedHeightKey = "extended_height";
  static final isKitBotKey = "is_kit_bot";
  static final drivetrainKey = "drivetrain";
  static final fuelPickupMethodsKey = "fuel_pickup_methods";
  static final hasTurretKey = "has_turret";
  static final shooterNumberKey = "shooter_number";
  static final maxFuelCapacityKey = "max_fuel_capacity";
  static final autoCommentsKey = "auto_comments";
  static final generalCommentsKey = "general_comments";

  ScoutedPit();

  Map<String, dynamic> toMap() {
    return {
      teamNumberKey: teamNumber,
      localKey: _local,
      weightKey: weight,
      widthKey: width,
      depthKey: depth,
      startingHeightKey: startingHeight,
      extendedHeightKey: extendedHeight,
      isKitBotKey: _isKitBot,
      drivetrainKey: _drivetrain,
      fuelPickupMethodsKey: _fuelPickupMethods,
      hasTurretKey: _hasTurret,
      maxFuelCapacityKey: maxFuelCapacity,
      shooterNumberKey: shooterNumber,
      autoCommentsKey: autoComments,
      generalCommentsKey: generalComments,
    };
  }

  ScoutedPit.fromMap(Map<String, dynamic> map)
    : teamNumber = map[teamNumberKey],
      _local = map[localKey],
      weight = map[weightKey],
      width = map[widthKey],
      depth = map[depthKey],
      startingHeight = map[startingHeightKey],
      extendedHeight = map[extendedHeightKey],
      _isKitBot = map[isKitBotKey],
      _drivetrain = map[drivetrainKey],
      _fuelPickupMethods = map[fuelPickupMethodsKey],
      _hasTurret = map[hasTurretKey],
      maxFuelCapacity = map[maxFuelCapacityKey],
      shooterNumber = map[shooterNumberKey],
      autoComments = map[autoCommentsKey],
      generalComments = map[generalCommentsKey];
}

enum FuelPickupMethod { ground, top }

enum Drivetrain { swerve, tank, mecanum, other }
