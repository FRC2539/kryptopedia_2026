import 'package:flutter/material.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class TextInputField extends StatefulWidget {
  final String label;
  final bool isMultiline;
  final String initialValue;
  final TextEditingController? controller;
  final String? hint;

  final ValueChanged<String> callback;

  const TextInputField({
    super.key,
    required this.label,
    required this.isMultiline,
    required this.initialValue,
    this.controller,
    required this.callback,
    this.hint,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  String value = "";

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setValue(String newValue) {
    setState(() {
      value = newValue;
      _controller = TextEditingController(text: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
        right: 20.0,
        left: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: widget.isMultiline ? null : 1,
              decoration: InputDecoration(
                labelText: "   ${widget.label}   ",
                labelStyle: TextStyle(
                  fontSize: Device.fontSize(context, 15.0, 20.0),
                  color: Colors.white,
                ),
                hint: widget.hint != null ? Text(widget.hint!) : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
              style: TextStyle(fontSize: Device.fontSize(context, 15.0, 20.0)),
              keyboardType: TextInputType.multiline,
              controller: _controller,
              onChanged: (text) {
                setState(() {
                  value = text;
                  widget.callback(text);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
