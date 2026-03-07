import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/wheel_types.dart';
import 'package:kryptopedia/models/scouted_pit.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/common/number_field.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';

class PitScoutingSpecs extends StatefulWidget {
  const PitScoutingSpecs({super.key});

  @override
  State<PitScoutingSpecs> createState() => _PitScoutingSpecsState();
}

class _PitScoutingSpecsState extends State<PitScoutingSpecs> {
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Robot Specs',
      children: [
        ResponsiveLayout(
          portraitMode: LayoutMode.singleColumn,
          landscapeMode: LayoutMode.twoColumn,
          group1: [
            CheckboxListTile(
              title: Text(
                "Robot is a kit bot",
                style: TextStyle(fontSize: Device.fontLabel(context)),
              ),
              value: scoutedPitSingleton.isKitBot,
              onChanged: (value) {
                setState(() {
                  scoutedPitSingleton.isKitBot = value!;
                });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            NumberField(
              label: "Robot weight (lbs.)",
              subtitle: "without battery or bumpers, preferably at inspection",
              minValue: 35,
              maxValue: 115,
              startValue: scoutedPitSingleton.weight,
              callback: (int newValue) {
                scoutedPitSingleton.weight = newValue;
              },
            ),
            NumberField(
              label: "Robot's width (in.)",
              subtitle: "with bumpers",
              minValue: 10,
              maxValue: 40,
              startValue: scoutedPitSingleton.width,
              callback: (int newValue) {
                scoutedPitSingleton.width = newValue;
              },
            ),
            NumberField(
              label: "Robot's depth (in.)",
              minValue: 10,
              maxValue: 40,
              startValue: scoutedPitSingleton.depth,
              callback: (int newValue) {
                scoutedPitSingleton.depth = newValue;
              },
            ),
          ],
          group2: [
            NumberField(
              label: "Robot starting height (in.)",
              minValue: 2,
              maxValue: 150,
              startValue: scoutedPitSingleton.startingHeight,
              callback: (int newValue) {
                scoutedPitSingleton.startingHeight = newValue;
              },
            ),
            NumberField(
              label: "Robot's height when fully extended (in.)",
              subtitle: "(not including an extended climber hook)",
              minValue: 2,
              maxValue: 150,
              startValue: scoutedPitSingleton.extendedHeight,
              callback: (int newValue) {
                scoutedPitSingleton.extendedHeight = newValue;
              },
            ),
            DropdownList(
              label: 'Robot\'s drivetrain',
              options: [
                MultiSelectOption(value: Drivetrain.swerve, label: 'Swerve'),
                MultiSelectOption(value: Drivetrain.tank, label: 'Tank'),
                MultiSelectOption(value: Drivetrain.mecanum, label: 'Mecanum'),
              ],
              initialValue: scoutedPitSingleton.drivetrain,
              callback: (newValue) {
                scoutedPitSingleton.drivetrain = newValue;
              },
            ),
            DropdownList(
              label: 'Robot\'s wheel type',
              infoButtonAction: (context) => showDialog(
                context: context,
                builder: (context) => WheelTypesDialog(),
              ),
              options: [
                MultiSelectOption(value: WheelType.colson, label: 'Colson'),
                MultiSelectOption(value: WheelType.billet, label: 'Billet'),
                MultiSelectOption(value: WheelType.spike, label: 'Spike'),
                MultiSelectOption(value: WheelType.other, label: 'Other'),
              ],
              initialValue: scoutedPitSingleton.wheelType,
              callback: (newValue) {
                scoutedPitSingleton.wheelType = newValue;
              },
            ),
          ],
        )
      ],
    );
  }
}
