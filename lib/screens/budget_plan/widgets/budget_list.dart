import 'package:flutter/material.dart';

class BudgetList extends StatelessWidget {
  final Map<String, List<String>> mainCategories;
  final List<Map<String, dynamic>> budgetList;
  final int? editingIndex;
  final String editingBudget;
  final String editingPerson;
  final Function(String) onEditingBudgetChanged;
  final Function(String?) onEditingPersonChanged;
  final List<String> personOptions;
  final Function(int, String, String) onEditSave;
  final Function(int) onEditStart;
  final Function(int) onDelete;
  final Function() onEditCancel;

  const BudgetList({
    super.key,
    required this.mainCategories,
    required this.budgetList,
    required this.editingIndex,
  required this.editingBudget,
  required this.editingPerson,
  required this.onEditingBudgetChanged,
  required this.onEditingPersonChanged,
    required this.personOptions,
    required this.onEditSave,
    required this.onEditStart,
    required this.onDelete,
    required this.onEditCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (budgetList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(child: Text('No budgets added.', style: TextStyle(color: Colors.grey[600], fontSize: 16))),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: mainCategories.keys.map((mainCat) {
          final subBudgets = budgetList.where((b) => b['mainCategory'] == mainCat).toList();
          if (subBudgets.isEmpty) return SizedBox.shrink();
          final total = subBudgets.fold<double>(0, (sum, item) => sum + double.tryParse(item['budget'] ?? '0')!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mainCat, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Total: ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              ...subBudgets.asMap().entries.map((entry) {
                final i = budgetList.indexOf(entry.value);
                final item = entry.value;
                final isEditing = editingIndex == i;
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: isEditing
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Person',
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                      value: editingPerson.isEmpty ? null : editingPerson,
                      items: personOptions
                        .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                          ))
                        .toList(),
                      onChanged: onEditingPersonChanged,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 80,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Budget',
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        onChanged: onEditingBudgetChanged,
                                        initialValue: editingBudget,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['subCategory'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text('Person: ${item['person']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                        ),
                        isEditing
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle, color: Colors.green),
                                    onPressed: () => onEditSave(i, editingPerson, editingBudget),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.red),
                                    onPressed: onEditCancel,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(item['budget'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => onEditStart(i),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => onDelete(i),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }).toList(),
      ),
    );
  }
}
