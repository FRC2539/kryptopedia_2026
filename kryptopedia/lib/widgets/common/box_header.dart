import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class BoxHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;
  const BoxHeader(this.title, this.textColor, this.backgroundColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  bottom: 10.0,
                  top: 10.0,
                ),
                child: AutoSizeText(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      // fontSize: Device.fontSize(context, 20.0, 25.0),
                      fontSize: Device.fontHeader2(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ));
  }
}
