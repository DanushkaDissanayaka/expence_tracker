
import 'dart:developer';

import 'package:expense_tracker/blocs/balance/get_balance_summary_bloc/get_balance_summary_bloc.dart';
import 'package:expense_tracker/blocs/expense/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker/blocs/budget/create_budget_plan_bloc/create_budget_plan_bloc.dart';
import 'package:expense_tracker/blocs/budget/get_budget_plans_bloc/get_budget_plans_bloc.dart';
import 'package:expense_tracker/blocs/expense/delete_expense_bloc/delete_expense_bloc.dart';
import 'package:expense_tracker/blocs/expense/update_expense_bloc/update_expense_bloc.dart';
import 'package:expense_tracker/common/helper/formater_heper.dart';
import 'package:expense_tracker/screens/budget_plan/budget_plan_list_screen.dart';
import 'package:expense_tracker/blocs/expense/get_total_expensesbloc/get_total_expenses_bloc.dart';
import 'package:expense_tracker/blocs/expense/get_expenses_by_category_bloc/get_expenses_by_category_bloc.dart';
import 'package:expense_tracker/screens/expenses/view_expenses/view_expenses_by_category.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/expense/get_expensesbloc/get_expenses_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch expenses when screen loads
    context.read<GetTotalExpensesBloc>().add(GetTotalExpenses());
    // Fetch balance summary when screen loads
    context.read<GetBalanceSummaryBloc>().add(const GetBalanceSummary());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFF8FAFC), // Light background
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header Section
              _buildHeader(context),
              const SizedBox(height: 24),
              // Balance Card
              _buildBalanceCard(),
              const SizedBox(height: 32),
              // Transactions Header
              _buildTransactionsHeader(context),
              const SizedBox(height: 16),
              // Transactions List
              _buildTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF6366F1), // Flat primary color
              ),
              child: const Icon(
                CupertinoIcons.person_fill,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Shawn/Sam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            GetBudgetPlansBloc(FirebaseBudgetRepository())
                              ..add(const GetBudgetPlans()),
                      ),
                      BlocProvider(
                        create: (context) =>
                            CreateBudgetPlanBloc(FirebaseBudgetRepository()),
                      ),
                    ],
                    child: const BudgetPlanListScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.settings,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return BlocBuilder<GetBalanceSummaryBloc, GetBalanceSummaryState>(
      builder: (context, state) {
        if (state is GetBalanceSummaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetBalanceSummarySuccess) {
          return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1), // Flat primary color
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFDDD6FE), // Light purple
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatToCurrency(state.balanceSummary.availableExpenseBalance),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBalanceItem(
                          'Savings',
                          formatToCurrency(state.balanceSummary.totalSavings),
                          saving.icon.icon,
                          saving.color, // Green
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildBalanceItem(
                          'Current',
                          formatToCurrency(state.balanceSummary.currentExpenses),
                          CupertinoIcons.arrow_up_right,
                          expenses.color, // Red
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
        } else if (state is GetBalanceSummaryFailure) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return Container();
      },
    );
  }

  Widget _buildBalanceItem(
    String title,
    String amount,
    IconData? icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDDD6FE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        )
      ],
    );
  }

  Widget _buildTransactionsList() {
    return Expanded(
      child: BlocBuilder<GetTotalExpensesBloc, GetTotalExpensesState>(
        builder: (context, state) {
          if (state is GetTotalExpensesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6366F1),
                strokeWidth: 2,
              ),
            );
          } else if (state is GetTotalExpensesSuccess) {
            final expenses = state.expenses;
            if (expenses.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.separated(
              itemCount: expenses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildTransactionItem(expenses[index]);
              },
            );
          } else if (state is GetExpensesFailure) {
            return _buildErrorState();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTransactionItem(TotalExpense expense) {
    return GestureDetector(
      onTap: () {
        final getExpensesByCategoryBloc = BlocProvider.of<GetExpensesByCategoryBloc>(context);
        final createExpenseBloc = BlocProvider.of<CreateExpenseBloc>(context);
        final deleteExpenseBloc = BlocProvider.of<DeleteExpenseBloc>(context);
        final updateExpenseBloc = BlocProvider.of<UpdateExpenseBloc>(context);
        final getTotalExpensesBloc = BlocProvider.of<GetTotalExpensesBloc>(context);
        final getBalanceSummaryBloc = BlocProvider.of<GetBalanceSummaryBloc>(context);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: getExpensesByCategoryBloc),
                BlocProvider.value(value: createExpenseBloc),
                BlocProvider.value(value: deleteExpenseBloc),
                BlocProvider.value(value: updateExpenseBloc),
              ],
              child: ViewExpensesByCategory(totalExpense: expense),
            ),
          ),
        ).then((_) {
          // Refresh the total expenses when returning from the detail screen
          getTotalExpensesBloc.add(GetTotalExpenses());
          getBalanceSummaryBloc.add(const GetBalanceSummary());
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                expense.category.isNotEmpty()
                    ? expense.category.icon.icon
                    : income.icon.icon,
                color: expense.budgetType.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category.name.isEmpty
                        ? (expense.expenses.first.note.isEmpty
                              ? income.name
                              : expense.expenses.first.note)
                        : expense.category.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.lastTransactionDate.toLocal().toString().split(
                      ' ',
                    )[0],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Rs. ${expense.totalAmount}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 40,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your recent transactions will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 40,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
