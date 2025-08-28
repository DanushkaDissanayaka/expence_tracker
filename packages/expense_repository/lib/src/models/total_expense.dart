import 'package:expenses_repository/expense_repository.dart';

class TotalExpense {
  final SubCategory category;
  final List<Expense> expenses;
  final int totalAmount;
  final DateTime lastTransactionDate;

  TotalExpense({
    required this.category,
    required this.expenses,
    required this.totalAmount,
    required this.lastTransactionDate,
  });
}
