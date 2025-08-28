

import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/entities.dart';

/// Represents an expense record.
class Expense {
  /// Unique identifier for the expense.
  String expenseId;

  /// The subcategory of the expense.
   SubCategory category;

  /// The main category of the expense, derived from [category].
   SubCategory mainCategory;

  /// The date of the expense.
   DateTime date;

  /// The amount spent.
   int amount;

  /// The budget type for the expense.
   BudgetType budgetType;

   Person person;

   String note;

  /// Creates an [Expense] instance.
  Expense({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    required this.budgetType,
    required this.person,
    required this.note,
  }) : mainCategory = category.parentId != null && category.parentId!.isNotEmpty
          ? parentCategories.firstWhere((c) => c.categoryId == category.parentId)
          : SubCategory.empty();

  /// Converts this [Expense] to an [ExpenseEntity].
  ExpenseEntity toEntity() => ExpenseEntity(
    expenseId: expenseId,
    categoryId: category.categoryId,
    date: date,
    amount: amount,
    budgetTypeId: budgetType.budgetTypeId,
    personId: person.personId,
    note: note,
  );

  /// Creates an [Expense] from an [ExpenseEntity].
  factory Expense.fromEntity(ExpenseEntity entity) {
    final SubCategory category = entity.categoryId.isNotEmpty
        ? subCategories.firstWhere((c) => c.categoryId == entity.categoryId)
        : SubCategory.empty();
    return Expense(
      expenseId: entity.expenseId,
      category: category,
      date: entity.date,
      amount: entity.amount,
      budgetType: budgetTypeOption.firstWhere((t) => t.budgetTypeId == entity.budgetTypeId),
      person: persons.firstWhere((p) => p.personId == entity.personId),
      note: entity.note,
    );
  }

  /// An empty [Expense] instance.
  static final Expense empty = Expense(
    expenseId: '',
    category: SubCategory.empty(),
    date: DateTime.now(),
    amount: 0,
    budgetType: expenses,
    person: persons.first,
    note: '',
  );
}