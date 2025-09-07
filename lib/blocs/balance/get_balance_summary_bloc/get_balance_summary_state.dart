part of 'get_balance_summary_bloc.dart';

sealed class GetBalanceSummaryState extends Equatable {
  const GetBalanceSummaryState();
  
  @override
  List<Object> get props => [];
}

final class GetBalanceSummaryInitial extends GetBalanceSummaryState {}
final class GetBalanceSummaryLoading extends GetBalanceSummaryState {}
final class GetBalanceSummarySuccess extends GetBalanceSummaryState {
  final BalanceSummary balanceSummary;

  const GetBalanceSummarySuccess(this.balanceSummary);

  @override
  List<Object> get props => [balanceSummary];
}
final class GetBalanceSummaryFailure extends GetBalanceSummaryState {
  final String error;

  const GetBalanceSummaryFailure(this.error);

  @override
  List<Object> get props => [error];
}
