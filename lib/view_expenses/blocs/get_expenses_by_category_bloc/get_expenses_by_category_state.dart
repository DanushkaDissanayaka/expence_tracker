part of 'get_expenses_by_category_bloc.dart';

sealed class GetExpensesByCategoryState extends Equatable {
  const GetExpensesByCategoryState();
  
  @override
  List<Object> get props => [];
}

final class GetExpensesByCategoryInitial extends GetExpensesByCategoryState {}
final class GetExpensesByCategoryLoading extends GetExpensesByCategoryState {}
final class GetExpensesByCategorySuccess extends GetExpensesByCategoryState {
  final List<Expense> expenses;

  const GetExpensesByCategorySuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}
final class GetExpensesByCategoryFailure extends GetExpensesByCategoryState {
  final String error;

  const GetExpensesByCategoryFailure(this.error);

  @override
  List<Object> get props => [error];
}
