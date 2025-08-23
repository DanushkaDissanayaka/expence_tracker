import 'package:expenses_repository/expense_repository.dart';

class BudgetPlan {
  Person person;
  final BudgetType budgetType;
  double amount;
  final SubCategory mainCategory;
  final SubCategory subCategory;

  BudgetPlan({
    required this.person,
    required this.budgetType,
    required this.amount,
    required this.mainCategory,
    required this.subCategory,
  });
}