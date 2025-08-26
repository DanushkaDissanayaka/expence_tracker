import 'package:expenses_repository/expense_repository.dart';

double getExpenseTotal(List<Budget> budgetList, String? personId) {
  return budgetList
      .where(
        (b) =>
            b.budgetType.budgetTypeId == expenses.budgetTypeId &&
            (personId == null || b.person.personId == personId),
      )
      .fold(0.0, (sum, b) => sum + b.amount);
}

double getIncomeTotal(List<Budget> budgetList, String? personId) {
  return budgetList
      .where(
        (b) =>
            b.budgetType.budgetTypeId == income.budgetTypeId &&
            (personId == null || b.person.personId == personId),
      )
      .fold(0.0, (sum, b) => sum + b.amount);
}

double getSavingTotal(List<Budget> budgetList, String? personId) {
  return budgetList
      .where(
        (b) =>
            b.budgetType.budgetTypeId == saving.budgetTypeId &&
            (personId == null || b.person.personId == personId),
      )
      .fold(0.0, (sum, b) => sum + b.amount);
}


double getTotalBudget(List<Budget> budgetList, String? personId) {
  final expenseTotal = getExpenseTotal(budgetList, personId);
  final incomeTotal = getIncomeTotal(budgetList, personId);
  final savingTotal = getSavingTotal(budgetList, personId);
  return incomeTotal - (expenseTotal + savingTotal);
}
