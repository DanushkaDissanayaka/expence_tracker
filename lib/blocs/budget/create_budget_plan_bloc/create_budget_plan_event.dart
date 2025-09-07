part of 'create_budget_plan_bloc.dart';

sealed class CreateBudgetPlanEvent extends Equatable {
  const CreateBudgetPlanEvent();

  @override
  List<Object> get props => [];
}

class CreateBudgetPlan extends CreateBudgetPlanEvent {
  final BudgetPlan budgetPlan;

  const CreateBudgetPlan(this.budgetPlan);

  @override
  List<Object> get props => [budgetPlan];
}