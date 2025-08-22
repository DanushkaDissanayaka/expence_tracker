
    import 'package:flutter/material.dart';
    import '../add_expenses/views/category_panel.dart';

      int? editingIndex;
  String editingBudget = '';
  String editingPerson = '';

    class BudgetPlanScreen extends StatefulWidget {
      const BudgetPlanScreen({super.key});

      @override
      State<BudgetPlanScreen> createState() => _BudgetPlanScreenState();
    }

    class _BudgetPlanScreenState extends State<BudgetPlanScreen> {
      final Map<String, List<String>> mainCategories = {
        "Living": ["Food", "Household", "Transport"],
        "Personal": ["Apparel", "Beauty", "Health"],
        "Social": ["Social Life", "Culture", "Gift"],
        "Education": ["Education"],
        "Pets": ["Pets"],
        "Other": ["Other"],
      };

      String selectedMainCategory = '';
      String selectedSubCategory = '';

      DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  // Remove selectedCategory
  String budgetInput = '';
  String personInput = '';
  final List<String> personOptions = ['Shawn', 'Sam'];
  final TextEditingController budgetController = TextEditingController();
      final List<Map<String, dynamic>> budgetList = [];
  bool showMainCategoryPanel = false;
  bool showSubCategoryPanel = false;

      Future<void> _pickMonth() async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedMonth,
          firstDate: DateTime(now.year - 2, 1),
          lastDate: DateTime(now.year + 2, 12),
          selectableDayPredicate: (date) => date.day == 1,
          helpText: 'Select Month',
        );
        if (picked != null) {
          setState(() {
            selectedMonth = DateTime(picked.year, picked.month);
          });
        }
      }

      String get formattedMonth => "${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}";

      @override
      void dispose() {
        budgetController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        final divider = Divider(color: Colors.grey.shade300, height: 1);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Monthly Budget Plan'),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Month:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        Text(formattedMonth, style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickMonth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Person dropdown row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              hintText: 'Person',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            value: personInput.isEmpty ? null : personInput,
                            items: personOptions
                                .map((p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(p),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() => personInput = v ?? '');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Category selection row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => showMainCategoryPanel = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                selectedMainCategory.isEmpty ? 'Select Main Category' : selectedMainCategory,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: selectedMainCategory.isNotEmpty ? () => setState(() => showSubCategoryPanel = true) : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                selectedSubCategory.isEmpty ? 'Select Sub Category' : selectedSubCategory,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Budget input and add button row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Budget',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) {
                              setState(() => budgetInput = v);
                            },
                            controller: budgetController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                          onPressed: selectedMainCategory.isNotEmpty && selectedSubCategory.isNotEmpty && budgetInput.isNotEmpty && personInput.isNotEmpty
                              ? () {
                                  setState(() {
                                    budgetList.add({
                                      'mainCategory': selectedMainCategory,
                                      'subCategory': selectedSubCategory,
                                      'budget': budgetInput,
                                      'person': personInput,
                                    });
                                    selectedMainCategory = '';
                                    selectedSubCategory = '';
                                    budgetInput = '';
                                    personInput = '';
                                    budgetController.clear();
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('Budgets for $formattedMonth', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    divider,
                    Expanded(
                      child: budgetList.isEmpty
                          ? const Center(child: Text('No budgets added.'))
                          : ListView(
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
                                          Text(mainCat, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          Text('Total: ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                                        ],
                                      ),
                                    ),
                                    ...subBudgets.asMap().entries.map((entry) {
                                      final i = budgetList.indexOf(entry.value);
                                      final item = entry.value;
                                      final isEditing = editingIndex == i;
                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                        child: ListTile(
                                          title: isEditing
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: DropdownButtonFormField<String>(
                                                        decoration: const InputDecoration(
                                                          hintText: 'Person',
                                                          isDense: true,
                                                          border: OutlineInputBorder(),
                                                        ),
                                                        value: editingPerson.isEmpty ? null : editingPerson,
                                                        items: personOptions
                                                            .map((p) => DropdownMenuItem(
                                                                  value: p,
                                                                  child: Text(p),
                                                                ))
                                                            .toList(),
                                                        onChanged: (v) {
                                                          setState(() => editingPerson = v ?? '');
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    SizedBox(
                                                      width: 80,
                                                      child: TextField(
                                                        keyboardType: TextInputType.number,
                                                        decoration: const InputDecoration(
                                                          hintText: 'Budget',
                                                          isDense: true,
                                                          border: OutlineInputBorder(),
                                                        ),
                                                        onChanged: (v) => setState(() => editingBudget = v),
                                                        controller: TextEditingController(text: editingBudget),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(item['subCategory'], style: const TextStyle(fontSize: 15)),
                                          subtitle: isEditing
                                              ? null
                                              : Text('Person: ${item['person']}', style: const TextStyle(fontSize: 13)),
                                          trailing: isEditing
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.check, color: Colors.green),
                                                      onPressed: () {
                                                        setState(() {
                                                          budgetList[i]['person'] = editingPerson;
                                                          budgetList[i]['budget'] = editingBudget;
                                                          editingIndex = null;
                                                          editingBudget = '';
                                                          editingPerson = '';
                                                        });
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.close, color: Colors.red),
                                                      onPressed: () {
                                                        setState(() {
                                                          editingIndex = null;
                                                          editingBudget = '';
                                                          editingPerson = '';
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(item['budget'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                                    IconButton(
                                                      icon: const Icon(Icons.edit, color: Colors.orange),
                                                      onPressed: () {
                                                        setState(() {
                                                          editingIndex = i;
                                                          editingBudget = item['budget'];
                                                          editingPerson = item['person'];
                                                        });
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () {
                                                        setState(() {
                                                          budgetList.removeAt(i);
                                                          if (editingIndex == i) {
                                                            editingIndex = null;
                                                            editingBudget = '';
                                                            editingPerson = '';
                                                          }
                                                        });
                                                      },
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
                    ),
                  ],
                ),
              ),
              if (showMainCategoryPanel)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    child: SizedBox(
                      height: 300,
                      child: ListView(
                        children: mainCategories.keys.map((mainCat) => ListTile(
                              title: Text(mainCat),
                              onTap: () => setState(() {
                                selectedMainCategory = mainCat;
                                selectedSubCategory = '';
                                showMainCategoryPanel = false;
                              }),
                            )).toList(),
                      ),
                    ),
                  ),
                ),
              if (showSubCategoryPanel && selectedMainCategory.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    child: SizedBox(
                      height: 300,
                      child: ListView(
                        children: mainCategories[selectedMainCategory]!.map((subCat) => ListTile(
                              title: Text(subCat),
                              onTap: () => setState(() {
                                selectedSubCategory = subCat;
                                showSubCategoryPanel = false;
                              }),
                            )).toList(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    }
