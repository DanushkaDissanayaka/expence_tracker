import 'package:expenses_repository/expense_repository.dart';

abstract class BalanceRepository {
  Future<BalanceSummary> getBalanceSummary(String? personId);
}