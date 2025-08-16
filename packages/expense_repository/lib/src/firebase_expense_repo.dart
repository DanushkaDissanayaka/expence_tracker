import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_repository/src/entities/category_entity.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await categoryCollection.get().then((value) => value.docs
          .map((doc) =>
              Category.fromEntity(CategoryEntity.fromDocument(doc.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
