part of 'get_expenses_by_category_bloc.dart';

sealed class GetExpensesByCategoryEvent extends Equatable {
  const GetExpensesByCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetExpensesByCategory extends GetExpensesByCategoryEvent {
  final String categoryId;

  const GetExpensesByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}