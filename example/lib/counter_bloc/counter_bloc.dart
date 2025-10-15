import 'package:bloc/bloc.dart';
import 'package:bloc_tracker/bloc_tracker.dart';
import 'package:example/main.dart';
import 'package:meta/meta.dart';

part 'counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    // Option 1: Use the on() method provided by the library
    on<IncrementCounter>(tracker.on(this, _onIncrement));
    // Option 2: Initialize the bp directly inside the event handler
    on<DecrementCounter>(_onDecrement);
  }

  Future<void> _onIncrement(
    IncrementCounter event,
    Emitter<int> emit,
    BlocBreakpoint bp,
  ) async {
    bp.add('api_call', Thresholds(severe: 10.ms));

    await Future.delayed(const Duration(milliseconds: 150));
    final valueFromDb = state;

    /// This is useful for functional error handling, like with `Either.fold`.
    /// ```dart
    /// result.fold(
    ///   (failure) => bp.raise(failure),
    ///   (success) => // continue...
    /// );
    bp.raise(Exception('db blew up!'));

    bp.add('calculation');

    await Future.delayed(const Duration(milliseconds: 80));
    final result = valueFromDb + 1;

    bp.add('update_local_storage');

    await Future.delayed(const Duration(milliseconds: 120));

    emit(result);
  }

  Future<void> _onDecrement(DecrementCounter event, Emitter<int> emit) async {
    final bp = tracker.start(this, event);

    bp.add('quick_math');
    // No delay, so this will be very fast
    emit(state - 1);
  }
}
