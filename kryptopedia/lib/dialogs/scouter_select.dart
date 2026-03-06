import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/team_members.dart';
import 'package:kryptopedia/util/device.dart';

class ScouterSelectDialog extends StatefulWidget {
  const ScouterSelectDialog({super.key});

  @override
  State<ScouterSelectDialog> createState() => _ScouterSelectDialogState();
}

class _ScouterSelectDialogState extends State<ScouterSelectDialog> {
  late Future<List<TeamMember>> teamMembers;
  late String _selectedScouter;

  DbTeamMembers dbTeamMembers = DbTeamMembers();
  DbEvents dbEvents = DbEvents();

  Future<List<TeamMember>> _future() async {
    List<TeamMember> teamMembers = await dbTeamMembers.getTeamMembers();

    Event event = await dbEvents.getEvent();
    _selectedScouter = event.lastScouter ?? teamMembers[0].id;

    return teamMembers;
  }

  @override
  void initState() {
    super.initState();
    teamMembers = _future();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("Who's scouting?"),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        height: 100,
        width: Device.dialogWidth(context, 3 / 4, 700),
        child: FutureBuilder(
          future: teamMembers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Column(
              spacing: 16,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<String>(
                    value: _selectedScouter,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedScouter = newValue!;
                        dbEvents.updateLastScouter(_selectedScouter);
                      });
                    },
                    items: snapshot.data!.map<DropdownMenuItem<String>>((
                      TeamMember scouter,
                    ) {
                      return DropdownMenuItem<String>(
                        value: scouter.id,
                        child: SizedBox(
                          width: Device.isTablet(context) ? 425.0 : 225.0,
                          child: AutoSizeText(
                            scouter.name,
                            style: TextStyle(
                              fontSize: Device.fontSize(context, 12.0, 22.0),
                            ),
                            maxLines: 2,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      snapshot.data!.firstWhere(
                        (element) => element.id == _selectedScouter,
                      ),
                    );
                  },
                  child: Text("Continue"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
