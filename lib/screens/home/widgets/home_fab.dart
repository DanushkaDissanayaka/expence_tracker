import 'dart:math';
import 'package:expense_tracker/blocs/expense/update_expense_bloc/update_expense_bloc.dart';
import 'package:expense_tracker/screens/expenses/add_expenses/expense_entry_screen.dart';
import 'package:expense_tracker/blocs/expense/get_total_expensesbloc/get_total_expenses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/blocs/expense/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_repository/expense_repository.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final getTotalExpensesBloc = BlocProvider.of<GetTotalExpensesBloc>(context);
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
                ),
                BlocProvider(create:  (context) => UpdateExpenseBloc(FirebaseExpenseRepo()),)
              ],
              child: const ExpenseEntryScreen(),
            ),
          ),
        ).then((_) {
          // After returning from the add expense screen, refresh total expenses
          getTotalExpensesBloc.add(GetTotalExpenses());
        });
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
