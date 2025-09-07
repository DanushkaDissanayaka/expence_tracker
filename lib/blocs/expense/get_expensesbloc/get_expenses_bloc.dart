import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'get_expenses_event.dart';
part 'get_expenses_state.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  final ExpenseRepository expenseRepository;

  GetExpensesBloc(this.expenseRepository) : super(GetExpensesInitial()) {
    on<GetExpensesEvent>((event, emit) async {
      emit(GetExpensesLoading());
      try {
        final expenses = await expenseRepository.getExpenses();
        emit(GetExpensesSuccess(expenses));
      } catch (e) {
        emit(GetExpensesFailure(e.toString()));
      }
    });
  }
}
