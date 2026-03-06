import 'package:flutter/material.dart';
import 'package:kryptopedia/screens/image_viewer.dart';

class WheelTypesDialog extends StatefulWidget {
  const WheelTypesDialog({super.key});

  @override
  State<WheelTypesDialog> createState() => _WheelTypesDialogState();
}

class _WheelTypesDialogState extends State<WheelTypesDialog> {
  Widget wheelImage(String path, String type, String label) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewer(imagePath: path, title: type),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            SizedBox(
              width: 260,
              height: 120,
              child: Image.asset(path, fit: BoxFit.contain),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("Wheel types"),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("it's about the texture of the outside!"),
          SizedBox(height: 8),
          wheelImage(
            "assets/images/wheels-colson.jpg",
            "Colson",
            "Colson- smooth",
          ),
          wheelImage(
            "assets/images/wheels-billet.jpg",
            "Billet",
            "Billet- rows",
          ),
          wheelImage(
            "assets/images/wheels-spike.jpg",
            "Spike",
            "Spike- spikes",
          ),
        ],
      ),
    );
  }
}
