import 'package:expenses_repository/expense_repository.dart';

class TotalExpenseByCategory {
  final SubCategory category;
  final List<Expense> expenses;
  int totalAmount = 0;
  DateTime? lastTransactionDate;
  final BudgetType budgetType;
  int totalAllocatedAmount = 0;

  TotalExpenseByCategory({
    required this.category,
    required this.expenses,
    required this.budgetType,
    this.lastTransactionDate,
    this.totalAllocatedAmount = 0,
    this.totalAmount = 0,
  });
}
