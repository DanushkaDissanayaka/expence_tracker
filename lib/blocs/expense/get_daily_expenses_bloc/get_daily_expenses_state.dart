part of 'get_daily_expenses_bloc.dart';

sealed class GetDailyExpensesState extends Equatable {
  const GetDailyExpensesState();
  
  @override
  List<Object> get props => [];
}

final class GetDailyExpensesInitial extends GetDailyExpensesState {}

final class GetDailyExpensesLoading extends GetDailyExpensesState {}

final class GetDailyExpensesSuccess extends GetDailyExpensesState {
  final Map<int, double> dailyExpenses;
  final DateTime billingPeriodStart;

  const GetDailyExpensesSuccess(this.dailyExpenses, this.billingPeriodStart);

  @override
  List<Object> get props => [dailyExpenses, billingPeriodStart];
}

final class GetDailyExpensesFailure extends GetDailyExpensesState {
  final String error;

  const GetDailyExpensesFailure(this.error);

  @override
  List<Object> get props => [error];
}
