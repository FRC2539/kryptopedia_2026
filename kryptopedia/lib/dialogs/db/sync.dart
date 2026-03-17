import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/db/setup.dart';
import 'package:kryptopedia/dialogs/db/viewer.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/helper.dart';
import 'package:kryptopedia/util/db/sync.dart';
import 'package:relative_time/relative_time.dart';

class SyncPopup extends StatefulWidget {
  const SyncPopup({super.key});

  @override
  State<SyncPopup> createState() => _SyncPopupState();
}

class _SyncPopupState extends State<SyncPopup> {
  late Future<Event> event;
  bool syncEnabled = false;

  Future<Event> getEvent() {
    DbEvents dbEvents = DbEvents();
    return dbEvents.getEvent();
  }

  @override
  void initState() {
    super.initState();
    event = getEvent();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("Database & Sync"),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      constraints: BoxConstraints(maxHeight: 500),
      content: FutureBuilder(
        future: event,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return Text("No event data found. Please restart the app.");
          }
          Event event = snapshot.data!;
          String lastSync = "Never";
          if (event.lastSync != null) {
            lastSync = RelativeTime.locale(
              const Locale('en'),
            ).format(event.lastSync!);
          }
          syncEnabled = event.syncEnabled;

          return Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(event.name, style: TextStyle(fontWeight: FontWeight.bold)),
              syncEnabled
                  ? Text("Last Sync: $lastSync")
                  : Text("local-only: database sync is disabled"),
              ElevatedButton.icon(
                onPressed: syncEnabled
                    ? () async {
                        setState(() {
                          syncEnabled = false;
                        });
                        await syncFlow(context, withPhotos: false);
                        this.event = getEvent();
                        setState(() {
                          syncEnabled = true;
                        });
                      }
                    : null,
                label: Text("Sync Data"),
                icon: Icon(Icons.sync),
              ),
              ElevatedButton.icon(
                onPressed: syncEnabled
                    ? () async {
                        setState(() {
                          syncEnabled = false;
                        });
                        await syncFlow(context);
                        this.event = getEvent();
                        setState(() {
                          syncEnabled = true;
                        });
                      }
                    : null,
                label: Text("Sync Photos"),
                icon: Icon(Icons.sync),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: syncEnabled
                    ? () async {
                        setState(() {
                          syncEnabled = false;
                        });
                        await syncFlow(context, hard: true);
                        this.event = getEvent();
                        setState(() {
                          syncEnabled = true;
                        });
                      }
                    : null,
                child: Text("amnesia sync"),
              ),
              ElevatedButton(
                onPressed: syncEnabled
                    ? () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          useRootNavigator: false,
                          builder: (context) =>
                              EventSetupDialog(authOnly: true),
                        );
                      }
                    : null,
                child: Text("redo auth setup"),
              ),
              Spacer(),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool? confirmed = await showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: "Clear the database?",
                          body:
                              "any unsynced data will be lost! this could be bad!!",
                          protected: true,
                        ),
                      );
                      if (confirmed != true) return;
                      DbHelper dbHelper = DbHelper();
                      await dbHelper.recreateDatabase();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        useRootNavigator: false,
                        builder: (context) => EventSetupDialog(),
                      );
                    },
                    child: Icon(Icons.delete_forever),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DbViewerDialog(),
                      );
                    },
                    label: Text("Inspect Database"),
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
