import 'package:flutter/material.dart';
import 'package:kryptopedia/util/device.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmText;
  final bool dangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.body,
    this.confirmText = "Continue",
    this.dangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: dangerous ? Colors.red : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        height: Device.dialogHeight(context, 0.3),
        width: Device.dialogWidth(context, 0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Visibility(
              visible: dangerous,
              child: Icon(Icons.warning, color: Colors.red),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: Device.fontHeader(context),
                fontWeight: dangerous ? FontWeight.bold : FontWeight.normal,
                color: dangerous ? Colors.red : Colors.black,
              ),
              maxLines: 1,
            ),
            Text(
              body,
              style: TextStyle(fontSize: Device.fontLabel(context)),
              maxLines: 1,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                confirmText,
                style: TextStyle(fontSize: Device.fontButton(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
