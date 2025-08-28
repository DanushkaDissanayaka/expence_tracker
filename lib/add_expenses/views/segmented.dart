import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';

class Segmented extends StatelessWidget {
  const Segmented({
    super.key,
    required this.id,
    required this.onChanged,
  });

  final String id;
  final ValueChanged<BudgetType> onChanged;

  @override
  Widget build(BuildContext context) {
    final budgetType = [income, expenses];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(budgetType.length, (i) {
          final selected = budgetType[i].budgetTypeId == id;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(budgetType[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selected ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      budgetType[i].icon.icon,
                      size: 16,
                      color: selected 
                        ? budgetType[i].color 
                        : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      budgetType[i].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: selected 
                          ? budgetType[i].color 
                          : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
