part of 'create_budget_plan_bloc.dart';

sealed class CreateBudgetPlanState extends Equatable {
  const CreateBudgetPlanState();
  
  @override
  List<Object> get props => [];
}

final class CreateBudgetPlanInitial extends CreateBudgetPlanState {}
final class CreateBudgetPlanLoading extends CreateBudgetPlanState {}
final class CreateBudgetPlanSuccess extends CreateBudgetPlanState {}
final class CreateBudgetPlanFailure extends CreateBudgetPlanState {
  final String error;

  const CreateBudgetPlanFailure(this.error);

  @override
  List<Object> get props => [error];
}
