import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionNumber extends StatefulWidget {
  const VersionNumber({super.key});

  @override
  State<VersionNumber> createState() => _VersionNumberState();
}

class _VersionNumberState extends State<VersionNumber> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: PackageInfo.fromPlatform().then(
          (packageInfo) => packageInfo.version,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              "version ${snapshot.data}",
              style: const TextStyle(fontSize: 10.0, color: Colors.blueGrey),
            );
          } else if (snapshot.hasError) {
            return Text(
              "error: ${snapshot.error}",
              style: const TextStyle(fontSize: 10.0),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
