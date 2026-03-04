import 'package:flutter/material.dart';
import 'package:kryptopedia/screens/image_viewer.dart';
import 'dart:io';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/widgets/common/info_not_available.dart';
import 'package:kryptopedia/widgets/common/label.dart';

class PitInfoRobotPhoto extends StatelessWidget {
  final ScoutedPit scoutedPit;

  const PitInfoRobotPhoto({super.key, required this.scoutedPit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextLabel(label: 'Robot Picture', headerLabel: true),
        FutureBuilder<String>(
          future: scoutedPit.photoPath,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final robotFileNameWithPath = snapshot.data!;

              if (!(snapshot.data != "" &&
                  File(robotFileNameWithPath).existsSync())) {
                return const InformationNotAvailable(
                  infoDescription: "Robot picture",
                );
              }

              return Container(
                padding: const EdgeInsets.only(
                  top: 0.0,
                  right: 5.0,
                  left: 30.0,
                  bottom: 5.0,
                ),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Image.file(
                        File(robotFileNameWithPath),
                        width: 200.0,
                      ),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(
                              imagePath: robotFileNameWithPath,
                              title: '${scoutedPit.teamNumber}',
                            ),
                          ),
                        ),
                      },
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}
