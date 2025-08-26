import 'package:expense_tracker/common/helper/calculation_helper.dart';
import 'package:expense_tracker/common/helper/formater_heper.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:flutter/material.dart';

class BudgetInputDialog extends StatefulWidget {
  final String formattedMonth;
  final List<Person> personOptions;
  final List<BudgetType> budgetTypeOptions;
  final List<ParentCategory> mainCategories;
  final Function(Budget) onAdd;
  final List<Budget> budgetList;

  const BudgetInputDialog({
    super.key,
    required this.formattedMonth,
    required this.personOptions,
    required this.budgetTypeOptions,
    required this.mainCategories,
    required this.onAdd,
    required this.budgetList, // For validation only
  });

  @override
  State<BudgetInputDialog> createState() => _BudgetInputDialogState();
}

class _BudgetInputDialogState extends State<BudgetInputDialog> {
  final TextEditingController budgetController = TextEditingController();
  String personInput = '';
  String selectedType = '';
  String budgetInput = '';
  SubCategory selectedMainCategory = SubCategory.empty();
  SubCategory selectedSubCategory = SubCategory.empty();
  bool showMainCategoryPanel = false;
  bool showSubCategoryPanel = false;
  String? amountError;

  void validateAmountError() {
    if (budgetInput.isEmpty) {
      amountError = null;
      return;
    }
    if (!isAmountValid) {
      final maxAllowedAmount = getTotalBudget(budgetList, personInput.isEmpty ? null : personInput);
      amountError = 'Amount should not exceed Rs. ${formatToCurrency(maxAllowedAmount)}';
    } else {
      amountError = null;
    }
  }

  double calculateAmount() {
    return double.tryParse(budgetInput) ?? 0;
  }

// Use budgetList from parent screen for validation
List<Budget> get budgetList => widget.budgetList;

  bool get isAmountValid {
    final value = double.tryParse(budgetInput) ?? 0;
    final maxAllowedAmount = getTotalBudget(budgetList, personInput.isEmpty ? null : personInput);
    return selectedType == income.budgetTypeId || value <= maxAllowedAmount;
  }

  bool get canAdd => (selectedType == income.budgetTypeId || selectedType == saving.budgetTypeId)
    ? budgetInput.isNotEmpty && personInput.isNotEmpty && selectedType.isNotEmpty && isAmountValid
    : selectedMainCategory.isNotEmpty() &&
      selectedSubCategory.isNotEmpty() &&
      budgetInput.isNotEmpty &&
      personInput.isNotEmpty &&
      selectedType.isNotEmpty &&
      isAmountValid;

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Add Budget Item',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dialog Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type and Person Dropdowns (vertical)
                    _buildDropdownField(
                      label: 'Type',
                      value: selectedType.isEmpty ? null : selectedType,
                      items: widget.budgetTypeOptions
                          .map((t) => DropdownMenuItem(
                                value: t.budgetTypeId,
                                child: Row(
                                  children: [
                                    Icon(t.icon.icon, color: t.color, size: 16),
                                    const SizedBox(width: 8),
                                    Text(t.name),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedType = v ?? '';
                          validateAmountError();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      label: 'Person',
                      value: personInput.isEmpty ? null : personInput,
                      items: widget.personOptions
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
                      onChanged: (v) {
                        setState(() {
                          personInput = v ?? '';
                          validateAmountError();
                        });
                      },
                    ),

                    // Category Selectors (only show for expense types)
                    if (selectedType != '1' && selectedType != '2' && selectedType != '') ...[
                      const SizedBox(height: 12),
                      _buildCategorySelector(
                        label: selectedMainCategory.isNotEmpty() 
                            ? selectedMainCategory.name 
                            : 'Select Main Category',
                        icon: selectedMainCategory.isNotEmpty() 
                            ? (selectedMainCategory.icon.icon ?? Icons.category_outlined)
                            : Icons.category_outlined,
                        onTap: () => setState(() => showMainCategoryPanel = true),
                      ),
                      const SizedBox(height: 12),
                      _buildCategorySelector(
                        label: selectedSubCategory.isNotEmpty() 
                            ? selectedSubCategory.name 
                            : 'Select Sub Category',
                        icon: selectedSubCategory.isNotEmpty() 
                            ? (selectedSubCategory.icon.icon ?? Icons.label_outline)
                            : Icons.label_outline,
                        onTap: selectedMainCategory.isNotEmpty() 
                            ? () => setState(() => showSubCategoryPanel = true) 
                            : null,
                        enabled: selectedMainCategory.isNotEmpty(),
                      ),
                    ],

                    const SizedBox(height: 12),
                    // Amount Field
                    _buildTextField(
                      label: 'Amount',
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        setState(() {
                          budgetInput = v;
                          validateAmountError();
                        });
                      },
                      prefixIcon: Icons.attach_money,
                      errorText: amountError,
                    ),
                  ],
                ),
              ),
            ),

            // Dialog Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canAdd ? _handleAdd : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAdd 
                            ? const Color(0xFF3B82F6) 
                            : const Color(0xFFF1F5F9),
                        foregroundColor: canAdd 
                            ? Colors.white 
                            : const Color(0xFF94A3B8),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add Budget',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Main Category Panel
      if (showMainCategoryPanel)
        _buildCategoryPanelOverlay(
          title: 'Select Main Category',
          categories: widget.mainCategories.map((p) => p.parent).toList(),
          onSelect: (category) {
            setState(() {
              selectedMainCategory = category;
              selectedSubCategory = SubCategory.empty();
              showMainCategoryPanel = false;
            });
          },
          onClose: () => setState(() => showMainCategoryPanel = false),
        ),

      // Sub Category Panel  
      if (showSubCategoryPanel && selectedMainCategory.isNotEmpty())
        _buildCategoryPanelOverlay(
          title: 'Select Sub Category',
          categories: widget.mainCategories
              .firstWhere(
                (p) => p.parent.categoryId == selectedMainCategory.categoryId,
                orElse: () => ParentCategory(parent: SubCategory.empty(), children: []),
              )
              .children,
          onSelect: (category) {
            setState(() {
              selectedSubCategory = category;
              showSubCategoryPanel = false;
            });
          },
          onClose: () => setState(() => showSubCategoryPanel = false),
        ),
        ],
      ),
    );
  }

  Widget _buildCategoryPanelOverlay({
    required String title,
    required List<SubCategory> categories,
    required Function(SubCategory) onSelect,
    required VoidCallback onClose,
  }) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
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
                      GestureDetector(
                        onTap: onClose,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () => onSelect(category),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                category.icon.icon ?? Icons.category_outlined,
                                size: 18,
                                color: const Color(0xFF6B7280),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAdd() {
    final budget = Budget(
      person: widget.personOptions.firstWhere(
        (p) => p.personId == personInput,
      ),
      budgetType: widget.budgetTypeOptions.firstWhere(
        (t) => t.budgetTypeId == selectedType,
      ),
      amount: double.tryParse(budgetInput) ?? 0,
      mainCategory: selectedMainCategory,
      subCategory: selectedSubCategory,
    );
    
    widget.onAdd(budget);
    Navigator.of(context).pop();
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
    String? errorText,
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
          child: Column(
            children: [
              TextField(
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
              if (errorText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      errorText,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
