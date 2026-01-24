import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/util/db/helper.dart';

class SyncPopup extends StatefulWidget {
  const SyncPopup({super.key});

  @override
  State<SyncPopup> createState() => _SyncPopupState();
}

class _SyncPopupState extends State<SyncPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Database & Sync"),
      content: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                label: Text("Push Data"),
                icon: Icon(Icons.upload),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                label: Text("Pull Data"),
                icon: Icon(Icons.download),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () async {
              bool? confirmed = await clearDbConfirmation(context);
              if (confirmed == true) {
                DbHelper dbHelper = DbHelper();
                await dbHelper.recreateDatabaseWithTestData();
              }
            },
            label: Text("Replace DB With Test Data"),
            icon: Icon(Icons.developer_mode),
          ),
          Spacer(),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool? confirmed = await clearDbConfirmation(context);
                  if (confirmed == true) {
                    DbHelper dbHelper = DbHelper();
                    await dbHelper.recreateDatabase();
                  }
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

Future<bool?> clearDbConfirmation(BuildContext context) async =>
    await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Clear the database?",
        body: "any unsynced data will be lost! this could be bad!!",
        dangerous: true,
      ),
    );
