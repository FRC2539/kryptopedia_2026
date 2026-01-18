import 'package:flutter/material.dart';
import 'package:kryptopedia/util/device.dart';

class MenuItem extends StatelessWidget {
  const MenuItem(
    this.title,
    this.description,
    this.icon,
    this.lastItem, {
    this.dev = false,
    super.key,
  });
  final String title;
  final String? description;
  final IconData icon;
  final bool lastItem;
  final bool dev;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            style: lastItem ? BorderStyle.none : BorderStyle.solid,
          ),
        ),
        color: dev ? Colors.yellow[600] : Colors.transparent,
        backgroundBlendMode: BlendMode.darken,
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontSize: Device.fontMenu(context)),
        ),
        subtitle: description != null
            ? Text(
                description!,
                style: TextStyle(fontSize: Device.fontListSubTitle(context)),
              )
            : null,
      ),
    );
  }
}
