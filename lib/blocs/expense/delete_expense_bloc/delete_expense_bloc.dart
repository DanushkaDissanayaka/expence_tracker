import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'delete_expense_event.dart';
part 'delete_expense_state.dart';

class DeleteExpenseBloc extends Bloc<DeleteExpenseEvent, DeleteExpenseState> {
  final ExpenseRepository expenseRepository;

  DeleteExpenseBloc(this.expenseRepository) : super(DeleteExpenseInitial()) {
    on<DeleteExpense>((event, emit) async {
      emit(DeleteExpenseLoading());
      try {
        await expenseRepository.deleteExpense(event.expenseId);
        emit(DeleteExpenseSuccess());
      } catch (e) {
        emit(DeleteExpenseFailure(e.toString()));
      }
    });
  }
}
