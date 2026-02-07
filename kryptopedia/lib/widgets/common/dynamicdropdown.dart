import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class DynamicDropdownList<T> extends StatefulWidget {
  final List<DynamicMultiSelectOption<T>> options;
  final String label;
  final T initialValue;

  final ValueChanged<T> callback;

  const DynamicDropdownList({
    super.key,
    required this.label,
    required this.options,
    required this.initialValue,
    required this.callback,
  });

  @override
  State<DynamicDropdownList> createState() => _DynamicDropdownListState<T>();
}

class _DynamicDropdownListState<T> extends State<DynamicDropdownList<T>> {
  T? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
        left: 12.0,
        right: 12.0,
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: AutoSizeText(
              widget.label,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: Device.fontLabel(context)),
              maxLines: 3,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            child: DropdownButton<T>(
              value: _selectedOption,
              onChanged: (newValue) {
                if (newValue == null) return;
                setState(() {
                  widget.callback(newValue);
                  _selectedOption = newValue;
                  _selectedOption = widget.initialValue;
                });
              },
              items: widget.options.map<DropdownMenuItem<T>>((option) {
                return DropdownMenuItem(
                  value: option.value,
                  child: AutoSizeText(
                    "   ${option.label}   ",
                    style: TextStyle(fontSize: Device.fontLabel(context)),
                  ),
                );
              }).toList(),
              /*
      6666   777777
    66           77
    666666      77
    66  66     77
     6666     77
*/
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicMultiSelectOption<T> {
  final T value;
  final String label;

  const DynamicMultiSelectOption({required this.value, required this.label});
}
