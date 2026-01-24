import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/util/deviceinfo.dart';
import 'package:kryptopedia/widgets/common/dropdown.dart';

class CheckboxList<T> extends StatefulWidget {
  final String title;
  final List<MultiSelectOption<T>> options;
  final List<T> initialValues;
  final ValueChanged<List<T>> callback;

  const CheckboxList(
      {super.key,
      required this.title,
      required this.options,
      required this.initialValues,
      required this.callback});

  @override
  State<CheckboxList> createState() => _CheckboxListState<T>();
}

class _CheckboxListState<T> extends State<CheckboxList<T>> {
  late List<T> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            widget.title,
            style: TextStyle(
              fontSize: Device.fontLabel(context),
            ),
          ),
          SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 10,
            children: widget.options.map((option) {
              return Row(
                children: [
                  Checkbox(
                    value: selectedValues.contains(option.value),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedValues.add(option.value);
                        } else {
                          selectedValues.remove(option.value);
                        }
                        widget.callback(selectedValues);
                      });
                    },
                  ),
                  Text(option.label, style: TextStyle(fontSize: 14)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
