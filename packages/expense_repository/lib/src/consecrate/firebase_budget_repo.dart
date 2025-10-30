import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/src/abstract/budget_repository.dart';
import 'package:expenses_repository/src/entities/budget_plan_entity.dart';
import 'package:expenses_repository/src/models/budget_plan.dart';

class FirebaseBudgetRepository implements BudgetRepository {
  
  final budgetPlanCollection = FirebaseFirestore.instance.collection('budget_plan');

  @override
  Future<void> createBudgetPlan(BudgetPlan budgetPlan) async {
    try {
      if(budgetPlan.budgetPlanId.isEmpty){
        // check if the budget plan for this month exist
        final existingPlan = await budgetPlanCollection
            .where('month', isEqualTo: budgetPlan.month)
            .where('year', isEqualTo: budgetPlan.year)
            .get();
        if (existingPlan.docs.isNotEmpty) {
          // budgetPlan.budgetPlanId = existingPlan.docs.first.id;
          throw Exception('Budget plan for this month already exists.');
        } else {
          // generate a new id
          budgetPlan.budgetPlanId = budgetPlanCollection.doc().id;
        }
      }
      final budgetPlanDoc = budgetPlan.toEntity().toDocument();

      await budgetPlanCollection
          .doc(budgetPlan.budgetPlanId)
          .set(budgetPlanDoc);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateBudgetPlan(BudgetPlan budgetPlan) async {
    try {
      await budgetPlanCollection
          .doc(budgetPlan.budgetPlanId)
          .update(budgetPlan.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<List<BudgetPlan>> getBudgetPlans() async {
    try {
      return await budgetPlanCollection.get().then((value) => value.docs
          .map((doc) =>
              BudgetPlan.fromEntity(BudgetPlanEntity.fromDocument(doc.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
