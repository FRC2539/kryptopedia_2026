import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/common/banners.dart';

class TeamInfoChooser extends StatefulWidget {
  final List<Team> teamList;
  final ValueNotifier<int> teamChangedNotifier;

  const TeamInfoChooser({
    super.key,
    required this.teamList,
    required this.teamChangedNotifier,
  });

  @override
  State<TeamInfoChooser> createState() => _TeamInfoChooserState();
}

class _TeamInfoChooserState extends State<TeamInfoChooser> {
  @override
  Widget build(BuildContext context) {
    if (widget.teamList.length == 1) {
      return PitBanner(
        "${widget.teamList[0].number} - ${widget.teamList[0].nickname}",
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(
          top: 15.0,
          bottom: 5.0,
          right: 10.0,
          left: 10.0,
        ),
        padding: const EdgeInsets.only(
          top: 5.0,
          bottom: 5.0,
          right: 20.0,
          left: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  "Choose a Team:",
                  style: TextStyle(fontSize: Device.fontLabel(context)),
                  maxLines: 1,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: DropdownButton(
                value: widget.teamChangedNotifier.value,
                onChanged: (newValue) {
                  setState(() {
                    widget.teamChangedNotifier.value = newValue!;
                  });
                },
                items: widget.teamList.map<DropdownMenuItem<int>>((Team team) {
                  return DropdownMenuItem<int>(
                    value: team.number,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: AutoSizeText(
                        "${team.number} - ${team.nickname}",
                        style: TextStyle(
                          fontSize: Device.fontSize(context, 10.0, 20.0),
                        ),
                        maxFontSize: Device.fontSize(context, 12.0, 17.0),
                        minFontSize: Device.fontSize(context, 5.0, 10.0),
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
