import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../util/deviceinfo.dart';

class GenericTextInputDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool multiline;

  const GenericTextInputDialog({
    super.key,
    required this.title,
    this.subtitle = "",
    this.multiline = false,
  });

  @override
  State<GenericTextInputDialog> createState() => _GenericTextInputDialogState();
}

class _GenericTextInputDialogState extends State<GenericTextInputDialog> {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Device.fontSize(context, 23.0, 28.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        key: _inputKey,
                        autocorrect: false,
                        autofocus: true,
                        maxLines: widget.multiline ? null : 1,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(
                                  context, _inputKey.currentState?.value);
                            }
                          },
                          child: const Text('submit'))
                    ],
                  ))
            ],
          )),
    );
  }
}
