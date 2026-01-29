import 'package:flutter/material.dart';
import 'package:kryptopedia/util/robot_picture_path.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/text_field.dart';
import 'package:kryptopedia/widgets/pit_scouting/camera.dart';

class PitScoutingSummary extends StatelessWidget {
  const PitScoutingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Summary',
      children: [
        FutureBuilder<String>(
          future: robotPicturePath(scoutedPitSingleton.teamNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final imagePath = snapshot.data!;
            return Camera(imagePath);
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
