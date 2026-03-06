import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../util/deviceinfo.dart';

class ImageViewer extends StatelessWidget {
  final String imagePath;
  final String title;
  final ImageSource imageSource;

  const ImageViewer({
    super.key,
    required this.imagePath,
    required this.title,
    this.imageSource = ImageSource.file,
  });

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
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(100),
          maxScale: 5,
          child: switch (imageSource) {
            ImageSource.asset => Image.asset(imagePath, fit: BoxFit.cover),
            ImageSource.file => Image.file(File(imagePath), fit: BoxFit.cover),
          }
        ),
      ),
    );
  }
}

enum ImageSource { asset, file }
