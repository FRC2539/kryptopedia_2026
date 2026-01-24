import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scoutedpit.dart';
import 'package:kryptopedia/util/singletons.dart';
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
        CombinedColumnLayout(column1: [
          NumberField(
            label: "Robot weight (lbs.)",
            subtitle: "without battery and bumpers, preferably at inspection",
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
            maxValue: 50,
            startValue: scoutedPitSingleton.width,
            callback: (int newValue) {
              scoutedPitSingleton.width = newValue;
            },
          ),
          NumberField(
            label: "Robot's depth (in.)",
            minValue: 10,
            maxValue: 50,
            startValue: scoutedPitSingleton.depth,
            callback: (int newValue) {
              scoutedPitSingleton.depth = newValue;
            },
          ),
          CheckboxListTile(
              title: const Text("Robot is a Kit Bot"),
              value: scoutedPitSingleton.isKitBot,
              onChanged: (value) {
                scoutedPitSingleton.isKitBot = value!;
                setState(() {});
              }),
        ], column2: [
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
              })
        ])
      ],
    );
  }
}
