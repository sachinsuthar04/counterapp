part of 'counter_bloc.dart';

sealed class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

/// This is an Event class
///
/// This will be handled using controller
/// [CounterBloc]
class GenerateRandomNumber extends CounterEvent {}
