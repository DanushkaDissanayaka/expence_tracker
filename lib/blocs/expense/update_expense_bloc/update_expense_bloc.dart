import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'update_expense_event.dart';
part 'update_expense_state.dart';

class UpdateExpenseBloc extends Bloc<UpdateExpenseEvent, UpdateExpenseState> {
  final ExpenseRepository expenseRepository;

  UpdateExpenseBloc(this.expenseRepository) : super(UpdateExpenseInitial()) {
    on<UpdateExpense>((event, emit) async {
      emit(UpdateExpenseLoading());
      try {
        await expenseRepository.updateExpense(event.expense);
        emit(UpdateExpenseSuccess());
      } catch (e) {
        emit(UpdateExpenseFailure(e.toString()));
      }
    });
  }
}
