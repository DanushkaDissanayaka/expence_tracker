part of 'get_balance_summary_bloc.dart';

sealed class GetBalanceSummaryEvent extends Equatable {
  const GetBalanceSummaryEvent();

  @override
  List<Object> get props => [];
}

class GetBalanceSummary extends GetBalanceSummaryEvent {
  final String? personId;

  const GetBalanceSummary({this.personId});

  @override
  List<Object> get props => [personId ?? ''];
}