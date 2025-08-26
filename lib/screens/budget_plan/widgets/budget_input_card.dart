import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';

class BudgetInputCard extends StatelessWidget {
  final String formattedMonth;
  final String personInput;
  final List<Person> personOptions;
  final Function(String?) onPersonChanged;
  final SubCategory selectedMainCategory;
  final SubCategory selectedSubCategory;
  final VoidCallback onMainCategoryTap;
  final VoidCallback onSubCategoryTap;
  final String budgetInput;
  final TextEditingController budgetController;
  final Function(String) onBudgetChanged;
  final String selectedType;
  final Function(String?) onTypeChanged;
  final List<BudgetType> budgetTypeOptions;
  final VoidCallback onAdd;
  final bool canAdd;

  const BudgetInputCard({
    super.key,
    required this.formattedMonth,
    required this.personInput,
    required this.personOptions,
    required this.onPersonChanged,
    required this.selectedMainCategory,
    required this.selectedSubCategory,
    required this.onMainCategoryTap,
    required this.onSubCategoryTap,
    required this.budgetInput,
    required this.budgetController,
    required this.onBudgetChanged,
    required this.selectedType,
    required this.onTypeChanged,
    required this.budgetTypeOptions,
    required this.onAdd,
    required this.canAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Budget Item',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Type',
                  value: selectedType.isEmpty ? null : selectedType,
                  items: budgetTypeOptions
                      .map((t) => DropdownMenuItem(
                            value: t.budgetTypeId,
                            child: Row(
                              children: [
                                Icon(t.icon.icon, color: const Color(0xFF6B7280), size: 16),
                                const SizedBox(width: 8),
                                Text(t.name),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: onTypeChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'Person',
                  value: personInput.isEmpty ? null : personInput,
                  items: personOptions
                      .map((p) => DropdownMenuItem(
                            value: p.personId,
                            child: Row(
                              children: [
                                Icon(p.icon.icon, color: const Color(0xFF6B7280), size: 16),
                                const SizedBox(width: 8),
                                Text(p.name),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: onPersonChanged,
                ),
              ),
            ],
          ),
          if (selectedType != '1' && selectedType != '2' && selectedType != '') ...[
            const SizedBox(height: 16),
            _buildCategorySelector(
              label: selectedMainCategory.isNotEmpty() 
                  ? selectedMainCategory.name 
                  : 'Select Main Category',
              icon: selectedMainCategory.isNotEmpty() 
                  ? (selectedMainCategory.icon.icon ?? Icons.category_outlined)
                  : Icons.category_outlined,
              onTap: onMainCategoryTap,
            ),
            const SizedBox(height: 12),
            _buildCategorySelector(
              label: selectedSubCategory.isNotEmpty() 
                  ? selectedSubCategory.name 
                  : 'Select Sub Category',
              icon: selectedSubCategory.isNotEmpty() 
                  ? (selectedSubCategory.icon.icon ?? Icons.label_outline)
                  : Icons.label_outline,
              onTap: selectedMainCategory.isNotEmpty() ? onSubCategoryTap : null,
              enabled: selectedMainCategory.isNotEmpty(),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Amount',
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  onChanged: onBudgetChanged,
                  prefixIcon: Icons.attach_money,
                ),
              ),
              const SizedBox(width: 12),
              _buildAddButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonFormField<T>(
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: enabled ? const Color(0xFFF9FAFB) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: enabled ? const Color(0xFFE5E7EB) : const Color(0xFFD1D5DB),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: enabled ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: enabled ? const Color(0xFF374151) : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: enabled ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      size: 18,
                      color: const Color(0xFF6B7280),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: canAdd ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: canAdd ? onAdd : null,
          child: Icon(
            Icons.add,
            color: canAdd ? Colors.white : const Color(0xFF9CA3AF),
            size: 24,
          ),
        ),
      ),
    );
  }
}
