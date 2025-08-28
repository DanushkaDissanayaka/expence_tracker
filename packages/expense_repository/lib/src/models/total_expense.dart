import 'package:expenses_repository/expense_repository.dart';

class TotalExpense {
  final SubCategory category;
  final List<Expense> expenses;
  final int totalAmount;
  final DateTime lastTransactionDate;
  final BudgetType budgetType;

  TotalExpense({
    required this.category,
    required this.expenses,
    required this.totalAmount,
    required this.lastTransactionDate,
    required this.budgetType,
  });
}
