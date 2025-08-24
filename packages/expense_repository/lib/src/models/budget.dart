import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/data/data.dart';
import 'package:expenses_repository/src/entities/entities.dart';

class Budget {
  Person person;
  final BudgetType budgetType;
  double amount;
  final SubCategory mainCategory;
  final SubCategory subCategory;

  Budget({
    required this.person,
    required this.budgetType,
    required this.amount,
    required this.mainCategory,
    required this.subCategory,
  });

  BudgetEntity toEntity() {
    return BudgetEntity(
      personId: person.personId,
      budgetTypeId: budgetType.budgetTypeId,
      amount: amount,
      mainCategoryId: mainCategory.categoryId,
      subCategoryId: subCategory.categoryId,
    );
  }

  factory Budget.fromEntity(BudgetEntity entity) {
    return Budget(
      person: persons.firstWhere((p) => p.personId == entity.personId),
      budgetType: budgetTypeOption
          .firstWhere((t) => t.budgetTypeId == entity.budgetTypeId),
      amount: entity.amount,
      mainCategory: entity.mainCategoryId.isNotEmpty
          ? parentCategories
              .firstWhere((c) => c.categoryId == entity.mainCategoryId)
          : SubCategory.empty(),
      subCategory: entity.subCategoryId.isNotEmpty
          ? subCategories
              .firstWhere((c) => c.categoryId == entity.subCategoryId)
          : SubCategory.empty(),
    );
  }
}
