import 'package:kryptopedia/models/team.dart';

class AllianceSelectionEventTeam {
  Team team;
  int rank;
  bool doNotPick;
  bool picked;

  AllianceSelectionEventTeam(
    this.team,
    this.rank,
    this.doNotPick,
    this.picked,
  );
}
