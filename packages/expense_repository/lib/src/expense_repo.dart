import 'package:expenses_repository/expense_repository.dart';

abstract class ExpenseRepository {
    Future<void> createCategory(Category category);    
    Future<List<Category>> getCategories();
}