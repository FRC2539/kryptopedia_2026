import 'package:flutter/material.dart';

class EnergizedRankingPointIcon extends StatelessWidget {
  final Color? color;
  const EnergizedRankingPointIcon({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        const snackBar = SnackBar(content: Text('Energized Ranking Point'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Icon(Icons.circle, color: color),
    );
  }
}

class SuperchargedRankingPointIcon extends StatelessWidget {
  final Color? color;
  const SuperchargedRankingPointIcon({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        const snackBar = SnackBar(content: Text('Supercharged Ranking Point'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Icon(Icons.bolt, color: color),
    );
  }
}

class TraversalRankingPointIcon extends StatelessWidget {
  final Color? color;
  const TraversalRankingPointIcon({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        const snackBar = SnackBar(content: Text('Traversal Ranking Point'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Icon(Icons.castle, color: color),
    );
  }
}
