import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:kryptopedia/util/vibrate.dart';

class TestHaptics extends StatefulWidget {
  const TestHaptics({super.key});

  @override
  State<TestHaptics> createState() => _TestHapticsState();
}

class _TestHapticsState extends State<TestHaptics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.success);
            },
            child: const Text("Success"),
          ),
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.warning);
            },
            child: const Text("Warning"),
          ),
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.error);
            },
            child: const Text("Error"),
          ),
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.light);
            },
            child: const Text("Medium"),
          ),
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.heavy);
            },
            child: const Text("Heavy"),
          ),
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.rigid);
            },
            child: const Text("Rigid"),
          ),
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.soft);
            },
            child: const Text("Soft"),
          ),
          ElevatedButton(
            onPressed: () {
              vibrate(HapticsType.selection);
            },
            child: const Text("Selection"),
          ),
        ],
      ),
    );
  }
}
