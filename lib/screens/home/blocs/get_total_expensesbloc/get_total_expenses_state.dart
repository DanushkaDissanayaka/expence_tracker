part of 'get_total_expenses_bloc.dart';

sealed class GetTotalExpensesState extends Equatable {
  const GetTotalExpensesState();
  
  @override
  List<Object> get props => [];
}

final class GetTotalExpensesInitial extends GetTotalExpensesState {}

final class GetTotalExpensesFailure extends GetTotalExpensesState {
  final String error;

  const GetTotalExpensesFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class GetTotalExpensesSuccess extends GetTotalExpensesState {
  final List<TotalExpense> expenses;

  const GetTotalExpensesSuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}

final class GetTotalExpensesLoading extends GetTotalExpensesState {}
