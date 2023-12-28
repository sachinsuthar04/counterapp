import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:counterapp/modules/data/repository/counter_repo.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';

part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository repository;

  CounterBloc({required this.repository}) : super(const CounterInitial()) {
    on<CounterEvent>((event, emit) {});

    // random Number generator
    on<GenerateRandomNumber>(_generateRandomNumber);
  }

  FutureOr<void> _generateRandomNumber(event, emit) {
    final current = state;
    if (current is CounterInitial) {
      // generate random number
      final random = repository.getRandomNumber();
      final time = DateTime.now();
      emit(current.copyWith(
        randomNumber: random,
        time: time,
        match: random == time.second,
      ));
    }
  }
}
