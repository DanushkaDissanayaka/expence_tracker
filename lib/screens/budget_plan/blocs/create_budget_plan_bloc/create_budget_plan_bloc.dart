import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'create_budget_plan_event.dart';
part 'create_budget_plan_state.dart';

class CreateBudgetPlanBloc extends Bloc<CreateBudgetPlanEvent, CreateBudgetPlanState> {
  final BudgetRepository budgetRepository;

  CreateBudgetPlanBloc(this.budgetRepository) : super(CreateBudgetPlanInitial()) {
    on<CreateBudgetPlan>((event, emit) async {
      emit(CreateBudgetPlanLoading());
      try {
        await budgetRepository.createBudgetPlan(event.budgetPlan);
        emit(CreateBudgetPlanSuccess());
      } catch (e) {
        emit(CreateBudgetPlanFailure(e.toString()));
      }
    });
  }
}
