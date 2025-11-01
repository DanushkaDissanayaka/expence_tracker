import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/entities.dart';
import 'package:expenses_repository/src/helpers/datetime_helper.dart';

class FirebaseBalanceRepo implements BalanceRepository {
  final budgetPlanCollection = FirebaseFirestore.instance.collection('budget_plan');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<BalanceSummary> getBalanceSummary(String? personId) async {
    // get budget plan for current month
    var budgetPlanSnapshot = await budgetPlanCollection
        .where('month', isEqualTo: DatetimeHelper.getCurrentBillingMonth())
        .where('year', isEqualTo: DatetimeHelper.getCurrentBillingYear())
        .get();
    
    if (budgetPlanSnapshot.docs.isEmpty) {
      // Handle case where no budget plan exists
      return BalanceSummary(
        totalSavings: 0,
        availableExpenseBalance: 0,
        plannedExpenses: 0,
        currentExpenses: 0,
        unplannedExpenses: 0,
        unplannedExpenseCategoriesCount: 0,
        overExpenses: 0,
        overExpenseCategoriesCount: 0,
      );
    }

    final budgetPlan = BudgetPlan.fromEntity(BudgetPlanEntity.fromDocument(budgetPlanSnapshot.docs.first.data()));

    // get total expenses for current month
    var currentBillingPeriod = DatetimeHelper.getCurrentBillingPeriod();

    var expenseQuery = expenseCollection
        .where('date', isGreaterThanOrEqualTo: currentBillingPeriod.start)
        .where('date', isLessThan: currentBillingPeriod.end);

    if (personId != null) {
      expenseQuery = expenseQuery.where('personId', isEqualTo: personId);
    }
    
    final expensesList = await expenseQuery
        .get().then((value) => value.docs
          .map((doc) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
          .toList());

    // calculate total expense for current month
    final totalExpenses = expensesList.fold<double>(0, (sum, e) => sum + e.amount);

    // get plan expense amount from budget plan
    final planExpenses = budgetPlan.getTotalExpense(personId);
    // calculate available expense balance for current month

      // calculate unplanned expenses
      
      // Group budget expenses by categoryId
      final Map<String, List<Budget>> groupedBudget = {};
      for (var budget in budgetPlan.budgetPlan) {
        if(budget.budgetType.budgetTypeId != expenses.budgetTypeId) continue;
        final categoryId =
            budget.subCategory.categoryId + budget.budgetType.budgetTypeId;
        groupedBudget.putIfAbsent(categoryId, () => []).add(budget);
      }

      // Group expenses by categoryId
      final Map<String, List<Expense>> groupedExpenses = {};
      for (var exp in expensesList) {
        final categoryId =
            exp.category.categoryId + exp.budgetType.budgetTypeId;
        groupedExpenses.putIfAbsent(categoryId, () => []).add(exp);
      }

      double overExpenses = 0;
      int overExpenseCategoriesCount = 0;

      for (var budget in groupedBudget.entries) {
        final totalBudgetAmount = budget.value.fold<double>(0, (sum, e) => sum + e.amount);
        final currentExpenses = groupedExpenses[budget.key] ?? [];
        final totalSpentAmount = currentExpenses.fold<double>(0, (sum, e) => sum + e.amount) ?? 0;
        
        if (totalSpentAmount > totalBudgetAmount) {
          // over budgeted amount
          // take the extra amount as unplanned expenses
          double extraAmount = totalSpentAmount - totalBudgetAmount;
          // add to unplanned expenses
          overExpenses += extraAmount;
          overExpenseCategoriesCount += 1;
        }
      }

      // take the expense not in budget plan
      double totalUnplannedExpenses = 0;
      int unplannedExpenseCategoriesCount = 0;

      for (var entry in groupedExpenses.entries) {
        if(groupedBudget.containsKey(entry.key)) continue; // already in the budget plan
        totalUnplannedExpenses = totalUnplannedExpenses + entry.value.fold<double>(0, (sum, e) => sum + e.amount);
        unplannedExpenseCategoriesCount += 1;
      }

      

    return BalanceSummary(
      totalSavings: budgetPlan.getSavingTotal(personId),
      availableExpenseBalance: planExpenses - totalExpenses,
      plannedExpenses: planExpenses,
      currentExpenses: totalExpenses,
      unplannedExpenses: totalUnplannedExpenses,
      unplannedExpenseCategoriesCount: unplannedExpenseCategoriesCount,
      overExpenses: overExpenses,
      overExpenseCategoriesCount: overExpenseCategoriesCount,
    );

  }
}