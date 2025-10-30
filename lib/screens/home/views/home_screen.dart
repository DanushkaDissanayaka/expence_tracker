import 'package:expense_tracker/blocs/balance/get_balance_summary_bloc/get_balance_summary_bloc.dart';
import 'package:expense_tracker/blocs/expense/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker/blocs/expense/delete_expense_bloc/delete_expense_bloc.dart';
import 'package:expense_tracker/blocs/expense/get_cumulative_expenses_bloc/get_cumulative_expenses_bloc.dart';
import 'package:expense_tracker/blocs/expense/get_daily_expenses_bloc/get_daily_expenses_bloc.dart';
import 'package:expense_tracker/blocs/expense/get_total_expensesbloc/get_total_expenses_bloc.dart';
import 'package:expense_tracker/blocs/expense/update_expense_bloc/update_expense_bloc.dart';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:expense_tracker/screens/stats/stat_screen.dart';
import 'package:expense_tracker/blocs/expense/get_expenses_by_category_bloc/get_expenses_by_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/screens/home/widgets/home_bottom_nav_bar.dart';
import 'package:expense_tracker/screens/home/widgets/home_fab.dart';
import 'package:expenses_repository/expense_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _widgetList = const [MainScreen(), StatScreen()];
  int _index = 0;
  final Color _selectedItemColor = Colors.blue;
  final Color _unselectedItemColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetTotalExpensesBloc>(
          create: (context) => GetTotalExpensesBloc(FirebaseExpenseRepo()),
        ),
        BlocProvider(create: (context) => GetExpensesByCategoryBloc(FirebaseExpenseRepo())),
        BlocProvider(create: (context) => CreateExpenseBloc(FirebaseExpenseRepo())),
        BlocProvider(create: (context) => UpdateExpenseBloc(FirebaseExpenseRepo())),
        BlocProvider(create: (context) => DeleteExpenseBloc(FirebaseExpenseRepo())),
        BlocProvider(create: (context) => GetBalanceSummaryBloc(FirebaseBalanceRepo())),
        BlocProvider(create: (context) => GetDailyExpensesBloc(FirebaseExpenseRepo())
          ..add(GetDailyExpenses())),
        BlocProvider(create: (context) => GetCumulativeExpensesBloc(FirebaseExpenseRepo())
          ..add(GetCumulativeExpenses())),
      ],
      child: Scaffold(
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _index,
          onTap: (value) {
            setState(() {
              _index = value;
            });
          },
          selectedItemColor: _selectedItemColor,
          unselectedItemColor: _unselectedItemColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const HomeFAB(),
        body: _widgetList[_index],
      ),
    );
  }
}
