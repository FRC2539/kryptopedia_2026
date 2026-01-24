import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/text_field.dart';
import 'package:kryptopedia/widgets/pit_scouting/camera.dart';
import 'package:path_provider/path_provider.dart';

class PitScoutingSummary extends StatelessWidget {
  const PitScoutingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Summary',
      children: [
        Camera(
          imagePath: scoutedPitSingleton.imagePath,
          callback: (String newValue) async {
            // Make sure the Robot_Pics folder exists.
            final Directory appDir = await getApplicationDocumentsDirectory();
            Directory robotPicsDir =
                await Directory("${appDir.path}/Robot_Pics").create();

            // Calculate Robot Pic Filename (with and without folder)
            String robotFileName =
                "${scoutedPitSingleton.eventId}_${scoutedPitSingleton.teamId}_photo_1.jpg";
            String robotFileNameWithPath =
                "${robotPicsDir.path}/$robotFileName";

            // Check if the Robot Pic File exists (scouter may have taken replacement photo).
            // If exists, delete it.
            if (await File(robotFileNameWithPath).exists()) {
              await File(robotFileNameWithPath).delete();
            }

            // Make a copy of the image into the Robot Pic folder
            await File(newValue).copy(robotFileNameWithPath);

            // Save the image path into the database.
            scoutedPitSingleton.imagePath = robotFileName;
            // scoutedPitSingleton.imagePath = robotFileNameWithPath;
          },
        ),
        TextInputField(
          hint: "General Comments",
          isMultiline: true,
          initialValue: scoutedPitSingleton.generalComments,
          callback: (String newValue) {
            scoutedPitSingleton.generalComments = newValue;
          },
        ),
      ],
    );
  }
}
