//i hate state >:(

import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/main.dart';
import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/widgets/common/banners.dart';
import 'package:kryptopedia/widgets/team_select_grid.dart';

class ManageTeamFlags extends StatefulWidget {
  const ManageTeamFlags({super.key});

  @override
  State<ManageTeamFlags> createState() => _ManageTeamFlagsState();
}

class _ManageTeamFlagsState extends State<ManageTeamFlags> {
  late Future<List<TeamFlagApplication>> data;

  @override
  void initState() {
    super.initState();
    data = getTeamFlagApplications();
  }

  Future<List<TeamFlagApplication>> getTeamFlagApplications() async {
    DbTeamFlagApplications dbTeamFlagApplications = DbTeamFlagApplications();
    return await dbTeamFlagApplications.getActiveTeamFlagApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Team Flags")),
      body: Column(
        spacing: 4,
        children: [
          PageBanner(
            color: cougarOrange,
            children: [
              Text(
                "Sync before and after editing flags to avoid conflicts! Flags are especially prone to sync conflicts. Could be bad!! yet to be implemented though",
              ),
            ],
          ),
          FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text("Error: ${snapshot.error}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No team flags yet!");
              }
              List<TeamFlagApplication> applications = snapshot.data!;
              List<String> uniqueFlagNames = applications
                  .map((app) => app.name)
                  .toSet()
                  .toList();
              return ListView.builder(
                itemCount: uniqueFlagNames.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  List<TeamFlagApplication> appsForFlag = applications
                      .where((app) => app.name == uniqueFlagNames[index])
                      .toList();
                  return Card(
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => ModifyFlagDialog(
                            flagName: uniqueFlagNames[index],
                            selectedTeamNumbers: appsForFlag
                                .map((app) => app.teamNumber)
                                .toList(),
                          ),
                        );
                        setState(() {
                          data = getTeamFlagApplications();
                        });
                      },
                      child: ListTile(
                        title: Text(uniqueFlagNames[index]),
                        subtitle: Text("${appsForFlag.length} teams"),
                        leading: Icon(Icons.flag),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            useRootNavigator: false,
            barrierDismissible: false,
            builder: (context) => ModifyFlagDialog(),
          );
          setState(() {
            data = getTeamFlagApplications();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyFlagDialog extends StatefulWidget {
  final String? flagName;
  final List<int>? selectedTeamNumbers;

  const ModifyFlagDialog({super.key, this.flagName, this.selectedTeamNumbers});

  @override
  State<ModifyFlagDialog> createState() => _ModifyFlagDialogState();
}

class _ModifyFlagDialogState extends State<ModifyFlagDialog> {
  String? flagName;
  List<int> selectedTeamNumbers = [];
  late final TextEditingController _flagNameController;

  @override
  void initState() {
    super.initState();
    flagName = widget.flagName;
    selectedTeamNumbers = [...?widget.selectedTeamNumbers];
    _flagNameController = TextEditingController(text: widget.flagName ?? '');
  }

  @override
  void dispose() {
    _flagNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void submit() async {
      if (flagName == null || flagName!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Flag name can't be empty!"),
            showCloseIcon: true,
          ),
        );
        return;
      }

      if (selectedTeamNumbers.isEmpty) {
        bool? confirmation = await showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: "Delete flag?",
            body:
                "Flags must have at least one team. Continuing will delete this flag",
          ),
        );
        if (confirmation != true) return;
      }

      DbTeamFlagApplications dbTeamFlagApplications = DbTeamFlagApplications();
      for (int teamNumber in selectedTeamNumbers) {
        await dbTeamFlagApplications.upsertTeamFlagApplication(
          TeamFlagApplication(flagName!, teamNumber, true, false),
        );
      }

      List<int> removedTeams =
          widget.selectedTeamNumbers
              ?.where((teamNumber) => !selectedTeamNumbers.contains(teamNumber))
              .toList() ??
          [];
      for (int teamNumber in removedTeams) {
        await dbTeamFlagApplications.upsertTeamFlagApplication(
          TeamFlagApplication(flagName!, teamNumber, true, true),
        );
      }

      if (!context.mounted) return;
      Navigator.pop(context);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  widget.flagName == null ? "New Team Flag" : "Edit Team Flag",
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Divider(),
            TextField(
              controller: _flagNameController,
              decoration: InputDecoration(
                labelText: "Flag Name",
                hintText: "Choose carefully! This can't be changed later.",
                enabled: widget.flagName == null,
              ),
              onChanged: (value) => setState(() {
                flagName = value.trim();
              }),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  TeamSelectGrid(
                    selectedTeamsNumbers: selectedTeamNumbers,
                    callback: (selectedTeamNumbers) {
                      setState(() {
                        this.selectedTeamNumbers = selectedTeamNumbers;
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: widget.flagName != null
                        ? FloatingActionButton.extended(
                            onPressed: submit,
                            label: const Text("Update"),
                            icon: const Icon(Icons.edit),
                          )
                        : FloatingActionButton.extended(
                            onPressed: submit,
                            label: const Text("Create"),
                            icon: const Icon(Icons.create),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
