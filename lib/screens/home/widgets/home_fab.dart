import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/add_expenses/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_tracker/add_expenses/blocs/create_expensebloc/create_expense_bloc.dart';
import 'package:expense_tracker/add_expenses/blocs/get_categoriesbloc/get_categories_bloc.dart';
import 'package:expense_tracker/add_expenses/views/add_expense.dart';
import 'package:expenses_repository/expense_repository.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CreateCategoryBloc(FirebaseExpenseRepo()),
                ),
                BlocProvider(
                  create: (context) => GetCategoriesBloc(FirebaseExpenseRepo())..add(GetCategories()),
                ),
                BlocProvider(
                  create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
                ),
              ],
              child: const AddExpense(),
            ),
          ),
        );
      },
      shape: const CircleBorder(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary,
            ],
            transform: const GradientRotation(pi / 4),
          ),
        ),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
