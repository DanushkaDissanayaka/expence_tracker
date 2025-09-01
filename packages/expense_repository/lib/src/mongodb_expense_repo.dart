// import 'package:mongo_dart/mongo_dart.dart';
import 'package:expenses_repository/expense_repository.dart';

class MongoExpenseRepo implements ExpenseRepository {
  MongoExpenseRepo();

  @override
  Future<List<TotalExpense>> getExpensesGroupedByCategory() async {
    // Implementation goes here
    throw UnimplementedError('getExpensesGroupedByCategory is not implemented');
  }

  @override
  Future<void> createCategory(Category category) async {
    // Implementation goes here
    throw UnimplementedError('createCategory is not implemented');  
  }

  @override
  Future<List<Category>> getCategories() async {
    // Implementation goes here
    throw UnimplementedError('getCategories is not implemented'); 
  }
  
  @override
  Future<void> createExpense(Expense expense) {
    // TODO: implement createExpense
    throw UnimplementedError();
  }

  @override
  Future<void> updateExpense(Expense expense) {
    // TODO: implement updateExpense
    throw UnimplementedError();
  }

  @override
  Future<void> deleteExpense(String expenseId) {
    // TODO: implement deleteExpense
    throw UnimplementedError();
  }
  
  @override
  Future<List<Expense>> getExpenses() {
    // TODO: implement getExpenses
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) {
    // TODO: implement getExpensesByCategory
    throw UnimplementedError();
  }
}
