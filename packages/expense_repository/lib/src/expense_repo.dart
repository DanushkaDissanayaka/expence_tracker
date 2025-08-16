import 'package:expenses_repository/expense_repository.dart';

abstract class ExpenseRepository {
    Future<void> createCategory(Category category);    
    Future<List<Category>> getCategories();
    Future<List<Expense>> getExpenses();
    Future<void> createExpense(Expense expense);
}