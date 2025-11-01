
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
  late PageController _pageController;
  int _currentPage = 0;
  
  final List<Map<String, dynamic>> _balancePages = [
    {'title': 'Overall', 'personId': null},
  ];

  @override
  void initState() {
    super.initState();

    // add persons dynamically
    for (var person in persons) {
      _balancePages.add({'title': person.name, 'personId': person.personId});
    }
    _pageController = PageController();
    // Fetch expenses when screen loads
    context.read<GetTotalExpensesBloc>().add(GetTotalExpenses());
    // Fetch balance summary when screen loads
    context.read<GetBalanceSummaryBloc>().add(const GetBalanceSummary());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  'S&S',
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
    return Column(
      children: [
        // Page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _balancePages.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF6366F1)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // PageView for balance cards
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              // Fetch balance summary for the current page
              final personId = _balancePages[page]['personId'];
              context.read<GetBalanceSummaryBloc>().add(GetBalanceSummary(personId: personId));
            },
            itemCount: _balancePages.length,
            itemBuilder: (context, index) {
              final pageData = _balancePages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildBalanceCardContent(pageData['title'], pageData['personId']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCardContent(String title, String? personId) {
    return BlocBuilder<GetBalanceSummaryBloc, GetBalanceSummaryState>(
      builder: (context, state) {
        if (state is GetBalanceSummaryLoading) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        } else if (state is GetBalanceSummarySuccess) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$title Balance',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFDDD6FE),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  formatToCurrency(state.balanceSummary.availableExpenseBalance),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildBalanceItem(
                        'Savings',
                        formatToCurrency(state.balanceSummary.totalSavings),
                        saving.icon.icon,
                        saving.color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBalanceItem(
                        'Current',
                        formatToCurrency(state.balanceSummary.currentExpenses),
                        CupertinoIcons.arrow_up_right,
                        expenses.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is GetBalanceSummaryFailure) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        );
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
        color: Colors.white.withValues(alpha: .1),
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

  Widget _buildTransactionItem(TotalExpenseByCategory expense) {
    // Calculate remaining amount
    final double remaining = (expense.totalAllocatedAmount - expense.totalAmount).toDouble();
    final double allocated = expense.totalAllocatedAmount.toDouble();
    final double spent = expense.totalAmount.toDouble();
    
    // Determine color based on spending ratio
    Color getSpendColor() {
      if (allocated == 0 && spent > 0) return Color(0xFFEF4444); // Red - danger zone
      if (allocated == 0) return Colors.grey;
      final double spendRatio = spent / allocated;
      
      if (spendRatio <= 0.5) {
        return const Color(0xFF10B981); // Green - safe zone
      } else if (spendRatio <= 1.0) {
        return const Color(0xFFF59E0B); // Yellow/Amber - warning zone
      } else {
        return const Color(0xFFEF4444); // Red - danger zone
      }
    }
    
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top row with icon, category name, and last transaction date
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (expense.budgetType.budgetTypeId == income.budgetTypeId 
                      ? expense.budgetType.color : getSpendColor()).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    expense.category.isNotEmpty()
                        ? expense.category.icon.icon
                        : income.icon.icon,
                    color: expense.budgetType.budgetTypeId == income.budgetTypeId 
                      ? expense.budgetType.color : getSpendColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        expense.lastTransactionDate?.toLocal().toString().split(' ')[0] ?? 'No date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Budget details row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Allocated amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Allocated',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatToCurrency(allocated),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spent amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Spent',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatToCurrency(spent),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: getSpendColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Remaining amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          remaining == 0 ? 'Budget over' : remaining < 0 ? 'Overspent' : 'Remaining',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatToCurrency(remaining),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: getSpendColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              color: const Color(0xFF6366F1).withValues(alpha: .1),
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
              color: const Color(0xFFEF4444).withValues(alpha: .1),
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
