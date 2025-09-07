import 'package:expense_tracker/blocs/expense/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker/screens/expenses/add_expenses/expense_entry_screen.dart';
import 'package:expense_tracker/common/helper/formater_heper.dart';
import 'package:expense_tracker/blocs/expense/get_expenses_by_category_bloc/get_expenses_by_category_bloc.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ViewExpensesByCategory extends StatefulWidget {
  final TotalExpense totalExpense;

  const ViewExpensesByCategory({super.key, required this.totalExpense});

  @override
  State<ViewExpensesByCategory> createState() => _ViewExpensesByCategoryState();
}

class _ViewExpensesByCategoryState extends State<ViewExpensesByCategory> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    // Fetch expenses for this category when screen loads
    context.read<GetExpensesByCategoryBloc>().add(
      GetExpensesByCategory(widget.totalExpense.category.categoryId),
    );
  }

  double calculateTotalExpenseAmount() {
    final double totalExpenses = expenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );
    return totalExpenses;
  }

  String _getTotalExpenses() {
    return formatToCurrency(calculateTotalExpenseAmount());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          // Refresh the expenses list after successful create/update/delete
          context.read<GetExpensesByCategoryBloc>().add(
            GetExpensesByCategory(widget.totalExpense.category.categoryId),
          );
        } else if (state is CreateExpenseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Light background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.totalExpense.category.name.isEmpty
                    ? 'Uncategorized'
                    : widget.totalExpense.category.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              BlocBuilder<
                GetExpensesByCategoryBloc,
                GetExpensesByCategoryState
              >(
                builder: (context, state) {
                  if (state is GetExpensesByCategorySuccess) {
                    return Text(
                      'Total: ${_getTotalExpenses()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<GetExpensesByCategoryBloc, GetExpensesByCategoryState>(
          builder: (context, state) {
              if(state is GetExpensesByCategoryLoading) {
                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
              } else if(state is GetExpensesByCategorySuccess) {
                expenses = state.expenses;
                return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Summary Card
                      _buildCategorySummaryCard(context),
                      const SizedBox(height: 24),
                      // Expenses List Header
                      _buildExpensesHeader(),
                      const SizedBox(height: 16),
                      // Expenses List
                      Expanded(child: _buildExpensesList()),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
            
          },
        ),
      ),
    );
  }

  Widget _buildCategorySummaryCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.totalExpense.budgetType.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.totalExpense.budgetType.color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Category Icon and Name
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.totalExpense.budgetType.color.withValues(
                    alpha: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.totalExpense.category.isNotEmpty()
                      ? widget.totalExpense.category.icon.icon
                      : Icons.category_outlined,
                  color: widget.totalExpense.budgetType.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.totalExpense.category.name.isEmpty
                          ? 'Uncategorized'
                          : widget.totalExpense.category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${expenses.length} transaction${expenses.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Total Amount
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Spent',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getTotalExpenses(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: widget.totalExpense.budgetType.color,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesHeader() {
    return Row(
      children: [
        const Text(
          'Transaction History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_outlined, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.delete_outline, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Delete',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editExpense(Expense expense) {
    final createExpenseBloc = BlocProvider.of<CreateExpenseBloc>(context);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: createExpenseBloc,
              child: ExpenseEntryScreen(existingExpense: expense),
            ),
          ),
        );
  }

  void _showDeleteConfirmation(Expense expense) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Expense',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to delete this expense?',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      expense.category.isNotEmpty()
                          ? expense.category.icon.icon
                          : Icons.category_outlined,
                      color: expense.budgetType.color,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.note.isEmpty ? 'No note' : expense.note,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            DateFormat('MMM d, y').format(expense.date),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatToCurrency(expense.amount.toDouble()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<CreateExpenseBloc>().add(
                  DeleteExpense(expense.expenseId),
                );
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Yes, Delete',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpensesList() {
          if (expenses.isEmpty) {
            return _buildEmptyState();
          }

          // Group expenses by date
          Map<String, List<Expense>> groupedExpenses = {};
          for (var expense in expenses) {
            String dateKey = DateFormat('yyyy-MM-dd').format(expense.date);
            groupedExpenses.putIfAbsent(dateKey, () => []).add(expense);
          }

          // Sort dates in descending order
          var sortedDates = groupedExpenses.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.separated(
            itemCount: sortedDates.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              String dateKey = sortedDates[index];
              List<Expense> dayExpenses = groupedExpenses[dateKey]!;

              // Calculate daily total
              int dailyTotal = dayExpenses.fold(
                0,
                (sum, expense) => sum + expense.amount,
              );

              return _buildDayExpensesGroup(dateKey, dayExpenses, dailyTotal);
            },
          );
  }

  Widget _buildDayExpensesGroup(
    String dateKey,
    List<Expense> expenses,
    int dailyTotal,
  ) {
    DateTime date = DateTime.parse(dateKey);
    String formattedDate = DateFormat('EEEE, MMM d, y').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  formatToCurrency(dailyTotal.toDouble()),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Expenses for this day
        ...expenses.map((expense) => _buildExpenseItem(expense)),
      ],
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category Icon
          GestureDetector(
            onTap: () => _editExpense(expense),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: expense.budgetType.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                expense.category.isNotEmpty()
                    ? expense.category.icon.icon
                    : Icons.category_outlined,
                color: expense.budgetType.color,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Expense Details (tappable for edit)
          Expanded(
            child: GestureDetector(
              onTap: () => _editExpense(expense),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.note.isEmpty ? 'No note' : expense.note,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        expense.person.name,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Amount and action buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatToCurrency(expense.amount.toDouble()),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expense.budgetType.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: expense.budgetType.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _editExpense(expense),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _showDeleteConfirmation(expense),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFF6366F1),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No expenses found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No expenses recorded for this category yet',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Color(0xFFEF4444),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load expenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Error: $error',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<GetExpensesByCategoryBloc>().add(
                GetExpensesByCategory(widget.totalExpense.category.categoryId),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
