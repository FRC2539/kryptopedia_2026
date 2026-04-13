import 'package:flutter/material.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/util/db/events.dart';

class StartPositionsSelect extends StatefulWidget {
  final Alliance alliance;
  final String station1Label;
  final String station2Label;
  final String station3Label;
  final StartPosition? value;
  final Function(StartPosition) onPositionSelected;

  const StartPositionsSelect({
    super.key,
    required this.alliance,
    required this.station1Label,
    required this.station2Label,
    required this.station3Label,
    required this.onPositionSelected,
    this.value,
  });

  @override
  State<StartPositionsSelect> createState() => _StartPositionsSelectState();
}

class _StartPositionsSelectState extends State<StartPositionsSelect> {
  late Future<FieldSide> fieldSide;
  late StartPosition? selectedPosition;

  final Map<StartPosition, Rect> positionBounds = {};

  @override
  void initState() {
    super.initState();
    fieldSide = _getFieldSide();
    selectedPosition = widget.value;
  }

  Future<FieldSide> _getFieldSide() async {
    DbEvents dbEvents = DbEvents();
    Event event = await dbEvents.getEvent();
    return event.defaultFieldSide ?? FieldSide.oppositeScoringTableSide;
  }

  void _onTapUp(TapUpDetails details) {
    for (var entry in positionBounds.entries) {
      if (entry.value.contains(details.localPosition)) {
        setState(() {
          selectedPosition = entry.key;
        });
        widget.onPositionSelected(entry.key);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fieldSide,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          FieldSide fieldSide = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              //keep 3:5 aspect ratio
              double width = constraints.maxWidth;
              double height = width * 5 / 3;
              if (height > constraints.maxHeight) {
                height = constraints.maxHeight;
                width = height * 3 / 5;
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTapUp: (details) => _onTapUp(details),
                  child: CustomPaint(
                    painter: StartPositionPainter(
                      alliance: widget.alliance,
                      fieldSide: fieldSide,
                      station1Label: widget.station1Label,
                      station2Label: widget.station2Label,
                      station3Label: widget.station3Label,
                      selectedPosition: selectedPosition,
                      onPositionPainted: (pos, bounds) {
                        positionBounds[pos] = bounds;
                      },
                    ),
                    size: Size(width, height),
                  ),
                ),
              );
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class StartPositionPainter extends CustomPainter {
  final Alliance alliance;
  final FieldSide fieldSide;
  final String station1Label;
  final String station2Label;
  final String station3Label;
  final StartPosition? selectedPosition;
  final Function(StartPosition pos, Rect bounds)? onPositionPainted;

  StartPositionPainter({
    required this.alliance,
    required this.fieldSide,
    required this.station1Label,
    required this.station2Label,
    required this.station3Label,
    required this.selectedPosition,
    this.onPositionPainted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // red & scoring table: on right side, right on top
    // blue & scoring table: on left side, left on top
    // red & opposite: on left side, left on top
    // blue & opposite: on right side, right on top
    bool fieldOnRightSide =
        (alliance == Alliance.red && fieldSide == FieldSide.scoringTableSide) ||
        (alliance == Alliance.blue &&
            fieldSide == FieldSide.oppositeScoringTableSide);

    Color color = alliance == Alliance.red ? Colors.red : Colors.blue;
    Color backgroundColor = alliance == Alliance.red
        ? Colors.redAccent
        : Colors.blueAccent;

    RRect background = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(16),
    );
    canvas.drawRRect(
      background,
      Paint()..color = backgroundColor.withValues(alpha: 0.3),
    );

    //line should be over by 1/5?
    double lineX = fieldOnRightSide ? size.width * 0.8 : size.width * 0.2;
    canvas.drawLine(
      Offset(lineX, 8),
      Offset(lineX, size.height - 8),
      Paint()
        ..color = color
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    double stationOffsets = size.height / 5;
    List<String?> stationLabels = [
      "OUTPOST",
      station3Label,
      null,
      station2Label,
      station1Label,
    ];
    if (!fieldOnRightSide) {
      stationLabels = stationLabels.reversed.toList();
    }
    for (int i = 0; i < stationLabels.length; i++) {
      if (stationLabels[i] == null) continue;
      TextSpan span = TextSpan(
        text: stationLabels[i],
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      double x = fieldOnRightSide ? lineX + 20 : lineX - 20 - tp.width;
      double y = stationOffsets * (i + 1) - tp.height / 2 - stationOffsets / 2;
      tp.paint(canvas, Offset(x, y));
    }

    //furthest from line, 1/5 tall and 1/3 wide
    double hubWidth = size.width / 3;
    double hubHeight = size.height / 5;
    double hubX = fieldOnRightSide ? 0 : size.width - hubWidth;
    double hubY = size.height / 2 - hubHeight / 2;
    Rect hubRect = Rect.fromLTWH(hubX, hubY, hubWidth, hubHeight);
    canvas.drawRect(
      hubRect,
      Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawRect(
      hubRect,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    //bumps are a touch taller than the hub
    double bumpWidth = hubWidth;
    double bumpHeight = hubHeight * 1.1;
    double bumpX = hubX;
    for (int i = 0; i < 2; i++) {
      double bumpY = hubY + (i == 0 ? -bumpHeight : hubHeight);
      Rect bumpRect = Rect.fromLTWH(bumpX, bumpY, bumpWidth, bumpHeight);
      canvas.drawRect(
        bumpRect,
        Paint()
          ..color = color.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawRect(
        bumpRect,
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill,
      );
    }

    //trench positions are the remaining top and bottom space
    //all positions will go to a little further to stations than center
    double trenchWidth = size.width * 0.6;
    double trenchHeight = (size.height - hubHeight - (bumpHeight * 2)) / 2;
    double trenchX = fieldOnRightSide ? hubX : hubX - trenchWidth + hubWidth;
    for (int i = 0; i < 2; i++) {
      double trenchY =
          hubY +
          (i == 0 ? (-bumpHeight - trenchHeight) : (bumpHeight + hubHeight));
      RRect trenchRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trenchX, trenchY, trenchWidth, trenchHeight),
        Radius.circular(8),
      );
      canvas.drawRRect(
        trenchRect,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
      StartPosition pos =
          (i == 0 && fieldOnRightSide || i == 1 && !fieldOnRightSide)
          ? StartPosition.rTrench
          : StartPosition.lTrench;
      if (pos == selectedPosition) {
        canvas.drawRRect(
          trenchRect,
          Paint()
            ..color = color.withValues(alpha: 0.5)
            ..style = PaintingStyle.fill,
        );
      }
      onPositionPainted?.call(pos, trenchRect.outerRect);
    }

    double bumpPosWidth = trenchWidth - hubWidth;
    double bumpPosHeight = bumpHeight;
    double bumpPosX = trenchX + (fieldOnRightSide ? hubWidth : 0);
    for (int i = 0; i < 2; i++) {
      double bumpPosY = hubY + (i == 0 ? -bumpHeight : hubHeight);
      RRect bumpPosRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(bumpPosX, bumpPosY, bumpPosWidth, bumpPosHeight),
        Radius.circular(8),
      );
      canvas.drawRRect(
        bumpPosRect,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
      StartPosition pos =
          (i == 0 && fieldOnRightSide || i == 1 && !fieldOnRightSide)
          ? StartPosition.rBump
          : StartPosition.lBump;
      if (pos == selectedPosition) {
        canvas.drawRRect(
          bumpPosRect,
          Paint()
            ..color = color.withValues(alpha: 0.5)
            ..style = PaintingStyle.fill,
        );
      }
      onPositionPainted?.call(pos, bumpPosRect.outerRect);
    }

    double centerPosWidth = bumpPosWidth;
    double centerPosHeight = hubHeight;
    double centerPosX = hubX + (fieldOnRightSide ? hubWidth : -centerPosWidth);
    double centerPosY = hubY;
    RRect centerPosRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerPosX, centerPosY, centerPosWidth, centerPosHeight),
      Radius.circular(8),
    );
    canvas.drawRRect(
      centerPosRect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    if (StartPosition.center == selectedPosition) {
      canvas.drawRRect(
        centerPosRect,
        Paint()
          ..color = color.withValues(alpha: 0.5)
          ..style = PaintingStyle.fill,
      );
    }
    onPositionPainted?.call(StartPosition.center, centerPosRect.outerRect);
  }

  @override
  bool shouldRepaint(StartPositionPainter oldDelegate) => true;
}

enum Alliance { red, blue }
