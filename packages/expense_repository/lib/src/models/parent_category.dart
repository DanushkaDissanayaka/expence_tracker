import 'package:expenses_repository/expense_repository.dart';

class ParentCategory {
  final SubCategory parent;
  final List<SubCategory> children;

  ParentCategory({
    required this.parent,
    required this.children,
  });
}