import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/category_entity.dart';

class ExpenseEntity {
  String expenseId;
  Category category;
  DateTime date;
  int amount;

  ExpenseEntity({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': expenseId,
      'category': category.toEntity().toDocument(),
      'date': date,
      'amount': amount,
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> json) {
    return ExpenseEntity(
      expenseId: json['id'],
      category: Category.fromEntity(CategoryEntity.fromDocument(json['category'])),
      date: (json['date'] as Timestamp).toDate(),
      amount: json['amount'],
    );
  }
}