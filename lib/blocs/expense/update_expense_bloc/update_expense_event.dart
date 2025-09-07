part of 'update_expense_bloc.dart';

sealed class UpdateExpenseEvent extends Equatable {
  const UpdateExpenseEvent();

  @override
  List<Object> get props => [];
}

class UpdateExpense extends UpdateExpenseEvent {
  final Expense expense;

  const UpdateExpense(this.expense);

  @override
  List<Object> get props => [expense];
}
