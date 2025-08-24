import 'package:expenses_repository/src/models/budget_plan.dart';

abstract class BudgetRepository {
  Future<void> createBudgetPlan(BudgetPlan budget);
  Future<void> updateBudgetPlan(BudgetPlan budgetPlan);
  Future<List<BudgetPlan>> getBudgetPlans(String budgetPlanId);
}
