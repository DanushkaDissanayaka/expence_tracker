import 'package:expense_tracker/screens/budget_plan/blocs/create_budget_plan_bloc/create_budget_plan_bloc.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'widgets/budget_input_dialog.dart';
import 'widgets/budget_list.dart';

int? editingIndex;
String editingBudget = '';
String editingPerson = '';


class BudgetPlanScreen extends StatefulWidget {
  final BudgetPlan? initialPlan;
  const BudgetPlanScreen({Key? key, this.initialPlan}) : super(key: key);

  @override
  State<BudgetPlanScreen> createState() => _BudgetPlanScreenState();
}


class _BudgetPlanScreenState extends State<BudgetPlanScreen> {
  final List<ParentCategory> mainCategories = getCategories();

  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final List<Person> personOptions = persons;
  final List<BudgetType> typeOptions = budgetTypeOption;
  List<Budget> budgetList = [];
  int? editingIndex;
  String editingBudget = '';
  String editingPerson = '';
  bool isLoading = false;

  String get formattedMonth =>
      "${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}";

  @override
  void initState() {
    super.initState();
    if (widget.initialPlan != null) {
      selectedMonth = DateTime(widget.initialPlan!.year, widget.initialPlan!.month);
      budgetList = List<Budget>.from(widget.initialPlan!.budgetPlan);
    }
  }

  void _showBudgetInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BudgetInputDialog(
        formattedMonth: formattedMonth,
        personOptions: personOptions,
        budgetTypeOptions: typeOptions,
        mainCategories: mainCategories,
        budgetList: budgetList,
        onAdd: (Budget budget) {
          setState(() {
            budgetList.add(budget);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Budget Plan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2D3748),
              size: 20,
            ),
          ),
        ),
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
                  // Month Selection Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'For:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.initialPlan != null
                                ? null
                                : () async {
                                    final now = DateTime.now();
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedMonth,
                                      firstDate: DateTime(now.year, now.month),
                                      lastDate: DateTime(now.year + 5, 12),
                                      helpText: 'Select Month',
                                      fieldHintText: 'Month/Year',
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.light(
                                              primary: Color(0xFF3B82F6),
                                              onPrimary: Colors.white,
                                              onSurface: Color(0xFF2D3748),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null && 
                                        (picked.year > now.year || 
                                         (picked.year == now.year && picked.month >= now.month))) {
                                      setState(() {
                                        selectedMonth = DateTime(picked.year, picked.month);
                                      });
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: widget.initialPlan != null ? const Color(0xFFF1F5F9) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formattedMonth,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: widget.initialPlan != null ? const Color(0xFF94A3B8) : const Color(0xFF2D3748),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: widget.initialPlan != null ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                            onPressed: _showBudgetInputDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.add),
                          ),
                  
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    width: double.infinity,
                    height: 52,
                    child: isLoading 
                        ? Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: budgetList.isNotEmpty
                                ? () {
                                    BudgetPlan newPlan = BudgetPlan(
                                      budgetPlanId: widget.initialPlan?.budgetPlanId ?? '',
                                      month: selectedMonth.month,
                                      year: selectedMonth.year,
                                      budgetPlan: budgetList,
                                    );
                                    context.read<CreateBudgetPlanBloc>().add(
                                      CreateBudgetPlan(newPlan),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: budgetList.isNotEmpty
                                  ? Theme.of(context).colorScheme.primary
                                  : const Color(0xFFF1F5F9),
                              foregroundColor: budgetList.isNotEmpty 
                                  ? Colors.white 
                                  : const Color(0xFF94A3B8),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
