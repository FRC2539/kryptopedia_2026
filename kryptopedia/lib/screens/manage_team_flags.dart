//i hate state >:(

import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/main.dart';
import 'package:kryptopedia/models/team_flag_application.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/sync.dart';
import 'package:kryptopedia/util/db/team_flag_applications.dart';
import 'package:kryptopedia/widgets/common/banners.dart';
import 'package:kryptopedia/widgets/team_select_grid.dart';
import 'package:relative_time/relative_time.dart';

class ManageTeamFlags extends StatefulWidget {
  const ManageTeamFlags({super.key});

  @override
  State<ManageTeamFlags> createState() => _ManageTeamFlagsState();
}

class _ManageTeamFlagsState extends State<ManageTeamFlags> {
  late Future<List<TeamFlagApplication>> data;
  String lastSync = "Never";
  bool syncEnabled = false;

  @override
  void initState() {
    super.initState();
    data = getTeamFlagApplications();
    getLastSync();
  }

  Future<void> getLastSync() async {
    DbEvents dbEvents = DbEvents();
    dbEvents.getEvent().then((value) {
      setState(() {
        syncEnabled = value.syncEnabled;
        if (value.lastSync == null) {
          lastSync = "Never";
          return;
        }
        lastSync = RelativeTime.locale(
          const Locale('en'),
        ).format(value.lastSync!);
      });
    });
  }

  Future<List<TeamFlagApplication>> getTeamFlagApplications() {
    DbTeamFlagApplications dbTeamFlagApplications = DbTeamFlagApplications();
    return dbTeamFlagApplications.getActiveTeamFlagApplications();
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
                "Sync before and after editing flags to avoid conflicts!",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Flags are especially prone to sync conflicts since everyone is working with the same set of data :) there's some conflict resolution, but disagreements could still get messy.",
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text("Last Sync: $lastSync"),
                  ElevatedButton.icon(
                    onPressed: syncEnabled
                        ? () async {
                            setState(() {
                              syncEnabled = false;
                            });
                            await syncDataFlow(context);
                            getLastSync();
                          }
                        : null,
                    label: Text("Sync Data"),
                    icon: Icon(Icons.sync),
                  ),
                ],
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
      
      List<TeamFlagApplication> existingFlags = await dbTeamFlagApplications
          .getTeamFlagApplicationsForFlag(flagName!);

      //teams not set deleted, in the local db.
      Set<int> existingTeams = existingFlags
          .where((f) => !f.deleted)
          .map((f) => f.teamNumber)
          .toSet();

      //teams that need deletion synced
      Set<int> syncedTeams = existingFlags
          .where((f) => !f.local && !f.deleted)
          .map((f) => f.teamNumber)
          .toSet();

      //teams that were deleted locally and not yet synced, so if they are added we can just remove that flag
      //will only occur for teams that exist on the server, if a team was added and deleted locally it would be removed from the local db
      Set<int> locallyDeletedTeams = existingFlags
          .where((f) => f.deleted && f.local)
          .map((f) => f.teamNumber)
          .toSet();

      //teams selected in the grid
      Set<int> finalTeams = Set.from(selectedTeamNumbers);

      Set<int> addedTeams = finalTeams.difference(existingTeams);
      Set<int> removedTeams = existingTeams.difference(finalTeams);

      // Add new teams- only sync addition if team wasn't on server already
      for (int teamNumber in addedTeams) {
        if (locallyDeletedTeams.contains(teamNumber)) {
          // team was deleted locally but not yet synced, just remove the deletion mark.
          //not local anymore! server currently thinks this team has the flag, no sync needed
          await dbTeamFlagApplications.upsertTeamFlagApplication(
            TeamFlagApplication(flagName!, teamNumber, false, false),
          );
        } else {
          // Team is truly new, add it with local = true so it gets synced
          await dbTeamFlagApplications.upsertTeamFlagApplication(
            TeamFlagApplication(flagName!, teamNumber, true, false),
          );
        }

      }

      // Remove teams- only sync deletion if team was on server
      for (int teamNumber in removedTeams) {
        if (syncedTeams.contains(teamNumber)) {
          // team exists on server, need to sync the deletion
          await dbTeamFlagApplications.upsertTeamFlagApplication(
            TeamFlagApplication(flagName!, teamNumber, true, true),
          );
        } else {
          // Team was never synced, just delete locally
          await dbTeamFlagApplications.deleteTeamFlagApplication(
            flagName!,
            teamNumber,
          );
        }
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
