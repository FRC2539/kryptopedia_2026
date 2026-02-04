import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/db/setup.dart';
import 'package:kryptopedia/dialogs/db/viewer.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/dialogs/notification.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/helper.dart';

class SyncPopup extends StatefulWidget {
  const SyncPopup({super.key});

  @override
  State<SyncPopup> createState() => _SyncPopupState();
}

class _SyncPopupState extends State<SyncPopup> {
  bool syncEnabled = false;

  @override
  void initState() {
    DbEvents dbEvents = DbEvents();
    dbEvents.getEvent().then((value) {
      setState(() {
        syncEnabled = value.syncEnabled;
      });
    });
    super.initState();
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
      constraints: BoxConstraints(maxHeight: 400),
      content: Column(
        spacing: 8,
        children: [
          ElevatedButton.icon(
            onPressed: syncEnabled
                ? () async {
                    setState(() {
                      syncEnabled = false;
                    });
                    DbHelper dbHelper = DbHelper();
                    String? error = await dbHelper.syncData();
                    if (error != null) {
                      if (!context.mounted) return;
                      await showDialog(
                        context: context,
                        builder: (context) => NotificationDialog(
                          title: "Sync Error",
                          body: error,
                        ),
                      );
                    } else {
                      if (!context.mounted) return;
                      await showDialog(
                        context: context,
                        builder: (context) => NotificationDialog(
                          title: "Sync Complete",
                          body: "Data synced successfully! woohoo",
                        ),
                      );
                    }
                    setState(() {
                      syncEnabled = true;
                    });
                  }
                : null,
            label: Text("Sync Data"),
            icon: Icon(Icons.sync),
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
      ),
    );
  }
}
