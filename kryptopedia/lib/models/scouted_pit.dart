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

  int _shooterType = 0; //enum index
  ShooterType get shooterType => ShooterType.values[_shooterType];
  set shooterType(ShooterType value) {
    _shooterType = value.index;
  }

  int maxFuelCapacity = 0;
  String autoComments = "";

  String imagePath = "";
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
    shooterType = ShooterType.noTurret;
    maxFuelCapacity = 35;

    autoComments = "";
    imagePath = "";
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
  static final shooterTypeKey = "shooter_type";
  static final maxFuelCapacityKey = "max_fuel_capacity";
  static final autoCommentsKey = "auto_comments";
  static final imagePathKey = "image_path";
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
      shooterTypeKey: _shooterType,
      maxFuelCapacityKey: maxFuelCapacity,
      autoCommentsKey: autoComments,
      imagePathKey: imagePath,
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
      _shooterType = map[shooterTypeKey],
      maxFuelCapacity = map[maxFuelCapacityKey],
      autoComments = map[autoCommentsKey],
      imagePath = map[imagePathKey],
      generalComments = map[generalCommentsKey];
}

enum FuelPickupMethod { ground, top }

enum ShooterType { noTurret, singleTurret, doubleTurret }

enum Drivetrain { swerve, tank, mecanum, other }
