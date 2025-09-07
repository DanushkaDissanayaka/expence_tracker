part of 'delete_expense_bloc.dart';

sealed class DeleteExpenseState extends Equatable {
  const DeleteExpenseState();
  
  @override
  List<Object> get props => [];
}

final class DeleteExpenseInitial extends DeleteExpenseState {}
final class DeleteExpenseLoading extends DeleteExpenseState {}
final class DeleteExpenseSuccess extends DeleteExpenseState {}
final class DeleteExpenseFailure extends DeleteExpenseState {
  final String error;

  const DeleteExpenseFailure(this.error);

  @override
  List<Object> get props => [error];
}
