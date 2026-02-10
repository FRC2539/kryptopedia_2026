import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:kryptopedia/util/deviceinfo.dart';

class NumberField extends StatefulWidget {
  final String label;
  final String subtitle;
  final int maxValue;
  final int minValue;
  final int startValue;
  final bool allowDirectEditing;

  final ValueChanged<int> callback;

  const NumberField(
      {super.key,
      required this.label,
      this.subtitle = "",
      required this.minValue,
      required this.maxValue,
      required this.startValue,
      required this.callback,
      this.allowDirectEditing = true});

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.maxValue <= widget.minValue) {
      throw ("maxValue can't be <= minValue");
    } else if (widget.startValue > widget.maxValue) {
      throw ("startValue must be less than or equal to maxValue");
    } else if (widget.startValue < widget.minValue) {
      throw ("startValue must be greater than or equal to minValue");
    }

    _controller.text = widget.startValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    // int flexValue = widget.maxValue > 99 ? 5 : 6;

    var tooHighSnackbar = SnackBar(
      content: Text(
        '${widget.label} must be <= ${widget.maxValue}',
          style: const TextStyle(fontSize: 20)),
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.redAccent,
      showCloseIcon: true,
    );
    var tooLowSnackbar = SnackBar(
      content: Text(
        '${widget.label} must be >= ${widget.minValue}',
          style: const TextStyle(fontSize: 20)),
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.redAccent,
      showCloseIcon: true,
    );
    const nanSnackbar = SnackBar(
      content: Text('That\'s not a number.', style: TextStyle(fontSize: 20)),
      duration: Duration(seconds: 4),
      backgroundColor: Colors.redAccent,
      showCloseIcon: true,
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:
        Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    widget.label,
                    style: TextStyle(fontSize: Device.fontLabel(context)),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: Device.fontSize(context, 10.0, 13.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            child: Container(
              height: 50.0,
              width: (Device.isTablet(context)) ? 100.0 : 50.0,
              alignment: Alignment.center,
              child: Text(
                " - ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: Device.fontSize(context, 25.0, 40.0),
                ),
              ),
            ),
            onTap: () {
              int currentValue = int.parse(_controller.text);
              if (currentValue > widget.minValue) {
                setState(() {
                  currentValue--;
                  _controller.text = (currentValue)
                      .toString(); // incrementing value
                  widget.callback(currentValue);
                });
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(tooLowSnackbar);
              }
            },
          ),
          Focus(
            child: SizedBox(
              width: (Device.isTablet(context)) ? 60.0 : 50.0,
              child: TextFormField(
                enabled: widget.allowDirectEditing,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Device.fontSize(context, 15.0, 20.0),
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: Colors.blueGrey,
                      width: 0.5,
                    ),
                  ),
                ),
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                  signed: true,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            onFocusChange: (focus) {
              if ((_controller.text == "") ||
                  (int.tryParse(_controller.text) == null)) {
                setState(() {
                  _controller.text = (widget.minValue.toString());
                  widget.callback(widget.minValue);
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(nanSnackbar);
                return;
              }
              int value = int.parse(_controller.text);

              if (value < widget.minValue) {
                setState(() {
                  _controller.text = (widget.minValue.toString());
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(tooLowSnackbar);
              }
              if (value > widget.maxValue) {
                setState(() {
                  _controller.text = (widget.maxValue.toString());
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(tooHighSnackbar);
              }

              setState(() {
                widget.callback(int.parse(_controller.text));
              });
            },
          ),
          InkWell(
            child: Container(
              height: 50.0,
              width: (Device.isTablet(context)) ? 100.0 : 50.0,
              alignment: Alignment.center,
              child: Text(
                " + ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: Device.fontSize(context, 25.0, 40.0),
                ),
              ),
            ),
            onTap: () {
              int currentValue = int.parse(_controller.text);
              if (currentValue < widget.maxValue) {
                setState(() {
                  currentValue++;
                  _controller.text = (currentValue > 0 ? currentValue : 0)
                      .toString(); // decrementing value
                  widget.callback(currentValue);
                });
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(tooHighSnackbar);
              }
            },
          ),
        ],
      ),
    );
  }
}
