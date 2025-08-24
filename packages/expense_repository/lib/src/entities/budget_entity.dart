
class BudgetEntity {
  final String personId;
  final String budgetTypeId;
  double amount;
  final String mainCategoryId;
  final String subCategoryId;

  BudgetEntity({
    required this.personId,
    required this.budgetTypeId,
    required this.amount,
    required this.mainCategoryId,
    required this.subCategoryId,
  });

  Map<String, Object> toDocument() {
    return {
      'personId': personId,
      'budgetTypeId': budgetTypeId,
      'amount': amount,
      'mainCategoryId': mainCategoryId,
      'subCategoryId': subCategoryId,
    };
  }

  factory BudgetEntity.fromDocument(Map<String, Object> doc) {
    return BudgetEntity(
      personId: doc['personId'] as String,
      budgetTypeId: doc['budgetTypeId'] as String,
      amount: (doc['amount'] as num).toDouble(),
      mainCategoryId: doc['mainCategoryId'] as String,
      subCategoryId: doc['subCategoryId'] as String,
    );
  }
}