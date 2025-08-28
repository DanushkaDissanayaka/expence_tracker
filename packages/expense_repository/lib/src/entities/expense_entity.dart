import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/category_entity.dart';

class ExpenseEntity {
  String expenseId;
  String categoryId;
  DateTime date;
  String budgetTypeId;
  int amount;
  String personId;
  String note;

  ExpenseEntity({
    required this.expenseId,
    required this.categoryId,
    required this.date,
    required this.amount,
    required this.budgetTypeId,
    required this.personId,
    required this.note,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': expenseId,
      'categoryId': categoryId,
      'date': date,
      'amount': amount,
      'budgetTypeId': budgetTypeId,
      'personId': personId,
      'note': note,
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> json) {
    return ExpenseEntity(
      expenseId: json['id'],
      categoryId: json['categoryId'],
      date: (json['date'] as Timestamp).toDate(),
      amount: json['amount'],
      budgetTypeId: json['budgetTypeId'],
      personId: json['personId'],
      note: json['note'],
    );
  }
}