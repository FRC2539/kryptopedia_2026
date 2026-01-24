import "package:flutter/material.dart";
import "dart:io";
import 'dart:math';

class Screen {
  static double get _ppi => (Platform.isAndroid || Platform.isIOS) ? 150 : 96;
  static bool isLandscape(BuildContext c) =>
      MediaQuery.of(c).orientation == Orientation.landscape;
  //PIXELS
  static Size size(BuildContext c) => MediaQuery.of(c).size;
  static double width(BuildContext c) => size(c).width;
  static double height(BuildContext c) => size(c).height;
  static double diagonal(BuildContext c) {
    Size s = size(c);
    return sqrt((s.width * s.width) + (s.height * s.height));
  }

  //INCHES
  static Size inches(BuildContext c) {
    Size pxSize = size(c);
    return Size(pxSize.width / _ppi, pxSize.height / _ppi);
  }

  static double widthInches(BuildContext c) => inches(c).width;
  static double heightInches(BuildContext c) => inches(c).height;
  static double diagonalInches(BuildContext c) => diagonal(c) / _ppi;
}

class Device {
  static bool get isMobile => isAndroid || isIOS;

  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;

  static bool isLargePhone(BuildContext c) => Screen.diagonal(c) > 720;
  static bool isTablet(BuildContext c) => Screen.diagonalInches(c) >= 7;
  static bool isNarrow(BuildContext c) => Screen.widthInches(c) < 3.5;

  static double fontAvatar(BuildContext c) => isTablet(c) ? 15.0 : 15.0;
  static double fontHeader(BuildContext c) => isTablet(c) ? 25.0 : 18.0;
  static double fontHeader2(BuildContext c) => isTablet(c) ? 20.0 : 14.0;
  static double fontListTitle(BuildContext c) => isTablet(c) ? 17.0 : 17.0;
  static double fontListSubTitle(BuildContext c) => isTablet(c) ? 15.0 : 15.0;
  static double fontMenu(BuildContext c) => isTablet(c) ? 18.0 : 14.0;
  static double fontButton(BuildContext c) => isTablet(c) ? 17.0 : 13.0;
  static double fontLabel(BuildContext c) => isTablet(c) ? 18.0 : 15.0;

  static double fontTable(BuildContext c) => isTablet(c) ? 10.0 : 10.0;
  static double fontRankingTable(BuildContext c) => isTablet(c) ? 15.0 : 12.0;

  static double dialogHeight(BuildContext c, double fractionOfScreen) {
    return Screen.height(c) * fractionOfScreen;
  }

  static double dialogWidth(BuildContext c, double fractionOfScreen) {
    return Screen.width(c) * fractionOfScreen;
  }

  static double fontSize(
    BuildContext c,
    double phoneFontSize,
    double tabletFontSize,
  ) {
    return (isTablet(c)) ? tabletFontSize : phoneFontSize;
  }
}

bool landscape(BuildContext c) =>
    MediaQuery.of(c).orientation == Orientation.landscape;
