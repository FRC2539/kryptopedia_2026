import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String body;
  final Color titleColor;

  const NotificationDialog(
      {super.key,
      required this.title,
      required this.body,
      this.titleColor = Colors.orange});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: 500,
        height: 400,
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
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
                maxLines: 1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  right: 20.0, left: 20.0, bottom: 20.0, top: 30.0),
            ),
            Expanded(
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: AutoSizeText(
                  "Ok",
                  style: TextStyle(
                    fontSize: Device.fontSize(context, 15.0, 20.0),
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
