import 'package:expense_tracker/blocs/expense/get_cumulative_expenses_bloc/get_cumulative_expenses_bloc.dart';
import 'package:expense_tracker/blocs/expense/get_daily_expenses_bloc/get_daily_expenses_bloc.dart';
import 'package:expense_tracker/screens/stats/chart.dart';
import 'package:expense_tracker/screens/stats/cumulative_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0); // Cumulative is default
    // Load data when screen initializes
    _refreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when screen becomes visible again
    _refreshData();
  }

  void _refreshData() {
    // Trigger both blocs to fetch fresh data
    context.read<GetDailyExpensesBloc>().add(GetDailyExpenses());
    context.read<GetCumulativeExpensesBloc>().add(GetCumulativeExpenses());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(8.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Analytics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Spending trends for current billing period',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),
              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF6366F1),
                  ),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: -10.0, vertical: 0.0),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF6B7280),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Cumulative'),
                    Tab(text: 'Daily'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Chart widget
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Cumulative Chart Tab
                        BlocBuilder<GetCumulativeExpensesBloc, GetCumulativeExpensesState>(
                          builder: (context, state) {
                            return _buildCumulativeChart(state);
                          },
                        ),
                        // Daily Chart Tab
                        BlocBuilder<GetDailyExpensesBloc, GetDailyExpensesState>(
                          builder: (context, state) {
                            return _buildDailyChart(state);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCumulativeChart(GetCumulativeExpensesState state) {
    if (state is GetCumulativeExpensesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetCumulativeExpensesSuccess) {
      if (state.cumulativeExpenses.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_chart_outlined,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No expenses for this billing period',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }
      
      return CumulativeChart(
        dailyExpenses: state.cumulativeExpenses,
        billingPeriodStart: state.billingPeriodStart,
      );
    } else if (state is GetCumulativeExpensesFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading cumulative data...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDailyChart(GetDailyExpensesState state) {
    if (state is GetDailyExpensesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetDailyExpensesSuccess) {
      if (state.dailyExpenses.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_chart_outlined,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No expenses for this billing period',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }
      
      return MyChart(
        dailyExpenses: state.dailyExpenses,
        billingPeriodStart: state.billingPeriodStart,
      );
    } else if (state is GetDailyExpensesFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading daily data...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }
}