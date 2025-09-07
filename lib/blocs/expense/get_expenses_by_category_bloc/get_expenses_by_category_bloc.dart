import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'get_expenses_by_category_event.dart';
part 'get_expenses_by_category_state.dart';

class GetExpensesByCategoryBloc extends Bloc<GetExpensesByCategoryEvent, GetExpensesByCategoryState> {
  final ExpenseRepository expenseRepository;

  GetExpensesByCategoryBloc(this.expenseRepository) : super(GetExpensesByCategoryInitial()) {
    on<GetExpensesByCategoryEvent>((event, emit) async {
      if (event is GetExpensesByCategory) {
        emit(GetExpensesByCategoryLoading());
        try {
          final expenses = await expenseRepository.getExpensesByCategory(event.categoryId);
          emit(GetExpensesByCategorySuccess(expenses));
        } catch (e) {
          emit(GetExpensesByCategoryFailure(e.toString()));
        }
      }
    });
  }
}
