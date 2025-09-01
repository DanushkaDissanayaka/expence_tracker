import 'package:expenses_repository/expense_repository.dart';

abstract class ExpenseRepository {
    Future<void> createCategory(Category category);    
    Future<List<Category>> getCategories();
    Future<List<Expense>> getExpenses();
    Future<void> createExpense(Expense expense);
    Future<void> updateExpense(Expense expense);
    Future<void> deleteExpense(String expenseId);
    Future<List<TotalExpense>> getExpensesGroupedByCategory();
    Future<List<Expense>> getExpensesByCategory(String categoryId);
}