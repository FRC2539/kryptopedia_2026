import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/deviceinfo.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool multiline;
  final bool numberOnly;

  const TextInputDialog({
    super.key,
    required this.title,
    this.subtitle = "",
    this.multiline = false,
    this.numberOnly = false,
  });

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _inputKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: 500,
        height: 400,
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Device.fontSize(context, 23.0, 28.0),
                fontWeight: FontWeight.bold,
              ),
            ),
            AutoSizeText(widget.subtitle, textAlign: TextAlign.center),
            Form(
              key: _formKey,
              child: Column(
                spacing: 8,
                children: <Widget>[
                  TextFormField(
                    key: _inputKey,
                    autocorrect: false,
                    autofocus: true,
                    maxLines: widget.multiline ? null : 1,
                    keyboardType: widget.numberOnly
                        ? TextInputType.number
                        : TextInputType.text,
                    inputFormatters: [
                      if (widget.numberOnly)
                        FilteringTextInputFormatter.digitsOnly,
                    ],
                    onEditingComplete: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, _inputKey.currentState?.value);
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, _inputKey.currentState?.value);
                      }
                    },
                    child: const Text('submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
