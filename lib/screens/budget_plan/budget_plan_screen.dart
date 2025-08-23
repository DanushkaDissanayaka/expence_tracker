import 'package:expense_tracker/data/data.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'widgets/budget_input_card.dart';
import 'widgets/budget_list.dart';
import 'widgets/category_panel.dart';

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
  String budgetInput = '';
  String personInput = '';
  String selectedType = '';
  final List<Person> personOptions = persons;
  final List<BudgetType> typeOptions = budgetTypeOption;
  final TextEditingController budgetController = TextEditingController();
  final List<Map<String, dynamic>> budgetList = [];
  bool showMainCategoryPanel = false;
  bool showSubCategoryPanel = false;
  int? editingIndex;
  String editingBudget = '';
  String editingPerson = '';

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

  String get formattedMonth =>
      "${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}";

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
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BudgetInputCard(
                  formattedMonth: formattedMonth,
                  personInput: personInput,
                  personOptions: personOptions,
                  onPersonChanged: (v) => setState(() => personInput = v ?? ''),
                  selectedMainCategory: selectedMainCategory,
                  selectedSubCategory: selectedSubCategory,
                  onMainCategoryTap: () =>
                      setState(() => showMainCategoryPanel = true),
                  onSubCategoryTap: () =>
                      setState(() => showSubCategoryPanel = true),
                  budgetInput: budgetInput,
                  budgetController: budgetController,
                  onBudgetChanged: (v) => setState(() => budgetInput = v),
                  selectedType: selectedType,
                  budgetTypeOptions: typeOptions,
                  onTypeChanged: (v) => setState(() => selectedType = v ?? ''),
                  onAdd: () {
                    setState(() {
                      budgetList.add({
                        'mainCategory': selectedMainCategory,
                        'subCategory': selectedSubCategory,
                        'budget': budgetInput,
                        'person': personInput,
                        'type': selectedType,
                      });
                      selectedMainCategory = '';
                      selectedSubCategory = '';
                      budgetInput = '';
                      personInput = '';
                      selectedType = '';
                      budgetController.clear();
                    });
                  },
                  canAdd:
                      selectedMainCategory.isNotEmpty &&
                      selectedSubCategory.isNotEmpty &&
                      budgetInput.isNotEmpty &&
                      personInput.isNotEmpty &&
                      selectedType.isNotEmpty,
                ),
                const SizedBox(height: 24),
                Text(
                  'Budgets for $formattedMonth',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                divider,
                const SizedBox(height: 8),
                Expanded(
                  child: BudgetList(
                    mainCategories: mainCategories,
                    budgetList: budgetList,
                    editingIndex: editingIndex,
                    editingBudget: editingBudget,
                    editingPerson: editingPerson,
                    personOptions: personOptions,
                    onEditingBudgetChanged: (v) =>
                        setState(() => editingBudget = v),
                    onEditingPersonChanged: (v) =>
                        setState(() => editingPerson = v ?? ''),
                    onEditSave: (i, person, budget) {
                      setState(() {
                        budgetList[i]['person'] = person;
                        budgetList[i]['budget'] = budget;
                        editingIndex = null;
                        editingBudget = '';
                        editingPerson = '';
                      });
                    },
                    onEditStart: (i) {
                      setState(() {
                        editingIndex = i;
                        editingBudget = budgetList[i]['budget'];
                        editingPerson = budgetList[i]['person'];
                      });
                    },
                    onDelete: (i) {
                      setState(() {
                        budgetList.removeAt(i);
                        if (editingIndex == i) {
                          editingIndex = null;
                          editingBudget = '';
                          editingPerson = '';
                        }
                      });
                    },
                    onEditCancel: () {
                      setState(() {
                        editingIndex = null;
                        editingBudget = '';
                        editingPerson = '';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          if (showMainCategoryPanel)
            CategoryPanel(
              title: "Select Main Category",
              options: mainCategories.keys.toList(),
              onSelect: (mainCat) {
                setState(() {
                  selectedMainCategory = mainCat;
                  selectedSubCategory = '';
                  showMainCategoryPanel = false;
                });
              },
              onClose: () {
                setState(() {
                  showMainCategoryPanel = false;
                });
              },
            ),
          if (showSubCategoryPanel && selectedMainCategory.isNotEmpty)
            CategoryPanel(
              title: "Select Sub Category",
              options: mainCategories[selectedMainCategory]!,
              onSelect: (subCat) {
                setState(() {
                  selectedSubCategory = subCat;
                  showSubCategoryPanel = false;
                });
              },
              onClose: () {
                setState(() {
                  showSubCategoryPanel = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
