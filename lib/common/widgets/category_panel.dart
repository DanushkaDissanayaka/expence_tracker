import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'panel_header.dart';

class CategoryPanel extends StatelessWidget {
  const CategoryPanel({super.key, required this.onPick, required this.onClose});

  final ValueChanged<String> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
      final categories = getCategories();
      final keyColor = Theme.of(context).colorScheme.surfaceDim;
      final textColor = Theme.of(context).colorScheme.onSurface;

      return Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PanelHeader(title: "Category"),
            Container(height: 1, color: Colors.black.withAlpha(0x0D)),
            SizedBox(
              height: 260,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: categories.length,
                separatorBuilder: (_, __) => Divider(thickness: 1, color: Colors.black.withAlpha(0x1A)),
                itemBuilder: (context, idx) {
                  final parentName = categories[idx].parent.name;
                  final children = categories[idx].children;
                  final parentIcon = categories[idx].parent.icon.icon;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(parentIcon, color:Theme.of(context).colorScheme.outline, size: 10),
                          const SizedBox(width: 8),
                          Text(parentName, 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color:Theme.of(context).colorScheme.outline)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: children.map((cat) {
                          final icon = cat.icon.icon;
                          final label = cat.name;
                          return InkWell(
                            onTap: () => onPick(label),
                            child: Container(
                              width: 60,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: keyColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(icon, color: textColor, size: 16),
                                  const SizedBox(height: 4),
                                  Text(label, style: const TextStyle(fontSize: 9)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
