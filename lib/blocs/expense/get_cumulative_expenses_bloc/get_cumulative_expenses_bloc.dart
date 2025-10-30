import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/helpers/datetime_helper.dart';

part 'get_cumulative_expenses_event.dart';
part 'get_cumulative_expenses_state.dart';

class GetCumulativeExpensesBloc extends Bloc<GetCumulativeExpensesEvent, GetCumulativeExpensesState> {
  final ExpenseRepository expenseRepository;
  
  GetCumulativeExpensesBloc(this.expenseRepository) : super(GetCumulativeExpensesInitial()) {
    on<GetCumulativeExpenses>((event, emit) async {
      emit(GetCumulativeExpensesLoading());
      try {
        final cumulativeExpenses = await expenseRepository.getCumulativeExpensesForCurrentBillingPeriod();
        final billingPeriod = DatetimeHelper.getCurrentBillingPeriod();
        emit(GetCumulativeExpensesSuccess(cumulativeExpenses, billingPeriod.start));
      } catch (e) {
        emit(GetCumulativeExpensesFailure(e.toString()));
      }
    });
  }
}
