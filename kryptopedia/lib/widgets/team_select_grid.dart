import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/device.dart';

class TeamSelectGrid extends StatefulWidget {
  final List<int> selectedTeamsNumbers;
  final ValueChanged<List<int>> callback;

  const TeamSelectGrid({
    super.key,
    required this.selectedTeamsNumbers,
    required this.callback,
  });

  @override
  State<TeamSelectGrid> createState() => _TeamSelectGridState();
}

class _TeamSelectGridState extends State<TeamSelectGrid> {
  late Future<List<Team>> data;

  Future<List<Team>> getTeams() async {
    DbTeams dbTeams = DbTeams();
    return await dbTeams.getTeams();
  }

  @override
  void initState() {
    super.initState();
    data = getTeams();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        List<Team> teams = snapshot.data!;
        return GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: landscape(context) ? 5 : 2,
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            Team team = teams[index];
            bool selected = widget.selectedTeamsNumbers.contains(team.number);
            return GestureDetector(
              onTap: () {
                if (selected) {
                  widget.selectedTeamsNumbers.remove(team.number);
                } else {
                  widget.selectedTeamsNumbers.add(team.number);
                }
                widget.callback(widget.selectedTeamsNumbers);
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                color: selected ? Colors.green : Colors.grey,
                child: ListTile(
                  title: Text(
                    team.number.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    team.nickname,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
