import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'get_total_expenses_event.dart';
part 'get_total_expenses_state.dart';

class GetTotalExpensesBloc extends Bloc<GetTotalExpensesEvent, GetTotalExpensesState> {
  final ExpenseRepository expenseRepository;
  GetTotalExpensesBloc(this.expenseRepository) : super(GetTotalExpensesInitial()) {
    on<GetTotalExpensesEvent>((event, emit) async {
      emit(GetTotalExpensesLoading());
      try {
        final expenses = await expenseRepository.getExpensesGroupedByCategory();
        emit(GetTotalExpensesSuccess(expenses));
      } catch (e) {
        emit(GetTotalExpensesFailure(e.toString()));
      }
    });
  }
}
