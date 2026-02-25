import 'package:flutter/material.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/widgets/team_info/team_chooser.dart';
import 'package:kryptopedia/util/db/teams.dart';

class TeamInfo extends StatelessWidget {
  const TeamInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Kryptopedia - Team Info",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
        leading: Container(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TeamInfoChooser(
                  teamList: DbTeams.getTeams(),
                  teamChangedNotifier: teamChangedNotifier,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
