class ExpenseEntity {
  String expenseId;
  String categoryId;
  String name;
  double amount;
  DateTime date;
  String note;
  String color;

  ExpenseEntity({
    required this.expenseId,
    required this.categoryId,
    required this.name,
    required this.amount,
    required this.date,
    required this.note,
    required this.color,
  });
  
}