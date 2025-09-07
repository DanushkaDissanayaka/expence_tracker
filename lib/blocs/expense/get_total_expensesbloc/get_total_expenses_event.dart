part of 'get_total_expenses_bloc.dart';

sealed class GetTotalExpensesEvent extends Equatable {
  const GetTotalExpensesEvent();

  @override
  List<Object> get props => [];
}

class GetTotalExpenses extends GetTotalExpensesEvent {}
