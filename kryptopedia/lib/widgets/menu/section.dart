import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/widgets/menu/item.dart';

class MenuSection extends StatelessWidget {
  final List<MenuItemDefinition> items;
  const MenuSection(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.where((item) {
      return (landscape(context)
                  ? item.landscapeWidget != null
                  : item.portraitWidget != null) &&
              (kDebugMode || !item.debugOnly) ||
          item.onTap != null;
    }).toList();

    return Container(
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: visibleItems
            .map(
              (item) => GestureDetector(
                onTap: () {
                  if (item.onTap != null) {
                    item.onTap!(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => landscape(context)
                            ? item.landscapeWidget ?? RotateDeviceScreen()
                            : item.portraitWidget ?? RotateDeviceScreen(),
                      ),
                    );
                  }
                },
                child: MenuItem(
                  item.title,
                  item.description,
                  item.icon,
                  item == visibleItems.last,
                  dev: item.debugOnly,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class RotateDeviceScreen extends StatelessWidget {
  const RotateDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          "Please rotate your device.",
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class MenuItemDefinition {
  final String title;
  final String? description;
  final IconData icon;
  final Widget? portraitWidget;
  final Widget? landscapeWidget;
  final Function(BuildContext context)? onTap;
  final bool debugOnly;

  const MenuItemDefinition({
    required this.title,
    this.description,
    required this.icon,
    this.portraitWidget,
    this.landscapeWidget,
    this.onTap,
    this.debugOnly = false,
  });
}
