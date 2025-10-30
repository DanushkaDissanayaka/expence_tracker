part of 'get_daily_expenses_bloc.dart';

sealed class GetDailyExpensesEvent extends Equatable {
  const GetDailyExpensesEvent();

  @override
  List<Object> get props => [];
}

class GetDailyExpenses extends GetDailyExpensesEvent {}
