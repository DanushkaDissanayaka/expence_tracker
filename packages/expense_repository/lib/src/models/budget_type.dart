import 'package:flutter/material.dart';

class BudgetType {
  final String budgetTypeId;
  final String name;
  final Icon icon;
  final Color color;

  BudgetType({
    required this.budgetTypeId,
    required this.name,
    required this.icon,
    required this.color,
  });
}
