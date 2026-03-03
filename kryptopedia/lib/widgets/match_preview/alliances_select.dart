/*
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/tba_event_alliance.dart';
import 'package:kryptopedia/util/db/eventalliances.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class AlliancesSelect extends StatefulWidget {
  final ValueChanged<AlliancesSelection> callback;

  const AlliancesSelect({super.key, required this.callback});

  @override
  State<AlliancesSelect> createState() => _AlliancesSelectState();
}

class _AlliancesSelectState extends State<AlliancesSelect> {
  int selectedRed = -1;
  int selectedBlue = -1;

  DbEvent dbEvent = DbEvent();
  DbEventAlliances dbEventAlliances = DbEventAlliances();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTeamList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.0,
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 15.0, bottom: 5.0, right: 10.0, left: 10.0),
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5.0, right: 20.0, left: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25.0))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    "Blue Alliance:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Device.fontLabel(context),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: DropdownButton(
                                  value: selectedBlue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedBlue = newValue!;
                                      updateSelection(snapshot.data!);
                                    });
                                  },
                                  items: snapshot.data!.map<DropdownMenuItem>(
                                      (TBAEventAlliance alliance) {
                                    return DropdownMenuItem(
                                        value: alliance.allianceId,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 5.0),
                                            child: AutoSizeText(
                                              "Alliance ${alliance.allianceId}",
                                              style: TextStyle(
                                                  fontSize: Device.fontLabel(
                                                      context)),
                                              maxLines: 1,
                                            )));
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 15.0, bottom: 5.0, right: 10.0, left: 10.0),
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, right: 20.0, left: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  "Red Alliance:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Device.fontLabel(context),
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: DropdownButton(
                                value: selectedRed,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedRed = newValue!;
                                    updateSelection(snapshot.data!);
                                  });
                                },
                                items: snapshot.data!.map<DropdownMenuItem>(
                                    (TBAEventAlliance alliance) {
                                  return DropdownMenuItem(
                                      value: alliance.allianceId,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: AutoSizeText(
                                            "Alliance ${alliance.allianceId}",
                                            style: TextStyle(
                                                fontSize:
                                                    Device.fontLabel(context)),
                                            maxLines: 1,
                                          )));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  void updateSelection(List<TBAEventAlliance> alliances) {
    AlliancesSelection selection = AlliancesSelection(
      red: alliances.firstWhere(
        (alliance) => alliance.allianceId == selectedRed,
      ),
      blue: alliances.firstWhere(
        (alliance) => alliance.allianceId == selectedBlue,
      ),
    );
    widget.callback(selection);
  }

  Future<List<TBAEventAlliance>> getTeamList() async {
    List<TBAEventAlliance> alliances = await dbEventAlliances.getEventAlliances();

    if (selectedBlue == -1 || selectedRed == -1) {
      if (selectedBlue == -1) {
        selectedBlue = alliances.first.allianceId;
      }
      if (selectedRed == -1) {
        selectedRed = alliances.last.allianceId;
      } 
      updateSelection(alliances);
    }

    return alliances;
  }
}

class AlliancesSelection {
  TBAEventAlliance red;
  TBAEventAlliance blue;

  AlliancesSelection({
    required this.red,
    required this.blue,
  });
}
*/
