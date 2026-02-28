import 'package:flutter/material.dart';
import 'package:kryptopedia/widgets/pit_map.dart';

class PitMapViewer extends StatefulWidget {
  const PitMapViewer({super.key});

  @override
  State<PitMapViewer> createState() => _PitMapViewerState();
}

class _PitMapViewerState extends State<PitMapViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pit Map')),
      body: Center(child: PitMap()),
    );
  }
}
