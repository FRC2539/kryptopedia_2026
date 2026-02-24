import 'package:flutter/material.dart';
import 'package:kryptopedia/models/scouted_match.dart';
import 'package:kryptopedia/util/singletons.dart';
import 'package:kryptopedia/widgets/common/dynamic_dropdown.dart';
import 'package:kryptopedia/widgets/common/layouts.dart';
import 'package:kryptopedia/widgets/common/scouting_section.dart';
import 'package:kryptopedia/widgets/common/text_field.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _Dropdown();
}

class _Dropdown extends State<Dropdown> {
  late TextEditingController _penaltiesController;

  @override
  void initState() {
    super.initState();
    _penaltiesController = TextEditingController();
  }

  late TextInputField textInputField = TextInputField(
    label: "penalties",
    isMultiline: true,
    initialValue: "",
    controller: _penaltiesController,
    callback: (value) {
      scoutedMatchSingleton.generalComments = value;
    },
  );
  @override
  Widget build(BuildContext context) {
    return ScoutingSection(
      title: 'Penalties (beta)',
      children: [
        ResponsiveLayout(
          portraitMode: LayoutMode.singleColumn,
          landscapeMode: LayoutMode.twoColumn,
          group1: [
            DynamicDropdownList(
              label: 'Penalties',
              initialValue: "none",
              options: [
                DynamicMultiSelectOption(value: "none", label: 'none'),
                DynamicMultiSelectOption(value: "pin", label: 'pin'),
                DynamicMultiSelectOption(value: "minor", label: 'minor'),
                DynamicMultiSelectOption(value: "major", label: 'major'),
              ],
              callback: (newValue) {
                _penaltiesController.text += " ";
                _penaltiesController.text += newValue;
              },
            ),
          ],
          group2: [textInputField],
        ),
      ],
    );
  }
}
