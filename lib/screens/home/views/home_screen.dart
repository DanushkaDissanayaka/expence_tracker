import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:expense_tracker/screens/stats/stat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/screens/home/widgets/home_bottom_nav_bar.dart';
import 'package:expense_tracker/screens/home/widgets/home_fab.dart';
import '../blocs/get_expensesbloc/get_expenses_bloc.dart';
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
    return BlocProvider<GetExpensesBloc>(
      create: (context) => GetExpensesBloc(FirebaseExpenseRepo()),
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
