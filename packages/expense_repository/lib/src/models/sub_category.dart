import 'package:flutter/material.dart';

class SubCategory {
  final String categoryId;
  final String name;
  final Icon icon;
  final String? parentId;

  SubCategory({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.parentId,
  });

  static SubCategory empty() {
    return SubCategory(
      categoryId: '',
      name: '',
      icon: const Icon(Icons.category),
      parentId: null,
    );
  }

  bool isNotEmpty() {
    return categoryId.isNotEmpty && name.isNotEmpty;
  }
}
