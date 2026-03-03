import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class TeamInfoTables {
  static Padding sectionHeader(String header) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AutoSizeText(
          header,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  static SizedBox topHeader(
    BuildContext context,
    double cellWidth,
    String header,
    Color fgColor,
    bool leftBorder,
    bool rightBorder,
  ) {
    return SizedBox(
      width: cellWidth,
      height: 50.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: const BorderSide(color: Colors.black, width: 1.0),
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            left: BorderSide(
              color: (leftBorder) ? Colors.white : Colors.black,
              width: 1.0,
            ),
            right: BorderSide(
              color: (rightBorder) ? Colors.white : Colors.black,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AutoSizeText(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Device.fontTable(context),
              color: fgColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  static SizedBox sideHeader(
    BuildContext context,
    double cellWidth,
    String header,
    Color fgColor,
    bool leftBorder,
    bool rightBorder,
  ) {
    return SizedBox(
      width: cellWidth,
      height: 30.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: const BorderSide(color: Colors.black, width: 1.0),
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            left: BorderSide(
              color: (leftBorder) ? Colors.white : Colors.black,
              width: 1.0,
            ),
            right: BorderSide(
              color: (rightBorder) ? Colors.white : Colors.black,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AutoSizeText(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Device.fontTable(context),
              color: fgColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  static Row displayFreeTextField(BuildContext context, String freeText) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1.0),
            ),
            child: AutoSizeText(
              freeText,
              style: TextStyle(
                fontSize: Device.fontSize(context, 12.0, 16.0),
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static TableCell displayCell(
    String value,
    bool header,
    BuildContext context,
    double cellWidth,
    Color backgroundColor,
    Color textColor,
    bool center,
  ) {
    return TableCell(
      child: Row(
        children: <Widget>[
          (header)
              ? smallCellContainer(
                  value,
                  context,
                  cellWidth,
                  backgroundColor,
                  textColor,
                  true,
                  center,
                )
              : smallCellContainer(
                  value,
                  context,
                  cellWidth,
                  backgroundColor,
                  textColor,
                  false,
                  center,
                ),
        ],
      ),
    );
  }

  static SizedBox smallCellContainer(
    String value,
    BuildContext context,
    double cellWidth,
    Color backgroundColor,
    Color textColor,
    bool headers,
    bool center,
  ) {
    return SizedBox(
      width: cellWidth,
      height: 30.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(5.0),
        child: Align(
          alignment: center ? Alignment.center : Alignment.centerLeft,
          child: AutoSizeText(
            value,
            // textAlign: (center) ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              fontSize: Device.fontTable(context),
              color: textColor,
              fontWeight: headers ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  static TableCell emptyCell() {
    return TableCell(child: Container());
  }

  static TableRow createSeparatorRow(int numberOfCells) {
    List<Widget> separaterCells = [];
    for (int i = 0; i < numberOfCells; i++) {
      separaterCells.add(
        TableCell(
          child: Container(
            height: 10.0,
            width: 50.0,
            decoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      );
    }

    return TableRow(children: separaterCells);
  }
}
