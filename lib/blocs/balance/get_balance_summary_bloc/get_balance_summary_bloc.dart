import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expense_repository.dart';

part 'get_balance_summary_event.dart';
part 'get_balance_summary_state.dart';

class GetBalanceSummaryBloc extends Bloc<GetBalanceSummaryEvent, GetBalanceSummaryState> {
  final BalanceRepository balanceRepository;
  GetBalanceSummaryBloc(this.balanceRepository) : super(GetBalanceSummaryInitial()) {
    on<GetBalanceSummary>((event, emit) async {
     try {
        emit(GetBalanceSummaryLoading());
        final balanceSummary = await balanceRepository.getBalanceSummary(event.personId);
        emit(GetBalanceSummarySuccess(balanceSummary));
      } catch (e) {
        emit(GetBalanceSummaryFailure(e.toString()));
      }
    });
  }
}
