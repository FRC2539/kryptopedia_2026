import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class AvailableTeams extends StatelessWidget {
  final int rank;
  final int teamId;
  final bool doNotPick;
  final ValueChanged<int> singleTapCallback;
  final ValueChanged<int> doubleTapCallback;

  const AvailableTeams({
    super.key,
    required this.rank,
    required this.teamId,
    required this.doNotPick,
    required this.singleTapCallback,
    required this.doubleTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        singleTapCallback(teamId);
      },
      onDoubleTap: () {
        doubleTapCallback(teamId);
      },
      child: Container(
        width: 85.0,
        height: 25.0,
        decoration: BoxDecoration(
          color: (doNotPick) ? Colors.red.shade200 : Colors.white,
          border: Border.all(width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        child: Row(
          children: [
            Container(
              width: 30.0,
              height: 25.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (doNotPick) ? Colors.red : Colors.grey.shade400,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                ),
              ),
              child: AutoSizeText(
                rank.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Device.fontTable(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 5.0),
              child: AutoSizeText(
                teamId.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Device.fontTable(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
