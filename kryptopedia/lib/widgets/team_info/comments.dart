import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/db/matches.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/widgets/common/info_not_available.dart';
import 'package:kryptopedia/widgets/common/label.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';

class TeamInfoComments extends StatefulWidget {
  final List<ScoutedMatch> scoutedMatches;
  final ScoutedPit? scoutedPit;

  const TeamInfoComments({
    super.key,
    required this.scoutedMatches,
    required this.scoutedPit,
  });

  @override
  State<TeamInfoComments> createState() => _TeamInfoCommentsState();
}

class _TeamInfoCommentsState extends State<TeamInfoComments> {
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Match and Pit Scouting Comments',
      children: [
        FutureBuilder<List<ScoutingComment>>(
          future: getScoutingComments(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<ScoutingComment> data = snapshot.data!;
              return Column(
                children: data
                    .map(
                      (i) => Column(
                        children: [
                          TextLabel(label: i.title, headerLabel: true),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    i.comment,
                                    style: TextStyle(
                                      fontSize: Device.fontLabel(context),
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '- ${i.scouterName}',
                                    style: TextStyle(
                                      fontSize: Device.fontLabel(context) * 0.9,
                                      color: Colors.white54,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              );
            } else {
              return InformationNotAvailable(
                infoDescription: 'Scouting comments',
              );
            }
          },
        ),
      ],
    );
  }

  Future<List<ScoutingComment>> getScoutingComments() async {
    // Generate our list of scouting comments

    List<ScoutingComment> scoutedComments = [];

    if (widget.scoutedPit != null &&
        widget.scoutedPit!.generalComments.isNotEmpty) {
      TeamMember scouter = await DbTeamMembers().getTeamMemberById(
        widget.scoutedPit!.scouterId,
      );

      scoutedComments.add(
        ScoutingComment(
          title: 'Pit Scouting',
          scouterName: scouter.name,
          comment: widget.scoutedPit!.generalComments,
        ),
      );
    }

    DbMatches dbMatch = DbMatches();
    List<EventMatch> eventMatch = await dbMatch.getMatches();

    for (int i = 0; i < widget.scoutedMatches.length; i++) {
      EventMatch match = eventMatch.firstWhere(
        (m) =>
            m.number == widget.scoutedMatches[i].matchNumber &&
            m.compLevel == widget.scoutedMatches[i].matchCompLevel,
      );
      TeamMember scouter = await DbTeamMembers().getTeamMemberById(
        widget.scoutedMatches[i].scouterId,
      );

      if (widget.scoutedMatches[i].generalComments.isNotEmpty) {
        scoutedComments.add(
          ScoutingComment(
            title: match.name,
            scouterName: scouter.name,
            comment: widget.scoutedMatches[i].generalComments,
          ),
        );
      }
    }

    return scoutedComments;
  }
}

class ScoutingComment {
  final String title;
  final String scouterName;
  final String comment;

  ScoutingComment({
    required this.title,
    required this.scouterName,
    required this.comment,
  });
}
