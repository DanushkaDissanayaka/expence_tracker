import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';

class BudgetInputCard extends StatelessWidget {
  final String formattedMonth;
  final String personInput;
  final List<Person> personOptions;
  final Function(String?) onPersonChanged;
  final String selectedMainCategory;
  final String selectedSubCategory;
  final VoidCallback onMainCategoryTap;
  final VoidCallback onSubCategoryTap;
  final String budgetInput;
  final TextEditingController budgetController;
  final Function(String) onBudgetChanged;
  final String selectedType;
  final Function(String?) onTypeChanged;
  final List<BudgetType> budgetTypeOptions;
  final VoidCallback onAdd;
  final bool canAdd;

  const BudgetInputCard({
    super.key,
    required this.formattedMonth,
    required this.personInput,
    required this.personOptions,
    required this.onPersonChanged,
    required this.selectedMainCategory,
    required this.selectedSubCategory,
    required this.onMainCategoryTap,
    required this.onSubCategoryTap,
    required this.budgetInput,
    required this.budgetController,
    required this.onBudgetChanged,
    required this.selectedType,
    required this.onTypeChanged,
    required this.budgetTypeOptions,
    required this.onAdd,
    required this.canAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text('Month:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Text(formattedMonth, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Person',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: personInput.isEmpty ? null : personInput,
              items: personOptions
                  .map((p) => DropdownMenuItem(
                        value: p.personId,
                        child: Row(
                          children: [
                          Icon(p.icon.icon, color: p.color, size: 16),
                          const SizedBox(width: 8),
                          Text(p.name),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: onPersonChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onMainCategoryTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.category, color: Colors.blueAccent, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            selectedMainCategory.isEmpty ? 'Main Category' : selectedMainCategory,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: selectedMainCategory.isNotEmpty ? onSubCategoryTap : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.label, color: Colors.blueAccent, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            selectedSubCategory.isEmpty ? 'Sub Category' : selectedSubCategory,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: selectedType.isEmpty ? null : selectedType,
              items: budgetTypeOptions
                  .map((t) => DropdownMenuItem(
                        value: t.name,
                        child: Row(
                          children: [
                            Icon(t.icon.icon, color: t.color, size: 16),
                            const SizedBox(width: 8),
                            Text(t.name),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: onTypeChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: onBudgetChanged,
                    controller: budgetController,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  onPressed: canAdd ? onAdd : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
