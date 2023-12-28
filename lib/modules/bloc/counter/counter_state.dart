part of 'counter_bloc.dart';

class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object?> get props => [];
}

class CounterInitial extends CounterState {
  final int? randomNumber;
  final DateTime? time;
  final bool match;

  const CounterInitial({
    this.randomNumber,
    this.time,
    this.match = false,
  });

  @override
  List<Object?> get props => [randomNumber, time, match];

  CounterInitial copyWith({
    int? randomNumber,
    DateTime? time,
    bool? match,
  }) {
    return CounterInitial(
      randomNumber: randomNumber ?? this.randomNumber,
      time: time ?? this.time,
      match: match ?? this.match,
    );
  }
}
