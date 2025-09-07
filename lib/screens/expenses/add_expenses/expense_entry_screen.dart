import 'package:expense_tracker/blocs/expense/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker/blocs/expense/update_expense_bloc/update_expense_bloc.dart';
import 'package:expense_tracker/common/helper/formater_heper.dart';
import 'package:expense_tracker/screens/common/widgets/category_panel.dart';
import 'package:expense_tracker/screens/common/widgets/person_panel.dart';
import 'package:expense_tracker/screens/common/widgets/number_pad.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'segmented.dart';

enum FocusField { none, amount, category, account, person }

class ExpenseEntryScreen extends StatefulWidget {
  final Expense? existingExpense; // Add optional existing expense parameter
  
  const ExpenseEntryScreen({super.key, this.existingExpense});

  @override
  State<ExpenseEntryScreen> createState() => _ExpenseEntryScreenState();
}

class _ExpenseEntryScreenState extends State<ExpenseEntryScreen> {
  final FocusNode noteFocusNode = FocusNode();
  final TextEditingController noteController = TextEditingController();
  BudgetType selectedBudgetType = expenses;
  FocusField focus = FocusField.none;
  bool isLoading = false;
   late Expense expense;

  // Values
  String amount = '';
  SubCategory category = SubCategory.empty();
  String account = '';
  String note = '';
  DateTime selectedDateTime = DateTime.now();
  Person person = persons.first;

  String get formattedDate {
    final date =
        "${selectedDateTime.day.toString().padLeft(2, '0')}/${selectedDateTime.month.toString().padLeft(2, '0')}/${selectedDateTime.year}";
    final weekday = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ][selectedDateTime.weekday - 1];
    return "$date ($weekday)";
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.existingExpense != null) {
      // Editing existing expense
      expense = widget.existingExpense!;
      selectedBudgetType = expense.budgetType;
      amount = expense.amount.toString();
      category = expense.category;
      note = expense.note;
      noteController.text = expense.note; // Set the controller text
      selectedDateTime = expense.date;
      person = expense.person;
    } else {
      // Creating new expense
      expense = Expense.empty;
      expense.expenseId = const Uuid().v1();
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    noteFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectedDateTime = DateTime(date.year, date.month, date.day);
      });
      noteFocusNode.unfocus();
    }
  }

  void _setFocus(FocusField f) {
    if (f == FocusField.amount ||
        f == FocusField.category ||
        f == FocusField.account) {
      FocusScope.of(context).unfocus();
    }
    setState(() => focus = f);
  }

  bool _isFormValid() {
    return amount.trim().isNotEmpty &&
        (selectedBudgetType != expenses || category.categoryId.isNotEmpty);
  }

  void _saveEntry() {
    // Validation logic
    String? error;
    if (amount.trim().isEmpty) {
      error = 'Amount is required.';
    } else if (selectedBudgetType == expenses && category.categoryId.isEmpty) {
      error = 'Category is required.';
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Log all values to the console
    // print('--- Expense Entry ---');
    // print('Type: ${selectedBudgetType.name}');
    // print('Date: $formattedDate');
    // print('Amount: $amount');
    // print('Category: $category');
    // print('Account: $account');
    // print('Note: $note');
    // print('---------------------');
    expense.budgetType = selectedBudgetType;
    expense.date = selectedDateTime;
    expense.amount = (double.tryParse(amount) ?? 0).toInt();
    expense.category = category;
    expense.note = note;
    expense.person = person;
    
    if (widget.existingExpense != null) {
      context.read<UpdateExpenseBloc>().add(UpdateExpense(expense));
    } else {
      context.read<CreateExpenseBloc>().add(CreateExpense(expense));
    }
    // Navigate back or show success message
    Navigator.pop(context);
  }

  Widget _buildFormField({
    required String label,
    required String value,
    required IconData? icon,
    required bool selected,
    required VoidCallback onTap,
    bool isEmpty = false,
  }) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreateExpenseSuccess) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        } else if (state is CreateExpenseFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? selectedBudgetType.color.withValues(alpha: 0.05)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? selectedBudgetType.color : Colors.grey.shade200,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon ?? Icons.category_outlined,
                size: 16,
                color: selected
                    ? selectedBudgetType.color
                    : Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isEmpty ? Colors.grey.shade400 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.keyboard_arrow_up,
                  color: selectedBudgetType.color,
                  size: 18,
                )
              else
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.existingExpense != null 
              ? "Edit ${selectedBudgetType.name}"
              : "Add ${selectedBudgetType.name}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Only close panels if not tapping on the number pad area
          if (focus != FocusField.none) {
            FocusScope.of(context).unfocus();
            _setFocus(FocusField.none);
          }
        },
        child: Column(
          children: [
            // Main form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount input section
                    GestureDetector(
                      onTap: () => _setFocus(FocusField.amount),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: selectedBudgetType.color.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: focus == FocusField.amount
                                ? selectedBudgetType.color
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Amount",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              amount.isEmpty
                                  ? "0.00"
                                  : formatToCurrency(
                                      double.tryParse(amount) ?? 0,
                                    ),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: selectedBudgetType.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Type selector
                    Segmented(
                      id: selectedBudgetType.budgetTypeId,
                      onChanged: (b) => setState(() {
                        selectedBudgetType = b;
                        // Clear category when switching away from expenses (only for new expenses)
                        if (b != expenses && widget.existingExpense == null) {
                          category = SubCategory.empty();
                        }
                        _setFocus(FocusField.none); // Hide any open panels
                        // Only clear amount and note for new expenses
                        if (widget.existingExpense == null) {
                          amount = '';
                          note = '';
                          noteController.clear();
                        }
                      }),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildFormField(
                      label: "Person",
                      value: person.name,
                      icon: person.icon.icon,
                      selected: false,
                      onTap: () => _setFocus(FocusField.person),
                    ),

                    const SizedBox(height: 16),

                    // Form fields
                    _buildFormField(
                      label: "Date",
                      value: formattedDate,
                      icon: Icons.calendar_today_outlined,
                      selected: false,
                      onTap: () {
                        _setFocus(FocusField.none); // Hide number pad first
                        _pickDate();
                      },
                    ),

                    const SizedBox(height: 8),

                    if (selectedBudgetType == expenses) ...[
                      _buildFormField(
                        label: "Category",
                        value: category.isNotEmpty()
                            ? category.name
                            : "Select category",
                        icon: category.isNotEmpty()
                            ? category.icon.icon
                            : Icons.category_outlined,
                        selected: focus == FocusField.category,
                        onTap: () => _setFocus(FocusField.category),
                        isEmpty: !category.isNotEmpty(),
                      ),
                      const SizedBox(height: 8),
                    ],

                    const SizedBox(height: 8),

                    // Note field
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.note_outlined,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Note",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus && focus != FocusField.none) {
                                setState(() => focus = FocusField.none);
                              }
                            },
                            child: TextField(
                              controller: noteController,
                              focusNode: noteFocusNode,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Add a note (optional)",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              maxLines: 2,
                              minLines: 1,
                              onChanged: (v) => setState(() => note = v),
                              onTap: () => _setFocus(
                                FocusField.none,
                              ), // Hide panels when typing note
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Save button at bottom
            if (focus == FocusField.none)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isFormValid() ? _saveEntry : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid()
                        ? selectedBudgetType.color
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.existingExpense != null 
                        ? "Update ${selectedBudgetType.name}"
                        : "Save ${selectedBudgetType.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Bottom panels
            if (focus != FocusField.none)
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: switch (focus) {
                    FocusField.amount => NumberPad(
                      key: const ValueKey('pad'),
                      onAppend: (s) => setState(() {
                        // Handle decimal point
                        if (s == '.' && amount.contains('.')) return;
                        if (s == '.' && amount.isEmpty) {
                          amount = '0.';
                          return;
                        }
                        // Limit decimal places to 2
                        if (amount.contains('.')) {
                          String afterDecimal = amount.split('.')[1];
                          if (afterDecimal.length >= 2 && s != '.') return;
                        }
                        amount += s;
                      }),
                      onDelete: () => setState(() {
                        if (amount.isNotEmpty)
                          amount = amount.substring(0, amount.length - 1);
                      }),
                      onDone: () => _setFocus(FocusField.none),
                    ),
                    FocusField.category => CategoryPanel(
                      key: const ValueKey('cat'),
                      onClose: () => _setFocus(FocusField.none),
                      onPick: (v) => setState(() {
                        category = v;
                        _setFocus(FocusField.none);
                      }),
                    ),
                    FocusField.person => PersonPanel(
                      key: const ValueKey('person'),
                      onClose: () => _setFocus(FocusField.none),
                      onPick: (v) => setState(() {
                        person = v;
                        _setFocus(FocusField.none);
                      }),
                    ),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
