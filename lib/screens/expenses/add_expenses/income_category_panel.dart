import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/common/widgets/panel_header.dart';

class IncomeCategoryPanel extends StatelessWidget {
  const IncomeCategoryPanel({super.key, required this.onPick, required this.onClose});

  final ValueChanged<String> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final items = const [
      ("Allowance", Icons.attach_money),
      ("Salary", Icons.money),
      ("Petty Cash", Icons.account_balance_wallet),
    ];
    final keyColor = Theme.of(context).colorScheme.surfaceDim;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PanelHeader(title: "Category"),
          Container(height: 1, color: Colors.black.withAlpha(0x0D)),
          SizedBox(
            height: 120,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
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