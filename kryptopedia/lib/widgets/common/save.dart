import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/dialogs/confirmation.dart';

import 'package:kryptopedia/dialogs/notification.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class ScoutingSave extends StatelessWidget {
  final String? Function() saveFunction;

  const ScoutingSave({super.key, required this.saveFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final String? confirmation = await showDialog<String>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: '*** WARNING ***',
                      body: "You are about to cancel your current scouting "
                          "activity.  If you continue, you will lose all "
                          "scouted data collected.",
                      cancelText: "Return to Form",
                    );
                  });

              if (context.mounted && confirmation != null) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[500],
            ),
            child: AutoSizeText(
              "Cancel",
              style: TextStyle(
                fontSize: Device.fontSize(context, 15.0, 20.0),
                color: Colors.black,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 100.0),
          ElevatedButton(
            onPressed: () async {
              final String? confirmation = await showDialog<String>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return const ConfirmationDialog(
                      title: 'Confirmation',
                      body:
                          "You are about to save your scouting observations.  "
                          "Once these settings are saved, you will not be able "
                          "to make any additional changes.",
                      confirmText: "Save",
                    );
                  });

              if (confirmation != null) {
                String? message = saveFunction();

                if (context.mounted) {
                  await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return NotificationDialog(
                        title: "Scouting Data Saved",
                        body: "Successfully recorded.\n\n"
                            '${message ?? ""}',
                      );
                    }
                  );
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[500],
            ),
            child: AutoSizeText(
              "Save",
              style: TextStyle(
                fontSize: Device.fontSize(context, 15.0, 20.0),
                color: Colors.black,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
