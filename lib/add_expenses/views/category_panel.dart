import 'package:flutter/material.dart';
import 'panel_header.dart';

class CategoryPanel extends StatelessWidget {
  const CategoryPanel({super.key, required this.onPick, required this.onClose});

  final ValueChanged<String> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final items = const [
      ("Food", Icons.ramen_dining),
      ("Social Life", Icons.groups_outlined),
      ("Pets", Icons.pets_outlined),
      ("Transport", Icons.local_taxi_outlined),
      ("Culture", Icons.photo_outlined),
      ("Household", Icons.chair_outlined),
      ("Apparel", Icons.checkroom_outlined),
      ("Beauty", Icons.brush_outlined),
      ("Health", Icons.health_and_safety_outlined),
      ("Education", Icons.menu_book_outlined),
      ("Gift", Icons.card_giftcard_outlined),
      ("Other", Icons.more_horiz),
    ];

    // Light theme only
    // const backgroundColor = Colors.white;
    final keyColor = Theme.of(context).colorScheme.surfaceDim;
    // const borderColor = Color(0xFFE0E0E0);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Material(
      // color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PanelHeader(title: "Category"),
          Container(height: 1, color: Colors.black.withAlpha(0x0D)),
          SizedBox(
            height: 260, // Adjust height as needed
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (_, i) {
                final (label, icon) = items[i];
                return InkWell(
                  onTap: () => onPick(label),
                  child: Container(
                    decoration: BoxDecoration(
                      color: keyColor,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: textColor, size: 16),
                        const SizedBox(height: 8),
                        Text(label, style: const TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
