import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmText;
  final String cancelText;

  const ConfirmationDialog(
      {super.key,
      required this.title,
      required this.body,
      this.confirmText = "Continue",
      this.cancelText = "Cancel"});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        width: 450,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: Device.fontSize(context, 18.0, 23.0),
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 20.0, left: 20.0, bottom: 20.0, top: 30.0),
              child: AutoSizeText(
                body,
                style:
                    TextStyle(fontSize: Device.fontSize(context, 15.0, 20.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[500],
                  ),
                  child: AutoSizeText(
                    cancelText,
                    style: TextStyle(
                      fontSize: Device.fontSize(context, 15.0, 20.0),
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(width: 75.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, "continue");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[500],
                  ),
                  child: AutoSizeText(
                    confirmText,
                    style: TextStyle(
                      fontSize: Device.fontSize(context, 15.0, 20.0),
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
