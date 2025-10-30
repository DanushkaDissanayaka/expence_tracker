import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/helpers/datetime_helper.dart';

part 'get_daily_expenses_event.dart';
part 'get_daily_expenses_state.dart';

class GetDailyExpensesBloc extends Bloc<GetDailyExpensesEvent, GetDailyExpensesState> {
  final ExpenseRepository expenseRepository;
  
  GetDailyExpensesBloc(this.expenseRepository) : super(GetDailyExpensesInitial()) {
    on<GetDailyExpenses>((event, emit) async {
      emit(GetDailyExpensesLoading());
      try {
        final dailyExpenses = await expenseRepository.getDailyExpensesForCurrentBillingPeriod();
        final billingPeriod = DatetimeHelper.getCurrentBillingPeriod();
        emit(GetDailyExpensesSuccess(dailyExpenses, billingPeriod.start));
      } catch (e) {
        emit(GetDailyExpensesFailure(e.toString()));
      }
    });
  }
}
