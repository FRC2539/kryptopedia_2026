import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/widgets/team_info/comments.dart';
import 'package:kryptopedia/widgets/team_info/team_chooser.dart';
import 'package:kryptopedia/util/db/teams.dart';

class TeamInfo extends StatefulWidget {
  const TeamInfo({super.key});

  @override
  State<TeamInfo> createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  dynamic _futureTeams;
  List<Team> _teams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final teams = await DbTeams().getTeams();
      setState(() {
        _teams = teams;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error, e.g., show a snackbar or log the error
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<ScoutedMatch> scoutedMatches = [];
  ScoutedPit? scoutedPit = ScoutedPit();

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> teamChangeNotifier = ValueNotifier(0);
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Kryptopedia - Team Info",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TeamInfoChooser(
                  teamList: _teams,
                  teamChangedNotifier: teamChangeNotifier,
                ),
                TeamInfoComments(
                  scoutedMatches: scoutedMatches,
                  scoutedPit: scoutedPit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
