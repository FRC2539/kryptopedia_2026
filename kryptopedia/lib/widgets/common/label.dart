import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class TextLabel extends StatelessWidget {
  final String label;
  final bool headerLabel;

  const TextLabel({super.key, required this.label, required this.headerLabel});

  @override
  Widget build(BuildContext context) {
    if (headerLabel) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
          left: 15.0,
          right: 5.0,
          bottom: 10.0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Device.fontLabel(context),
                  color: Colors.orange.shade600,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          bottom: 15.0,
          right: 20.0,
          left: 20.0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: Device.fontLabel(context)),
              ),
            ),
          ],
        ),
      );
    }
  }
}
