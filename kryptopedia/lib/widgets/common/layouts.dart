import 'package:flutter/material.dart';
import 'package:kryptopedia/util/deviceinfo.dart';

class ResponsiveLayout extends StatelessWidget {
  final LayoutMode portraitMode;
  final LayoutMode landscapeMode;
  final List<Widget> group1;
  final List<Widget> group2;
  const ResponsiveLayout(
      {super.key,
      required this.portraitMode,
      required this.landscapeMode,
      required this.group1,
      required this.group2});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isLandscape = landscape(context);
      final layoutMode = isLandscape ? landscapeMode : portraitMode;
      return _buildLayout(layoutMode);
    });
  }

  Widget _buildLayout(LayoutMode layoutMode) {
    switch (layoutMode) {
      case LayoutMode.singleColumn:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: group1 + group2,
        );
      case LayoutMode.twoColumn:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: group1,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: group2,
              ),
            ),
          ],
        );
      case LayoutMode.singleRow:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: group1 + group2,
        );
    }
  }
}

enum LayoutMode { singleColumn, twoColumn, singleRow }
