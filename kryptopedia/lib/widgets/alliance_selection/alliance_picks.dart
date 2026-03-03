import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class AlliancePicks extends StatelessWidget {
  final int currentAlliance;
  final bool activeAlliance;
  final AllianceTeam allianceInfo;
  final int numberTeamsPerAlliance;
  final ValueChanged<int> singleTapCallback;

  const AlliancePicks({
    super.key,
    required this.currentAlliance,
    required this.activeAlliance,
    required this.allianceInfo,
    required this.numberTeamsPerAlliance,
    required this.singleTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    String allianceMembers = "";
    allianceMembers = (allianceInfo.alliancePartners.isNotEmpty)
        ? "${allianceInfo.alliancePartners[0]}"
        : "xxxx";
    allianceMembers += (allianceInfo.alliancePartners.length >= 2)
        ? " - ${allianceInfo.alliancePartners[1]}"
        : " - xxxx";
    allianceMembers += (allianceInfo.alliancePartners.length >= 3)
        ? " - ${allianceInfo.alliancePartners[2]}"
        : " - xxxx";

    if (numberTeamsPerAlliance == 4) {
      allianceMembers += (allianceInfo.alliancePartners.length >= 4)
          ? " - ${allianceInfo.alliancePartners[3]}"
          : " - xxxx";
    }

    return GestureDetector(
      onTap: () {
        singleTapCallback(currentAlliance);
      },
      child: Container(
        width: 250.0,
        height: 25.0,
        decoration: BoxDecoration(
          color: (activeAlliance) ? Colors.orange.shade100 : Colors.white,
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
                color:
                    (allianceInfo.alliancePartners.length >=
                        numberTeamsPerAlliance)
                    ? Colors.green
                    : (activeAlliance)
                    ? Colors.orange
                    : Colors.grey.shade400,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                ),
              ),
              child: AutoSizeText(
                currentAlliance.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Device.fontTable(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              child: AutoSizeText(
                allianceMembers,
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

class AllianceTeam {
  List<int> alliancePartners = [];
  int numTeamsPicked = 0;
}
