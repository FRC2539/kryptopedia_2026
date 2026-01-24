// import 'package:kryptopedia/util/dbhelpers/dbconstants.dart';

class ScoutedPit {
  int eventId = 0;
  int teamId = 0;
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
  bool isKitBot = false;
  int _drivetrain = 0; //enum index
  Drivetrain get drivetrain => Drivetrain.values[_drivetrain];
  set drivetrain(Drivetrain value) {
    _drivetrain = value.index;
  }

  bool hasGroundIntake = false;
  bool hasTopIntake = false;

  String autoComments = "";
  List<int> buddyAssists = []; //enum index list

  String imagePath = "";
  String generalComments = "";

  // Class Constructor
  ScoutedPit();

  void setToDefaults(int event, int team) {
    eventId = event;
    teamId = team;
    local = true;

    weight = 110;
    width = 27;
    depth = 27;
    startingHeight = 20;
    extendedHeight = 28;
    drivetrain = Drivetrain.swerve;

    hasGroundIntake = false;
    hasTopIntake = false;

    autoComments = "";
    buddyAssists = [];
    imagePath = "";
    generalComments = "";
  }

  /*
  void fromMap(Map<String, dynamic> map) {
    eventId = map[DB.colScoutedPitEventId];
    teamId = map[DB.colScoutedPitTeamId];
    _local =
        (map[DB.colScoutedPitLocal] == null) ? 0 : map[DB.colScoutedPitLocal];

    weight = map[DB.colScoutedPitWeight];
    width = map[DB.colScoutedPitWidth];
    depth = map[DB.colScoutedPitDepth];
    startingHeight = map[DB.colScoutedPitStartingHeight];
    extendedHeight = map[DB.colScoutedPitExtendedHeight];
    _drivetrain = map[DB.colScoutedPitDrivetrain];

    autoComments = map[DB.colScoutedPitAutoComments];
    _buddyAssists = map[DB.colScoutedPitBuddyAssists];

    imagePath = map[DB.colScoutedPitImagePath];
    generalComments = map[DB.colScoutedPitGeneralComments];
  }
  */

  /*
  Map<String, dynamic> toMap() {
    return {
      DB.colScoutedPitEventId: eventId,
      DB.colScoutedPitTeamId: teamId,
      DB.colScoutedPitLocal: _local,
      DB.colScoutedPitWeight: weight,
      DB.colScoutedPitWidth: width,
      DB.colScoutedPitDepth: depth,
      DB.colScoutedPitStartingHeight: startingHeight,
      DB.colScoutedPitExtendedHeight: extendedHeight,
      DB.colScoutedPitDrivetrain: _drivetrain,
      DB.colScoutedPitScoreReefLevels: _scoreReefLevels,
      DB.colScoutedPitScoreProcessor: _scoreProcessor,
      DB.colScoutedPitScoreNet: _scoreNet,
      DB.colScoutedPitScoreShallowCage: _scoreShallowCage,
      DB.colScoutedPitScoreDeepCage: _scoreDeepCage,
      DB.colScoutedPitCoralPickupMethods: _coralPickupMethods,
      DB.colScoutedPitAlgaePickupMethods: _algaePickupMethods,
      DB.colScoutedPitPreferredStartPosition: _preferredStartPosition,
      DB.colScoutedPitAutoLeave: _autoLeave,
      DB.colScoutedPitAutoMaxCoral: autoMaxCoral,
      DB.colScoutedPitAutoMaxAlgaeMoved: autoMaxAlgaeMoved,
      DB.colScoutedPitAutoComments: autoComments,
      DB.colScoutedPitBuddyAssists: _buddyAssists,
      DB.colScoutedPitImagePath: imagePath,
      DB.colScoutedPitGeneralComments: generalComments,
    };
  }
  */

  /*
  Map<String, dynamic> toJson() {
    return toMap();
  }
  */
}

enum Drivetrain { swerve, tank, mecanum, other }
