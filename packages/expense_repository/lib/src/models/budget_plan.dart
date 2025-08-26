
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/entities.dart';

class BudgetPlan {
  String budgetPlanId;
  final int month;
  final int year;
  final List<Budget> budgetPlan;

  BudgetPlan({
    required this.budgetPlanId,
    required this.month,
    required this.year,
    required this.budgetPlan,
  });

  BudgetPlanEntity toEntity() {
    return BudgetPlanEntity(
      budgetPlanId: budgetPlanId,
      month: month,
      year: year,
      budgetPlan: budgetPlan.map((e) => e.toEntity()).toList(),
    );
  }

  factory BudgetPlan.fromEntity(BudgetPlanEntity entity) {
    return BudgetPlan(
      budgetPlanId: entity.budgetPlanId,
      month: entity.month,
      year: entity.year,
      budgetPlan: entity.budgetPlan.map((e) => Budget.fromEntity(e)).toList(),
    );
  }
}