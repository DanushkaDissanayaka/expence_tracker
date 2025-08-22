import 'package:flutter/material.dart';

class Segmented extends StatelessWidget {
  const Segmented({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final labels = ["Income", "Expense", "Transfer"];
    return Row(
      children: List.generate(3, (i) {
        final selected = i == index;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              onTap: () => onChanged(i),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                    width: selected ? 1.4 : 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
