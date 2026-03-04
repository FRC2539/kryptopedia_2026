import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
//import 'package:kryptopedia/util/db/eventalliances.dart';

import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/match_preview/adhoc_select.dart';
//import 'package:kryptopedia/widgets/match_preview/alliances_select.dart';
import 'package:kryptopedia/widgets/match_preview/match_select.dart';

class MatchPreview extends StatefulWidget {
  const MatchPreview({super.key});

  @override
  State<MatchPreview> createState() => _MatchPreviewState();
}

class _MatchPreviewState extends State<MatchPreview> {
  int red1 = 2539;
  int red2 = 2539;
  int red3 = 2539;
  int blue1 = 2539;
  int blue2 = 2539;
  int blue3 = 2539;

  TeamSelectType teamSelectType = TeamSelectType.match;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Kryptopedia - Match Preview",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              setState(() {
                teamSelectType = TeamSelectType.match;
              });
            },
            tooltip: "Matches",
            color: teamSelectType == TeamSelectType.match
                ? Colors.white
                : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.build),
            onPressed: () {
              setState(() {
                teamSelectType = TeamSelectType.adhoc;
              });
            },
            tooltip: "Ad hoc",
            color: teamSelectType == TeamSelectType.adhoc
                ? Colors.white
                : Colors.grey,
          ),
          /*FutureBuilder(
            future: () async {
              DbEventAlliances dbEventAlliances = DbEventAlliances();
              return (await dbEventAlliances.getEventAlliances()).isNotEmpty;
            }(),
            builder: (context, snapshot) {
              bool hasAlliances = snapshot.hasData && snapshot.data == true;
              return IconButton(
                icon: const Icon(Icons.groups_3),
                onPressed: hasAlliances
                    ? () {
                        setState(() {
                          teamSelectType = TeamSelectType.playoffs;
                        });
                      }
                    : null,
                tooltip: "Playoffs Alliances",
                color: teamSelectType == TeamSelectType.playoffs
                    ? Colors.white
                    : Colors.grey,
              );
            },
          ),*/
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: teamSelectType == TeamSelectType.match,
            child: MatchSelect(
              callback: (match) {
                setState(() {
                  red1 = match.red1number;
                  red2 = match.red2number;
                  red3 = match.red3number;
                  blue1 = match.blue1number;
                  blue2 = match.blue2number;
                  blue3 = match.blue3number;
                });
              },
            ),
          ),
          Visibility(
            visible: teamSelectType == TeamSelectType.adhoc,
            child: AdhocSelect(
              selection: AdhocSelection(
                red1: red1,
                red2: red2,
                red3: red3,
                blue1: blue1,
                blue2: blue2,
                blue3: blue3,
              ),
              callback: (selection) {
                setState(() {
                  red1 = selection.red1;
                  red2 = selection.red2;
                  red3 = selection.red3;
                  blue1 = selection.blue1;
                  blue2 = selection.blue2;
                  blue3 = selection.blue3;
                });
              },
            ),
          ),
          /*Visibility(
            visible: teamSelectType == TeamSelectType.playoffs,
            child: AlliancesSelect(
              callback: (alliances) {
                setState(() {
                  red1 = alliances.red.teamId1;
                  red2 = alliances.red.teamId2;
                  red3 = alliances.red.teamId3;
                  blue1 = alliances.blue.teamId1;
                  blue2 = alliances.blue.teamId2;
                  blue3 = alliances.blue.teamId3;
                });
              },
            ),
          ),*/
          /*MatchPredictionViewer(
            red1: red1,
            red2: red2,
            red3: red3,
            blue1: blue1,
            blue2: blue2,
            blue3: blue3,
            adhoc: (teamSelectType == TeamSelectType.adhoc),
          ),*/
        ],
      ),
    );
  }
}

enum TeamSelectType { match, adhoc, playoffs }
