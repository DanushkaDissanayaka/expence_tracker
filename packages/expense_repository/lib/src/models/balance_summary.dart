class BalanceSummary {
  final double totalSavings;
  final double availableExpenseBalance;
  final double plannedExpenses;
  final double currentExpenses;
  final double unplannedExpenses;
  final int unplannedExpenseCategoriesCount;
  final double overExpenses;
  final int overExpenseCategoriesCount;

  BalanceSummary({
    required this.totalSavings,
    required this.availableExpenseBalance,
    required this.plannedExpenses,
    required this.currentExpenses,
    required this.unplannedExpenses,
    required this.unplannedExpenseCategoriesCount,
    required this.overExpenses,
    required this.overExpenseCategoriesCount,
  });
}
