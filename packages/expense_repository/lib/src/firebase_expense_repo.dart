import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/entities.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

    @override
    /// Returns a list of TotalExpense, each containing a category, its expenses, and the total amount for that category.
    Future<List<TotalExpense>> getExpensesGroupedByCategory() async {
      try {
        final querySnapshot = await expenseCollection.get();
        final expenses = querySnapshot.docs
            .map((doc) => Expense.fromEntity(ExpenseEntity.fromDocument(doc.data())))
            .toList();

        // Group expenses by categoryId
        final Map<String, List<Expense>> grouped = {};
        for (var expense in expenses) {
          final categoryId = expense.category.categoryId;
          grouped.putIfAbsent(categoryId, () => []).add(expense);
        }

        // Build result with total amount per category
        final List<TotalExpense> result = [];
        for (var entry in grouped.entries) {
          final category = entry.value.first.category;

          final lastTransactionDate = entry.value.isNotEmpty
              ? entry.value.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b)
              : DateTime.now(); // Default to now if no expenses

          final totalAmount = entry.value.fold<int>(0, (sum, e) => sum + e.amount);
          
          result.add(TotalExpense(
            category: category,
            expenses: entry.value,
            totalAmount: totalAmount,
            lastTransactionDate: lastTransactionDate
          ));
        }
        return result;
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
      await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
