
import 'package:expenses_repository/src/entities/entities.dart';

class BudgetPlanEntity {
  final String budgetPlanId;
  final int month;
  final int year;
  final List<BudgetEntity> budgetPlan;

  BudgetPlanEntity({
    required this.budgetPlanId,
    required this.month,
    required this.year,
    required this.budgetPlan,
  });
  
  Map<String, Object> toDocument() {
    return {
      'budgetPlanId': budgetPlanId,
      'month': month,
      'year': year,
      'budgetPlan': budgetPlan.map((e) => e.toDocument()).toList(),
    };
  }

  factory BudgetPlanEntity.fromDocument(Map<String, dynamic> doc) {
    return BudgetPlanEntity(
      budgetPlanId: doc['budgetPlanId'] as String,
      month: doc['month'] as int,
      year: doc['year'] as int,
      budgetPlan: (doc['budgetPlan'] as List)
          .map((e) => BudgetEntity.fromDocument(e as Map<String, Object>))
          .toList(),
    );
  }
}