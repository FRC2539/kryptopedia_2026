import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Camera extends StatefulWidget {
  final String imagePath;
  final ValueChanged<String> callback;

  const Camera({super.key, required this.imagePath, required this.callback});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _image = (widget.imagePath.isNotEmpty) ? XFile(widget.imagePath) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
        right: 20.0,
        left: 20.0,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_image != null)
                ? Image.file(
                    File(_image!.path),
                    width: 200.0,
                  )
                : const Image(
                    image: AssetImage('assets/images/gearpaw.png'),
                    width: 200.0,
                  ),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  XFile? pickedImage = await _picker.pickImage(
                    // source: ImageSource.gallery,
                    source: ImageSource.camera,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      _image = pickedImage;
                      widget.callback(_image!.path);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: AutoSizeText(
                  (_image == null)
                      ? "Take photo of the robot"
                      : "Retake photo of the robot",
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
