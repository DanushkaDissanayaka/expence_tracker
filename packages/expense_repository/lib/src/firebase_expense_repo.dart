import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/entities.dart';
import 'package:expenses_repository/src/helpers/datetime_helper.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override

  /// Returns a list of TotalExpense, each containing a category, its expenses, and the total amount for that category.
  Future<List<TotalExpense>> getExpensesGroupedByCategory() async {
    final currentBillingPeriod = DatetimeHelper.getCurrentBillingPeriod();
    try {
      final querySnapshot = await expenseCollection
          .where('date', isGreaterThanOrEqualTo: currentBillingPeriod.start)
          .where('date', isLessThan: currentBillingPeriod.end)
          .get();


      final expensesAndIncome = querySnapshot.docs
          .map((doc) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
          .toList();
      final expensesList = expensesAndIncome
          .where((e) => e.budgetType.budgetTypeId == expenses.budgetTypeId)
          .toList();
      final incomeList = expensesAndIncome
          .where((e) => e.budgetType.budgetTypeId == income.budgetTypeId)
          .toList();
      // Group expenses by categoryId
      final Map<String, List<Expense>> grouped = {};
      for (var exp in expensesList) {
        final categoryId =
            exp.category.categoryId + exp.budgetType.budgetTypeId;
        grouped.putIfAbsent(categoryId, () => []).add(exp);
      }

      // Build result with total amount per category
      final List<TotalExpense> result = [];
      for (var entry in grouped.entries) {
        final category = entry.value.first.category;

        final lastTransactionDate = entry.value.isNotEmpty
            ? entry.value
                .map((e) => e.date)
                .reduce((a, b) => a.isAfter(b) ? a : b)
            : DateTime.now(); // Default to now if no expenses

        final totalAmount =
            entry.value.fold<int>(0, (sum, e) => sum + e.amount);

        result.add(TotalExpense(
          category: category,
          expenses: entry.value,
          totalAmount: totalAmount,
          lastTransactionDate: lastTransactionDate,
          budgetType: entry.value.first.budgetType,
        ));
      }

      for (var entry in incomeList) {
        result.add(TotalExpense(
          category: entry.category,
          expenses: [entry],
          totalAmount: entry.amount,
          lastTransactionDate: entry.date,
          budgetType: entry.budgetType,
        ));
      }

      result.sort((a, b) => b.lastTransactionDate.compareTo(a.lastTransactionDate));

      return result;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  /// Returns a list of expenses for a given categoryId.
  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) async {
      try {
        final currentBillingPeriod = DatetimeHelper.getCurrentBillingPeriod();
        final querySnapshot = await expenseCollection
            .where('categoryId', isEqualTo: categoryId)
            .where('date', isGreaterThanOrEqualTo: currentBillingPeriod.start)
            .where('date', isLessThan: currentBillingPeriod.end)
            .get();
        return querySnapshot.docs
            .map((doc) => Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
            .toList();
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }

  @override
  Future<void> updateExpense(Expense expense) async {
    try {
      await expenseCollection
          .doc(expense.expenseId)
          .update(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await expenseCollection.doc(expenseId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await categoryCollection.get().then((value) => value.docs
          .map((doc) =>
              Category.fromEntity(CategoryEntity.fromDocument(doc.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await expenseCollection.get().then((value) => value.docs
          .map((doc) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }



  @override
  Future<void> createExpense(Expense expense) async {
    try {
      return await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<int, double>> getDailyExpensesForCurrentBillingPeriod() async {
    final currentBillingPeriod = DatetimeHelper.getCurrentBillingPeriod();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    try {
      final querySnapshot = await expenseCollection
          .where('date', isGreaterThanOrEqualTo: currentBillingPeriod.start)
          .where('date', isLessThan: currentBillingPeriod.end)
          .get();

      final expensesAndIncome = querySnapshot.docs
          .map((doc) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
          .toList();

      // Filter only expenses (not income)
      final expensesList = expensesAndIncome
          .where((e) => e.budgetType.budgetTypeId == expenses.budgetTypeId)
          .toList();

      // Group by day and sum amounts
      final Map<int, double> dailyExpenses = {};
      
      // Calculate number of days from billing start to today (not the full billing period)
      final daysUntilToday = today.difference(currentBillingPeriod.start).inDays + 1;
      final days = daysUntilToday > 0 ? daysUntilToday : 1;
      
      // Initialize only days up to today with 0
      for (int i = 1; i <= days; i++) {
        dailyExpenses[i] = 0.0;
      }

      // Sum expenses by day (only for days up to today)
      for (var expense in expensesList) {
        final expenseDate = DateTime(expense.date.year, expense.date.month, expense.date.day);
        if (expenseDate.isAfter(today)) continue; // Skip future expenses
        
        final dayNumber = expense.date.difference(currentBillingPeriod.start).inDays + 1;
        if (dayNumber >= 1 && dayNumber <= days) {
          dailyExpenses[dayNumber] = (dailyExpenses[dayNumber] ?? 0.0) + (expense.amount);
        }
      }

      return dailyExpenses;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<int, double>> getCumulativeExpensesForCurrentBillingPeriod() async {
    final currentBillingPeriod = DatetimeHelper.getCurrentBillingPeriod();
    
    try {
      final querySnapshot = await expenseCollection
          .where('date', isGreaterThanOrEqualTo: currentBillingPeriod.start)
          .where('date', isLessThan: currentBillingPeriod.end)
          .get();

      final expensesAndIncome = querySnapshot.docs
          .map((doc) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
          .toList();

      // Filter only expenses (not income)
      final expensesList = expensesAndIncome
          .where((e) => e.budgetType.budgetTypeId == expenses.budgetTypeId)
          .toList();

      // Group by day and sum amounts
      final Map<int, double> dailyExpenses = {};
      
      // Calculate number of days in FULL billing period
      final days = currentBillingPeriod.end.difference(currentBillingPeriod.start).inDays;
      
      // Initialize ALL days in billing period with 0
      for (int i = 1; i <= days; i++) {
        dailyExpenses[i] = 0.0;
      }

      // Sum expenses by day for all days (including future)
      for (var expense in expensesList) {
        final dayNumber = expense.date.difference(currentBillingPeriod.start).inDays + 1;
        if (dayNumber >= 1 && dayNumber <= days) {
          dailyExpenses[dayNumber] = (dailyExpenses[dayNumber] ?? 0.0) + (expense.amount);
        }
      }

      return dailyExpenses;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
