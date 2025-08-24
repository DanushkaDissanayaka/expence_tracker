import 'package:expense_tracker/add_expenses/blocs/create_expensebloc/create_expense_bloc.dart';
import 'package:expense_tracker/screens/budget_plan/blocs/create_budget_plan_bloc/create_budget_plan_bloc.dart';
import 'package:expenses_repository/src/data/data.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
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
  final List<ParentCategory> mainCategories = getCategories();

  SubCategory selectedMainCategory = SubCategory.empty();
  SubCategory selectedSubCategory = SubCategory.empty();
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  String budgetInput = '';
  String personInput = '';
  String selectedType = '';
  final List<Person> personOptions = persons;
  final List<BudgetType> typeOptions = budgetTypeOption;
  final TextEditingController budgetController = TextEditingController();
  final List<Budget> budgetList = [];
  bool showMainCategoryPanel = false;
  bool showSubCategoryPanel = false;
  int? editingIndex;
  String editingBudget = '';
  String editingPerson = '';
  bool isLoading = false;

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
    return BlocListener<CreateBudgetPlanBloc, CreateBudgetPlanState>(
      listener: (context, state) {
        if (state is CreateBudgetPlanLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreateBudgetPlanSuccess) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        } else if (state is CreateBudgetPlanFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
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
                    onPersonChanged: (v) =>
                        setState(() => personInput = v ?? ''),
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
                    onTypeChanged: (v) =>
                        setState(() => selectedType = v ?? ''),
                    onAdd: () {
                      setState(() {
                        budgetList.add(
                          Budget(
                            person: personOptions.firstWhere(
                              (p) => p.personId == personInput,
                            ),
                            budgetType: typeOptions.firstWhere(
                              (t) => t.budgetTypeId == selectedType,
                            ),
                            amount: double.tryParse(budgetInput) ?? 0,
                            mainCategory: selectedMainCategory,
                            subCategory: selectedSubCategory,
                          ),
                        );

                        selectedMainCategory = SubCategory.empty();
                        selectedSubCategory = SubCategory.empty();
                        budgetInput = '';
                        personInput = '';
                        selectedType = '';
                        budgetController.clear();
                        FocusScope.of(context).unfocus();
                      });
                    },
                    canAdd: (selectedType == '1' || selectedType == '2')
                        ? budgetInput.isNotEmpty &&
                              personInput.isNotEmpty &&
                              selectedType.isNotEmpty
                        : selectedMainCategory.isNotEmpty() &&
                              selectedSubCategory.isNotEmpty() &&
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
                          budgetList[i].person = personOptions.firstWhere(
                            (p) => p.personId == person,
                          );
                          budgetList[i].amount = double.tryParse(budget) ?? 0;
                          editingIndex = null;
                          editingBudget = '';
                          editingPerson = '';
                        });
                        FocusScope.of(context).unfocus();
                      },
                      onEditStart: (i) {
                        setState(() {
                          editingIndex = i;
                          editingBudget = budgetList[i].amount.toString();
                          editingPerson = budgetList[i].person.personId;
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: kToolbarHeight,
                    child: isLoading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(
                      onPressed: budgetList.isNotEmpty
                          ? () {
                              // create budget plan
                              BudgetPlan newPlan = BudgetPlan(
                                budgetPlanId: const Uuid().v1(),
                                month: selectedMonth.month,
                                year: selectedMonth.year,
                                budgetPlan: budgetList,
                              );
                              context.read<CreateBudgetPlanBloc>().add(
                                CreateBudgetPlan(newPlan),
                              );
                            }
                          : null,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
            if (showMainCategoryPanel)
              CategoryPanel(
                title: "Select Main Category",
                options: parentCategories,
                onSelect: (parentCatId) {
                  setState(() {
                    selectedMainCategory = parentCatId;
                    selectedSubCategory = SubCategory.empty();
                    showMainCategoryPanel = false;
                  });
                },
                onClose: () {
                  setState(() {
                    showMainCategoryPanel = false;
                  });
                },
              ),
            if (showSubCategoryPanel && selectedMainCategory.isNotEmpty())
              CategoryPanel(
                title: "Select Sub Category",
                options: mainCategories
                    .firstWhere(
                      (cat) =>
                          cat.parent.categoryId ==
                          selectedMainCategory.categoryId,
                    )
                    .children,
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
      ),
    );
  }
}
