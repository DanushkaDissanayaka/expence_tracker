import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/abstract/balance_repo.dart';
import 'package:expenses_repository/src/entities/entities.dart';
import 'package:expenses_repository/src/models/balance_summary.dart';

class FirebaseBalanceRepo implements BalanceRepository {
  final budgetPlanCollection = FirebaseFirestore.instance.collection('budget_plan');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<BalanceSummary> getBalanceSummary(String? personId) async {
    // get budget plan for current month
    var budgetPlanSnapshot = await budgetPlanCollection
        .where('month', isEqualTo: DateTime.now().month)
        .where('year', isEqualTo: DateTime.now().year)
        .get();
    
    if (budgetPlanSnapshot.docs.isEmpty) {
      // Handle case where no budget plan exists
      return BalanceSummary(
        totalSavings: 0,
        availableExpenseBalance: 0,
        plannedExpenses: 0,
        currentExpenses: 0,
      );
    }

    final budgetPlan = BudgetPlan.fromEntity(BudgetPlanEntity.fromDocument(budgetPlanSnapshot.docs.first.data()));

    // get total expenses for current month
    var expenseQuery = expenseCollection
        .where('date', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, 1))
        .where('date', isLessThan: DateTime(DateTime.now().year, DateTime.now().month + 1, 1));
    
    if (personId != null) {
      expenseQuery = expenseQuery.where('personId', isEqualTo: personId);
    }
    
    final expenses = await expenseQuery
        .get().then((value) => value.docs
          .map((doc) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
          .toList());

    // calculate total expense for current month
    final totalExpenses = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    // get plan expense amount from budget plan
    final planExpenses = budgetPlan.getTotalExpense(personId);
    // calculate available expense balance for current month
    
    return BalanceSummary(
      totalSavings: budgetPlan.getSavingTotal(personId),
      availableExpenseBalance: planExpenses - totalExpenses,
      plannedExpenses: planExpenses,
      currentExpenses: totalExpenses,
    );

  }
}