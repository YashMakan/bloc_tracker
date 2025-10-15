part of 'counter_bloc.dart';

@immutable
sealed class CounterEvent {}

class IncrementCounter extends CounterEvent {}

class DecrementCounter extends CounterEvent {}