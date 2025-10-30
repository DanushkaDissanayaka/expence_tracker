part of 'get_cumulative_expenses_bloc.dart';

abstract class GetCumulativeExpensesEvent extends Equatable {
  const GetCumulativeExpensesEvent();

  @override
  List<Object> get props => [];
}

class GetCumulativeExpenses extends GetCumulativeExpensesEvent {}
