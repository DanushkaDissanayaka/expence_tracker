import 'package:expense_tracker/common/helper/calculation_helper.dart';
import 'package:expense_tracker/common/helper/formater_heper.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'blocs/get_budget_plans_bloc/get_budget_plans_bloc.dart';
import 'blocs/create_budget_plan_bloc/create_budget_plan_bloc.dart';
import 'budget_plan_screen.dart';

class BudgetPlanListScreen extends StatelessWidget {
  const BudgetPlanListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Budget Plans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF2D3748),
            size: 20,
          ),
        ),
      ),
      body: BlocListener<GetBudgetPlansBloc, GetBudgetPlansState>(
        listener: (context, state) {
          if (state is GetBudgetPlansFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<GetBudgetPlansBloc, GetBudgetPlansState>(
          builder: (context, state) {
            if (state is GetBudgetPlansLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                ),
              );
            } else if (state is GetBudgetPlansSuccess) {
              final plans = state.budgetPlans;
              if (plans.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Budget Plans',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your first budget plan to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final totalExpenses = getExpenseTotal(plan.budgetPlan, null);
                final totalIncome = getIncomeTotal(plan.budgetPlan, null);
                final totalSavings = getSavingTotal(plan.budgetPlan, null);
                final month = DateFormat('MMMM').format(DateTime(0, plan.month));
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: InkWell(
                    onTap: () {
                      final createBudgetPlanBloc = BlocProvider.of<CreateBudgetPlanBloc>(context);
                      final getBudgetPlansBloc = BlocProvider.of<GetBudgetPlansBloc>(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: createBudgetPlanBloc,
                            child: BudgetPlanScreen(initialPlan: plan),
                          ),
                        ),
                      ).then((_) {
                        // Reload budget plans after editing
                        getBudgetPlansBloc.add(const GetBudgetPlans());
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '$month ${plan.year}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${plan.budgetPlan.length} items',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Budget Summary Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildBudgetSummaryCard(
                                  expenses.name,
                                  formatToCurrency(totalExpenses),
                                  expenses.icon.icon,
                                  expenses.color,
                                  expenses.color.withValues(alpha: .1),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildBudgetSummaryCard(
                                  income.name,
                                  formatToCurrency(totalIncome),
                                  income.icon.icon,
                                  income.color,
                                  income.color.withValues(alpha: .1),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildBudgetSummaryCard(
                                  saving.name,
                                  formatToCurrency(totalSavings),
                                  saving.icon.icon,
                                  saving.color,
                                  saving.color.withValues(alpha: .1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is GetBudgetPlansFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final createBudgetPlanBloc = BlocProvider.of<CreateBudgetPlanBloc>(context);
          final getBudgetPlansBloc = BlocProvider.of<GetBudgetPlansBloc>(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: createBudgetPlanBloc,
                child: BudgetPlanScreen(),
              ),
            ),
          ).then((_) {
            // Reload budget plans after adding
            getBudgetPlansBloc.add(const GetBudgetPlans());
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        label: const Text(
          'New Plan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBudgetSummaryCard(
    String title,
    String amount,
    IconData? icon,
    Color iconColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon ?? Icons.help_outline,
                size: 14,
                color: iconColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}
