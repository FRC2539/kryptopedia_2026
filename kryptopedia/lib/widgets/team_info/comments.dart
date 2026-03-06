import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/util/db/matches.dart';
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
  List<Widget> scoutedComments = [];

  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Match and Pit Scouting Comments',
      children: [
        FutureBuilder<bool>(
          future: formatScoutedComments(context),
          builder: (context, snapshot) {
            if (snapshot.hasData && scoutedComments.isNotEmpty) {
              return Column(children: scoutedComments);
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

  Future<bool> formatScoutedComments(BuildContext context) async {
    // Generate our list of scouting comments
    scoutedComments = [];

    if (context.mounted) {
      if (widget.scoutedPit != null) {
        scoutedComments.add(
          TextLabel(label: 'Pit Scouting Comments', headerLabel: true),
        );
        scoutedComments.add(
          createCommentBlock(context, widget.scoutedPit!.generalComments),
        );

        for (int i = 0; i < widget.scoutedMatches.length; i++) {
          DbMatches dbMatch = DbMatches();
          List<EventMatch> eventMatch = await dbMatch.getMatches();
          EventMatch match = eventMatch[i];

          if (context.mounted &&
              widget.scoutedMatches[i].generalComments.isNotEmpty) {
            scoutedComments.add(
              TextLabel(
                label: 'Match Scouting - ${match.number}',
                headerLabel: true,
              ),
            );
            scoutedComments.add(
              createCommentBlock(
                context,
                widget.scoutedMatches[i].generalComments,
              ),
            );
          }
        }
      }
    }
    return true;
  }

  Widget createCommentBlock(BuildContext context, String comment) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 20.0,
        left: 20.0,
        bottom: 20.0,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: AutoSizeText(
        (comment.isEmpty) ? 'No comments provided.' : comment,
        style: TextStyle(
          fontSize: Device.fontLabel(context),
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
