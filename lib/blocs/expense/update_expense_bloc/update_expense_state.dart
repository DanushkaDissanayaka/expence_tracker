part of 'update_expense_bloc.dart';

sealed class UpdateExpenseState extends Equatable {
  const UpdateExpenseState();
  
  @override
  List<Object> get props => [];
}

final class UpdateExpenseInitial extends UpdateExpenseState {}
final class UpdateExpenseLoading extends UpdateExpenseState {}
final class UpdateExpenseSuccess extends UpdateExpenseState {}
final class UpdateExpenseFailure extends UpdateExpenseState {
  final String error;

  const UpdateExpenseFailure(this.error);

  @override
  List<Object> get props => [error];
}