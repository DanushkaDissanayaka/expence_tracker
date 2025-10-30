part of 'get_cumulative_expenses_bloc.dart';

abstract class GetCumulativeExpensesState extends Equatable {
  const GetCumulativeExpensesState();
  
  @override
  List<Object> get props => [];
}

class GetCumulativeExpensesInitial extends GetCumulativeExpensesState {}

class GetCumulativeExpensesLoading extends GetCumulativeExpensesState {}

class GetCumulativeExpensesSuccess extends GetCumulativeExpensesState {
  final Map<int, double> cumulativeExpenses;
  final DateTime billingPeriodStart;

  const GetCumulativeExpensesSuccess(this.cumulativeExpenses, this.billingPeriodStart);

  @override
  List<Object> get props => [cumulativeExpenses, billingPeriodStart];
}

class GetCumulativeExpensesFailure extends GetCumulativeExpensesState {
  final String error;

  const GetCumulativeExpensesFailure(this.error);

  @override
  List<Object> get props => [error];
}
