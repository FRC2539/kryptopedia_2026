import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class InformationNotAvailable extends StatelessWidget {
  final String infoDescription;

  const InformationNotAvailable({super.key, required this.infoDescription});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          "*****  ",
          style: TextStyle(
            color: Colors.red,
            fontSize: Device.fontHeader2(context),
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
        ),
        AutoSizeText(
          "$infoDescription\ncurrently not available.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: Device.fontHeader2(context),
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
        ),
        AutoSizeText(
          "  *****",
          style: TextStyle(
            color: Colors.red,
            fontSize: Device.fontHeader2(context),
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
