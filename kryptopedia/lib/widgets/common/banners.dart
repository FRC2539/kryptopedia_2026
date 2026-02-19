import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/match.dart';
import 'package:kryptopedia/util/deviceinfo.dart';


class PageBanner extends StatelessWidget {
  final Color color;
  final List<Widget> children;

  const PageBanner({super.key, required this.color, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class MatchBanner extends StatelessWidget {
  final EventMatch match;
  final String team;
  final String alliancePosition;

  const MatchBanner({
    super.key,
    required this.team,
    required this.match,
    required this.alliancePosition,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = alliancePosition == "red" ? Colors.red : Colors.blue;
    // Color textBackgroundColor =
    //     alliance == "red" ? Colors.red.shade600 : Colors.blue.shade600;

    return PageBanner(
      color: backgroundColor,
      children: [
        AutoSizeText(
          team,
          style: TextStyle(
            fontSize: Device.fontHeader(context),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        AutoSizeText(
          match.number.toString(),
          style: TextStyle(
            fontSize: Device.fontHeader2(context),
            color: Colors.white,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

class PitBanner extends StatelessWidget {
  final String team;

  const PitBanner(this.team, {super.key});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.black54;
    Color textBackgroundColor = Colors.black12;
    return PageBanner(
      color: backgroundColor,
      children: [
        Chip(
          backgroundColor: textBackgroundColor,
          label: Text(
            team,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: Device.fontHeader(context),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
