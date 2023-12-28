import 'package:bloc/bloc.dart';
import 'package:counterapp/modules/data/repository/counter_repo.dart';
import 'package:equatable/equatable.dart';

part 'success_event.dart';

part 'success_state.dart';

class SuccessBloc extends Bloc<SuccessEvent, SuccessState> {
  final CounterRepository repository;

  SuccessBloc({required this.repository}) : super(const SuccessInitial()) {
    on<SuccessEvent>((event, emit) {});

    on<SuccessCallEvent>(_successHandler);

    on<InitialEvent>(_initalHandler);

    on<ResetCallEvent>(_resetHandler);

    on<FailAttemptCallEvent>(_failHandler);

    on<PenaltyCallEvent>(_penaltyCall);

    // initalise
    add(InitialEvent());
  }

  _resetHandler(event, emit) async {
    // reset counter
    final counter = await repository.resetCounter();
    // update state
    emit(SuccessInitial(successCounter: counter));
  }

  _initalHandler(event, emit) async {
    // get counter
    final counter = await repository.getCounter();
    final failCounter = await repository.getCounterFail();
    final penltyCounter = await repository.getCounterPenalty();

    // update state
    emit(SuccessInitial(
        successCounter: counter ?? 0,
        attempts: failCounter ?? 0,
        penalty: penltyCounter ?? 0));
  }

  _successHandler(event, emit) async {
    final counter = await repository.setCounter();
    final current = state;
    if (current is SuccessInitial) {
      emit(current.copyWith(successCounter: counter));
    }
  }

  _failHandler(event, emit) async {
    final counter = await repository.setFailCounter();
    final current = state;
    if (current is SuccessInitial) {
      emit(current.copyWith(attempts: counter));
    }
  }

  _penaltyCall(event, emit) async {
    final counter = await repository.setPenaltyCounter();
    final current = state;
    if (current is SuccessInitial) {
      emit(current.copyWith(penalty: counter));
    }
  }
}
