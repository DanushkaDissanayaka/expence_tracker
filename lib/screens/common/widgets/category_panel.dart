import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';

class CategoryPanel extends StatelessWidget {
  const CategoryPanel({super.key, required this.onPick, required this.onClose});

  final ValueChanged<SubCategory> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
      final categories = getCategories();

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey.shade600,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, idx) {
                  final parentName = categories[idx].parent.name;
                  final children = categories[idx].children;
                  final parentIcon = categories[idx].parent.icon.icon;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                parentIcon, 
                                color: Colors.grey.shade600, 
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              parentName, 
                              style: const TextStyle(
                                fontWeight: FontWeight.w600, 
                                fontSize: 13, 
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: children.map((cat) {
                            final icon = cat.icon.icon;
                            final label = cat.name;
                            return GestureDetector(
                              onTap: () => onPick(cat),
                              child: Container(
                                width: 65,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(icon, color: Colors.grey.shade700, size: 16),
                                    const SizedBox(height: 4),
                                    Text(
                                      label, 
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
  }
}
