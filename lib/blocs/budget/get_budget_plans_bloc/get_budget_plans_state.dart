part of 'get_budget_plans_bloc.dart';

sealed class GetBudgetPlansState extends Equatable {
  const GetBudgetPlansState();
  
  @override
  List<Object> get props => [];
}

final class GetBudgetPlansInitial extends GetBudgetPlansState {}
final class GetBudgetPlansLoading extends GetBudgetPlansState {}
final class GetBudgetPlansSuccess extends GetBudgetPlansState {
  final List<BudgetPlan> budgetPlans;

  const GetBudgetPlansSuccess(this.budgetPlans);

  @override
  List<Object> get props => [budgetPlans];
}
final class GetBudgetPlansFailure extends GetBudgetPlansState {
  final String error;

  const GetBudgetPlansFailure(this.error);

  @override
  List<Object> get props => [error];
}