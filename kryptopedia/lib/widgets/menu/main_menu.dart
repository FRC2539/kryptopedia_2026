import 'package:flutter/material.dart';
import 'package:kryptopedia/widgets/menu/section.dart';
import 'package:kryptopedia/widgets/menu/version_number.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext c) {
    return ListView(
      children: [
        //test section
        MenuSection([
          MenuItemDefinition(
            title: "pimp down",
            description: "pimp in distress",
            icon: Icons.personal_injury,
            portraitWidget: const PlaceholderScreen(),
            dev: true,
          ),
          MenuItemDefinition(
            title: "i need a hundred and fifty million dollars",
            icon: Icons.money,
            portraitWidget: const PlaceholderScreen(),
            landscapeWidget: const PlaceholderScreen(),
          ),
          MenuItemDefinition(
            title: "show a snack bar",
            icon: Icons.food_bank,
            onTap: (context) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("oh bingo i got action")),
            ),
          ),
        ]),

        const VersionNumber(),
      ],
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Placeholder")),
      body: const Center(child: Placeholder()),
    );
  }
}
