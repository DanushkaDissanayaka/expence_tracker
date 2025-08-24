import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/get_budget_plans_bloc/get_budget_plans_bloc.dart';

class BudgetPlanListScreen extends StatelessWidget {
  const BudgetPlanListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Budget Plans'),
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
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetBudgetPlansSuccess) {
              final plans = state.budgetPlans;
            if (plans.isEmpty) {
              return const Center(child: Text('No budget plans found.'));
            }
            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final totalAmount = plan.budgetPlan.fold<double>(0, (sum, item) => sum + item.amount);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Month: ${plan.month}, Year: ${plan.year}'),
                    subtitle: Text('Total: ${totalAmount.toStringAsFixed(2)}'),
                    onTap: () {
                      // TODO: Navigate to budget plan details if needed
                    },
                  ),
                );
              },
            );
          } else if (state is GetBudgetPlansFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const SizedBox.shrink();
        },
      ),
    )
    );
  }
}
