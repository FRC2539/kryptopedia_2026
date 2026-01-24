import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kryptopedia/util/device.dart';

final passcode = "1414";

class ConfirmationDialog extends StatefulWidget {
  final String title;
  final String body;
  final String confirmText;
  final String cancelText;
  final bool dangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.body,
    this.confirmText = "Continue",
    this.cancelText = "Cancel",
    this.dangerous = false,
  });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  late final formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: widget.dangerous ? Colors.red : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ConstrainedBox(
        // padding: EdgeInsets.all(8),
        // height:
        // width: Device.dialogWidth(context, 0.6),
        constraints: BoxConstraints(
          maxHeight: Device.dialogHeight(context, 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Visibility(
              visible: widget.dangerous,
              child: Icon(Icons.warning, color: Colors.red),
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: Device.fontHeader(context),
                fontWeight: widget.dangerous
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: widget.dangerous ? Colors.red : Colors.white,
              ),
              maxLines: 1,
            ),
            AutoSizeText(
              widget.body,
              style: TextStyle(fontSize: Device.fontLabel(context)),
              maxLines: 2,
            ),
            Visibility(
              visible: widget.dangerous,
              child: Column(
                spacing: 8,
                children: [
                  Text("Enter the database passcode to continue:"),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'no guess?';
                            }
                            if ((value == '2539') && (passcode != '2539')) {
                              return 'for once, no';
                            }
                            if (value != passcode) {
                              return 'no :(';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              isFormValid =
                                  formKey.currentState?.validate() ?? false;
                            });
                          },
                          autocorrect: false,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onEditingComplete: () => {
                            if (formKey.currentState!.validate())
                              {Navigator.pop(context, true)},
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    widget.cancelText,
                    style: TextStyle(fontSize: Device.fontButton(context)),
                  ),
                ),
                ElevatedButton(
                  onPressed: (!widget.dangerous || isFormValid)
                      ? () {
                          Navigator.of(context).pop(true);
                        }
                      : null,
                  child: Text(
                    widget.confirmText,
                    style: TextStyle(fontSize: Device.fontButton(context)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
