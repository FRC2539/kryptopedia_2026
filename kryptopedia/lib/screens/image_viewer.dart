import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../util/deviceinfo.dart';

class ImageViewer extends StatelessWidget {
  final String imagePath;
  final String title;

  const ImageViewer({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          title,
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          maxScale: 5,
          child: Image.file(File(imagePath), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
