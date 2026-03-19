import 'package:flutter/material.dart';

class PredictionsDebugDialog extends StatefulWidget {
  const PredictionsDebugDialog({super.key});

  @override
  State<PredictionsDebugDialog> createState() => _PredictionsDebugDialogState();
}

class _PredictionsDebugDialogState extends State<PredictionsDebugDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("Predictions Debug"),
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
          ElevatedButton(onPressed: () {}, child: Text("Test Accuracy")),
        ],
      ),
    );
  }
}
