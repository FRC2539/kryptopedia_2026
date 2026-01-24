import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/deviceinfo.dart';

class PasscodeDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final String correctCode;
  final bool numbersOnly;
  final void Function() callback;

  const PasscodeDialog(
      {super.key,
      required this.title,
      this.subtitle = "",
      required this.correctCode,
      required this.callback,
      this.numbersOnly = false});

  @override
  State<PasscodeDialog> createState() => _PasscodeDialogState();
}

class _PasscodeDialogState extends State<PasscodeDialog> {
  final _formKey = GlobalKey<FormState>();

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
                  style: TextStyle(
                    fontSize: Device.fontSize(context, 18.0, 23.0),
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'no guess?';
                          }
                          if ((value == '2539') &&
                              (widget.correctCode != '2539')) {
                            return 'for once, no';
                          }
                          if (value != widget.correctCode) {
                            return 'no';
                          }
                          return null;
                        },
                        autocorrect: false,
                        autofocus: true,
                        keyboardType: (widget.numbersOnly)
                            ? TextInputType.number
                            : TextInputType.text,
                        inputFormatters: widget.numbersOnly
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : [],
                        onEditingComplete: () => {
                          if (_formKey.currentState!.validate())
                            {Navigator.pop(context, true), widget.callback()}
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context, true);
                              widget.callback();
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
