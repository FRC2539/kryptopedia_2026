import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class DropdownList<T> extends StatefulWidget {
  final List<MultiSelectOption<T>> options;
  final String label;
  final T initialValue;

  final ValueChanged<T> callback;

  const DropdownList(
      {super.key,
      required this.label,
      required this.options,
      required this.initialValue,
      required this.callback});

  @override
  State<DropdownList> createState() => _DropdownListState<T>();
}

class _DropdownListState<T> extends State<DropdownList<T>> {
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
              style: TextStyle(
                fontSize: Device.fontLabel(context),
              ),
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
                  _selectedOption = newValue;
                  widget.callback(newValue);
                });
              },
              items: widget.options.map<DropdownMenuItem<T>>((option) {
                return DropdownMenuItem(
                    value: option.value,
                    child: AutoSizeText(
                      "   ${option.label}   ",
                      style: TextStyle(
                        fontSize: Device.fontLabel(context),
                      ),
                    ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectOption<T> {
  final T value;
  final String label;

  const MultiSelectOption({required this.value, required this.label});
}
