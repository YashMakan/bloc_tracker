part of '../bloc_tracker.dart';

/// A contextual breakpoint tracker for a single BLoC event handler.
///
/// Obtain an instance of this class by calling `tracker.start(this, event)`
/// at the beginning of your event handler.
class BlocBreakpoint {
  const BlocBreakpoint._(this._tracker, this._bloc, this._event);

  final BlocTracker _tracker;
  final Bloc _bloc;
  final Object? _event;

  /// Records a new performance breakpoint.
  ///
  /// This method automatically stops the previous breakpoint (if any)
  /// and starts a new one.
  /// If [name] is omitted, an automatic ID will be assigned (e.g., "Breakpoint #1").
  ///
  /// ```dart
  /// final bp = tracker.start(this, event);
  ///
  /// bp.add('api_call');
  /// // ... do api call
  ///
  /// bp.add('processing');
  /// // ... do processing
  /// ```
  void add([String? name, Thresholds? thresholds]) {
    _tracker.breakpoint(_bloc, _event, name, thresholds);
  }

  /// This immediately stops the current breakpoint and records the [error]
  /// on the trace. The overall trace will be marked with `TraceStatus.error`.
  ///
  /// This is useful for functional error handling, like with `Either.fold`.
  /// ```dart
  /// result.fold(
  ///   (failure) => bp.raise(failure),
  ///   (success) => // continue...
  /// );
  /// ```
  void raise([Object? error, StackTrace? stackTrace]) {
    _tracker.raiseError(_bloc, _event, error, stackTrace);
  }

  /// Explicitly stops a performance breakpoint by its [name].
  ///
  /// This is useful if you need to stop the final breakpoint before
  /// the event handler finishes. In most cases, this is not needed as
  /// the observer will handle it automatically.
  void stop(String name) {
    _tracker.stopBreakpoint(_bloc, _event, name);
  }
}