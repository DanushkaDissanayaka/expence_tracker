import 'package:expenses_repository/src/data/data.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';

class BudgetList extends StatelessWidget {
  final List<ParentCategory> mainCategories;
  final List<Budget> budgetList;
  final int? editingIndex;
  final String editingBudget;
  final String editingPerson;
  final Function(String) onEditingBudgetChanged;
  final Function(String?) onEditingPersonChanged;
  final List<Person> personOptions;
  final Function(int, String, String) onEditSave;
  final Function(int) onEditStart;
  final Function(int) onDelete;
  final Function() onEditCancel;

  const BudgetList({
    super.key,
    required this.mainCategories,
    required this.budgetList,
    required this.editingIndex,
    required this.editingBudget,
    required this.editingPerson,
    required this.onEditingBudgetChanged,
    required this.onEditingPersonChanged,
    required this.personOptions,
    required this.onEditSave,
    required this.onEditStart,
    required this.onDelete,
    required this.onEditCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (budgetList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.receipt_outlined,
                  size: 48,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No budgets added yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start by adding your first budget item',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final incomeBudgets = budgetList.where((b) => (b.budgetType.budgetTypeId == income.budgetTypeId)).toList();
    final savingBudgets = budgetList.where((b) => (b.budgetType.budgetTypeId == saving.budgetTypeId)).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Income Section
          if (incomeBudgets.isNotEmpty) 
            _buildBudgetSection(
              title: 'Income',
              budgets: incomeBudgets,
              color: const Color(0xFF10B981),
              backgroundColor: const Color(0xFFF0FDF4),
            ),
          
          // Savings Section  
          if (savingBudgets.isNotEmpty)
            _buildBudgetSection(
              title: 'Savings',
              budgets: savingBudgets,
              color: const Color(0xFFF59E0B),
              backgroundColor: const Color(0xFFFFF7ED),
            ),

          // Expense Categories
          ...mainCategories.map((mainCat) {
            final categoryBudgets = budgetList.where((b) => 
                b.mainCategory.categoryId == mainCat.parent.categoryId).toList();
            
            if (categoryBudgets.isEmpty) return const SizedBox.shrink();
            
            return _buildBudgetSection(
              title: mainCat.parent.name,
              budgets: categoryBudgets,
              color: const Color(0xFFEF4444),
              backgroundColor: const Color(0xFFFEF2F2),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBudgetSection({
    required String title,
    required List<Budget> budgets,
    required Color color,
    required Color backgroundColor,
  }) {
    final total = budgets.fold<double>(0, (sum, budget) => sum + budget.amount);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    title == 'Income' ? Icons.trending_up : 
                    title == 'Savings' ? Icons.savings_outlined :
                    Icons.shopping_cart_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Budget Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: budgets.length,
            separatorBuilder: (_, __) => Container(
              height: 1,
              color: const Color(0xFFF1F5F9),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            itemBuilder: (context, index) {
              final i = budgetList.indexOf(budgets[index]);
              final item = budgets[index];
              final isEditing = editingIndex == i;
              
              return _buildBudgetItem(item, i, isEditing);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(Budget item, int index, bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Category Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.subCategory.isNotEmpty() 
                  ? (item.subCategory.icon.icon ?? Icons.category)
                  : (item.mainCategory.icon.icon ?? Icons.category),
              size: 16,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: isEditing ? _buildEditingRow(index) : _buildDisplayRow(item),
          ),
          
          // Actions
          isEditing ? _buildEditingActions(index) : _buildDisplayActions(index, item.amount),
        ],
      ),
    );
  }

  Widget _buildDisplayRow(Budget item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.subCategory.isNotEmpty() 
              ? item.subCategory.name 
              : item.mainCategory.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Person: ${item.person.name}',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildEditingRow(int index) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              value: editingPerson.isEmpty ? null : editingPerson,
              items: personOptions.map((p) => DropdownMenuItem(
                value: p.personId,
                child: Text(p.name, style: const TextStyle(fontSize: 14)),
              )).toList(),
              onChanged: onEditingPersonChanged,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              onChanged: onEditingBudgetChanged,
              initialValue: editingBudget,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayActions(int index, double amount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onEditStart(index),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: Color(0xFFF59E0B),
            ),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => onDelete(index),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.delete_outline,
              size: 16,
              color: Color(0xFFEF4444),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditingActions(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onEditSave(index, editingPerson, editingBudget),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: Color(0xFF10B981),
            ),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onEditCancel,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFFEF4444),
            ),
          ),
        ),
      ],
    );
  }
}
