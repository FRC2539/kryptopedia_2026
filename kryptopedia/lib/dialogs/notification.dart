import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String body;
  final Color titleColor;

  const NotificationDialog({
    super.key,
    required this.title,
    required this.body,
    this.titleColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(color: titleColor),
      ),
      content: Container(
        padding: const EdgeInsets.all(20.0),
        width: 500,
        height: 400,
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                body,
                style: TextStyle(
                  fontSize: Device.fontSize(context, 15.0, 20.0),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: AutoSizeText(
                  "Ok",
                  style: TextStyle(
                    fontSize: Device.fontSize(context, 15.0, 20.0),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
