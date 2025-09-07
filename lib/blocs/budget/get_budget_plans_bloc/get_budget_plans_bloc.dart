import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'get_budget_plans_event.dart';
part 'get_budget_plans_state.dart';

class GetBudgetPlansBloc extends Bloc<GetBudgetPlansEvent, GetBudgetPlansState> {
  final BudgetRepository budgetRepository;
  GetBudgetPlansBloc(this.budgetRepository) : super(GetBudgetPlansInitial()) {
    on<GetBudgetPlansEvent>((event, emit) async {
      emit(GetBudgetPlansLoading());
      try {
        final budgetPlans = await budgetRepository.getBudgetPlans();
        emit(GetBudgetPlansSuccess(budgetPlans));
      } catch (e) {
        emit(GetBudgetPlansFailure(e.toString()));
      }
    });
  }
}
