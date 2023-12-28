part of 'success_bloc.dart';

class SuccessState extends Equatable {
  const SuccessState();

  @override
  List<Object?> get props => [];
}

class SuccessInitial extends SuccessState {
  final int successCounter;
  final int attempts;
  final int penalty;

  const SuccessInitial({
    this.successCounter = 0,
    this.attempts = 0,
    this.penalty = 0,
  });

  @override
  List<Object?> get props => [successCounter, attempts, penalty];

  SuccessInitial copyWith({
    int? successCounter,
    int? attempts,
    int? penalty,
  }) {
    return SuccessInitial(
      successCounter: successCounter ?? this.successCounter,
      attempts: attempts ?? this.attempts,
      penalty: penalty ?? this.penalty,
    );
  }
}
