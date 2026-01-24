import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class ScoutingSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ScoutingSection(
      {super.key, required this.title, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        right: 10.0,
        left: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(25.0))),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
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
                              fontSize: Device.fontHeader2(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
              ),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
