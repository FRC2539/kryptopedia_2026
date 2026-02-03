import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/db/setup.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/dialogs/notification.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/helper.dart';

class SyncPopup extends StatefulWidget {
  const SyncPopup({super.key});

  @override
  State<SyncPopup> createState() => _SyncPopupState();
}

class _SyncPopupState extends State<SyncPopup> {
  late Future<Event> _event;

  @override
  void initState() {
    DbEvents dbEvents = DbEvents();
    _event = (dbEvents.getEvent());
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
          FutureBuilder<Event>(
            future: _event,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              if (!snapshot.data!.syncEnabled) {
                return Text("local-only: sync is not set up");
              }
              bool buttonEnabled = true;
              return ElevatedButton.icon(
                onPressed: buttonEnabled
                    ? () async {
                        setState(() {
                          buttonEnabled = false;
                        });
                        DbHelper dbHelper = DbHelper();
                        String? error = await dbHelper.syncData();
                        setState(() {
                          buttonEnabled = true;
                        });
                        if (error != null) {
                          if (!context.mounted) return;
                          await showDialog(
                            context: context,
                            builder: (context) => NotificationDialog(
                              title: "Sync Error",
                              body: error,
                            ),
                          );
                        }
                      }
                    : null,
                label: Text("Sync Data"),
                icon: Icon(Icons.sync),
              );
            },
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
                onPressed: () {},
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
