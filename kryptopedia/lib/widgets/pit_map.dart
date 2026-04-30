import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/screens/team_info.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/scouted_pits.dart';

// Change to StatefulWidget to track state
class PitMap extends StatefulWidget {
  const PitMap({super.key});

  @override
  State<PitMap> createState() => _PitMapState();
}

class _PitMapState extends State<PitMap> {
  final DbScoutedPits dbScoutedPits = DbScoutedPits();
  final DbEvents dbEvents = DbEvents();

  final TransformationController _transformationController =
      TransformationController();
  final Map<int, Rect> _pitBounds = {}; // Store team number -> bounds mapping

  bool saveZoom = false;

  Future<FutureData> getData() async {
    final scoutedPits = await dbScoutedPits.getScoutedPits();
    final event = await dbEvents.getEvent();

    return FutureData(scoutedPits, event.pitMapDataJSON);
  }

  void _onTapUp(TapUpDetails details, BoxConstraints constraints) async {
    // Convert tap position to map coordinates
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // Account for current transformation (zoom/pan)
    final inverseMatrix = Matrix4.inverted(_transformationController.value);
    final untransformedPoint = MatrixUtils.transformPoint(
      inverseMatrix,
      localPosition,
    );

    // Check if any pit was tapped
    for (var entry in _pitBounds.entries) {
      if (entry.value.contains(untransformedPoint)) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TeamInfo(passedTeamID: int.parse(entry.key.toString())),
          ),
        );
        setState(() {
          saveZoom = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _onTapUp(details, BoxConstraints()),
      child: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(double.infinity),
        transformationController: _transformationController,
        constrained: false,
        maxScale: 1.5,
        minScale: 0.1,
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.pitMapData == null) {
                return const Center(child: Text("No map data found"));
              }

              Map<String, dynamic> pitMapData = snapshot.data!.pitMapData!;
              List<ScoutedPit> scoutedPits = snapshot.data!.scoutedPits;

              if (!saveZoom) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // zoom out to fit and center the whole map
                  final Size screenSize = MediaQuery.of(context).size;
                  final double scaleX =
                      screenSize.width / pitMapData["size"]["x"];
                  final double scaleY =
                      screenSize.height / pitMapData["size"]["y"];
                  final double scale = scaleX < scaleY ? scaleX : scaleY;
                  _transformationController.value = Matrix4.identity()
                    ..scaleByDouble(scale, scale, scale, 1)
                    ..translateByDouble(
                      (screenSize.width - pitMapData["size"]["x"] * scale) / 2,
                      (screenSize.height - pitMapData["size"]["y"] * scale) / 2,
                      0,
                      1,
                    );
                });
              }

              _pitBounds.clear(); // Clear previous bounds
              return CustomPaint(
                painter: PitMapPainter(
                  pitMapData,
                  scoutedPits,
                  onPitPainted: (team, bounds) {
                    _pitBounds[team] = bounds;
                  },
                ),
                size: Size(
                  pitMapData["size"]["x"].toDouble(),
                  pitMapData["size"]["y"].toDouble(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class FutureData {
  final List<ScoutedPit> scoutedPits;
  final Map<String, dynamic>? pitMapData;

  FutureData(this.scoutedPits, this.pitMapData);
}

class PitMapPainter extends CustomPainter {
  final Map<String, dynamic> pitMapData;
  final List<ScoutedPit> scoutedPits;
  final Function(int team, Rect bounds)? onPitPainted;

  PitMapPainter(this.pitMapData, this.scoutedPits, {this.onPitPainted});

  DbScoutedPits dbScoutedPits = DbScoutedPits();

  @override
  void paint(Canvas canvas, Size size) {
    for (Map<String, dynamic> pit in pitMapData["pits"]?.values ?? []) {
      final String teamString = pit["team"]?.toString() ?? "";
      final int teamNumber = int.tryParse(teamString) ?? 0;
      final Paint paint;
      if (teamString == "" || teamNumber == 0) {
        paint = Paint()..color = Color(0xFF616161);
      } else {
        paint = Paint()
          ..color = scoutedPits.any((sPit) => sPit.teamNumber == teamNumber)
              ? Colors.green
              : Colors.red
          ..style = PaintingStyle.fill;
      }
      // Create rect for drawing and hit testing
      // data is from center, but we need top-left for drawing
      final Rect pitRect = Rect.fromLTWH(
        pit["position"]["x"].toDouble() - pit["size"]["x"].toDouble() / 2,
        pit["position"]["y"].toDouble() - pit["size"]["y"].toDouble() / 2,
        pit["size"]["x"].toDouble(),
        pit["size"]["y"].toDouble(),
      );

      // Draw the pit
      canvas.drawRect(pitRect, paint);

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(pitRect, borderPaint);

      // Draw team number
      final textPainter = TextPainter(
        text: TextSpan(
          text: pit["team"],
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          pit["position"]["x"].toDouble() +
              (pit["size"]["x"].toDouble() - textPainter.width) / 2 -
              pit["size"]["x"].toDouble() / 2,
          pit["position"]["y"].toDouble() +
              (pit["size"]["y"].toDouble() - textPainter.height) / 2 -
              pit["size"]["y"].toDouble() / 2,
        ),
      );

      // Store the pit bounds for hit detection
      if (onPitPainted != null) {
        onPitPainted!(teamNumber, pitRect);
      }
    }

    for (Map<String, dynamic> area in pitMapData["areas"]?.values ?? []) {
      final paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(
          area["position"]["x"].toDouble() - area["size"]["x"].toDouble() / 2,
          area["position"]["y"].toDouble() - area["size"]["y"].toDouble() / 2,
          area["size"]["x"].toDouble(),
          area["size"]["y"].toDouble(),
        ),
        paint,
      );
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(
        Rect.fromLTWH(
          area["position"]["x"].toDouble() - area["size"]["x"].toDouble() / 2,
          area["position"]["y"].toDouble() - area["size"]["y"].toDouble() / 2,
          area["size"]["x"].toDouble(),
          area["size"]["y"].toDouble(),
        ),
        borderPaint,
      );

      final String areaLabel = area["label"]?.toString() ?? "";

      final textPainter = TextPainter(
        text: TextSpan(
          text: areaLabel,
          style: const TextStyle(color: Colors.black, fontSize: 15),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          area["position"]["x"].toDouble() +
              (area["size"]["x"].toDouble() - textPainter.width) / 2 -
              area["size"]["x"].toDouble() / 2,
          area["position"]["y"].toDouble() +
              (area["size"]["y"].toDouble() - textPainter.height) / 2 -
              area["size"]["y"].toDouble() / 2,
        ),
      );
    }

    for (Map<String, dynamic> label in pitMapData["labels"]?.values ?? []) {
      final String labelText = label["label"]?.toString() ?? "";
      final textPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          label["position"]["x"].toDouble() +
              (label["size"]["x"].toDouble() - textPainter.width) / 2,
          label["position"]["y"].toDouble() +
              (label["size"]["y"].toDouble() - textPainter.height) / 2,
        ),
      );
    }

    for (Map<String, dynamic> wall in pitMapData["walls"]?.values ?? []) {
      final paint = Paint()
        ..color = Colors.blueGrey
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(
          wall["position"]["x"].toDouble() - wall["size"]["x"].toDouble() / 2,
          wall["position"]["y"].toDouble() - wall["size"]["y"].toDouble() / 2,
          wall["size"]["x"].toDouble(),
          wall["size"]["y"].toDouble(),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
