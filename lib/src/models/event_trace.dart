import 'package:bloc/bloc.dart';
import 'package:bloc_tracker/bloc_tracker.dart';
import 'package:bloc_tracker/src/utils/formatter.dart';


/// A helper class to pair an error with its optional stack trace.
class TraceError {
  final Object error;
  final StackTrace? stackTrace;

  TraceError(this.error, [this.stackTrace]);

  Map<String, dynamic> toJson() => {
    'error': error.toString(),
    'stack_trace': stackTrace?.toString(),
  };
}


/// Represents a single tracked breakpoint within an event handler.
class Breakpoint {
  Breakpoint(this.name, {
    this.customThresholds,
  }) : stopwatch = Stopwatch()..start();

  final String name;
  final Stopwatch stopwatch;
  final Thresholds? customThresholds;
  Duration? elapsed;
  Object? error;
  StackTrace? stackTrace;

  /// Determines the performance status of this breakpoint.
  /// It uses its [customThresholds] if available, otherwise it falls back
  /// to the provided [globalThresholds].
  TraceStatus getStatus(Thresholds globalThresholds) {
    if (error != null) return TraceStatus.error;

    final effective = customThresholds ?? globalThresholds;
    final e = elapsed;
    if (e == null) return TraceStatus.normal;

    if (e > (effective.severe ?? Duration.zero)) return TraceStatus.severe;
    if (e > (effective.warning ??  Duration.zero)) return TraceStatus.warning;
    return TraceStatus.normal;
  }

  void stop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      elapsed = stopwatch.elapsed;
    }
  }

  Map<String, dynamic> toJson(Thresholds globalThresholds) => {
    'name': name,
    'elapsed_ms': elapsed?.inMilliseconds,
    'status': getStatus(globalThresholds).name,
    'error': error?.toString(),
    'stack_trace': stackTrace?.toString(),
  };
}

/// Represents the complete performance trace for a single BLoC event.
class EventTrace {
  EventTrace({
    required this.bloc,
    required this.event,
    required this.settings,
  }) : stopwatch = Stopwatch()..start();

  final Bloc bloc;
  final Object? event;
  final BlocTrackerSettings settings;
  final Stopwatch stopwatch;
  final List<Breakpoint> breakpoints = [];
  int _breakpointCounter = 0;

  Duration? totalElapsed;
  final List<TraceError> errors = [];


  /// Determines the performance status of the entire trace based on its total duration.
  TraceStatus get status {
    if (errors.isNotEmpty) return TraceStatus.error;

    final e = totalElapsed;
    if (e == null) return TraceStatus.normal;

    if (e > (settings.threshold.severe ?? Duration.zero)) return TraceStatus.severe;
    if (e > (settings.threshold.warning ?? Duration.zero)) return TraceStatus.warning;
    return TraceStatus.normal;
  }

  /// Records a new breakpoint, optionally with custom performance thresholds.
  void recordBreakpoint([String? name, Thresholds? thresholds]) {
    final runningBreakpoint = getRunningBreakpoint();
    runningBreakpoint?.stop();

    _breakpointCounter++;
    final breakpointName = name ?? 'Breakpoint #$_breakpointCounter';
    breakpoints.add(Breakpoint(
      breakpointName,
      customThresholds: thresholds,
    ));
  }

  /// Explicitly stops a breakpoint by its name.
  /// Useful for the final breakpoint in an event handler.
  void stopBreakpoint(String name) {
    try {
      final breakpoint = breakpoints.lastWhere(
            (b) => b.name == name && b.stopwatch.isRunning,
      );
      breakpoint.stop();
    } catch (_) {
      // Ignore
    }
  }

  /// Completes the trace, stopping the main timer and any unstopped breakpoints.
  void complete({Object? error, StackTrace? stackTrace}) {
    stopwatch.stop();
    totalElapsed = stopwatch.elapsed;

    if (error != null) {
      errors.add(TraceError(error, stackTrace));
    }

    getRunningBreakpoint()?.stop();
  }

  Breakpoint? getRunningBreakpoint() {
    if (breakpoints.isEmpty) return null;
    final last = breakpoints.last;
    return last.stopwatch.isRunning ? last : null;
  }

  void prettyPrint() {
    print(defaultTraceFormatter(this, settings));
  }

  Map<String, dynamic> toJson() {
    return {
      'bloc_type': bloc.runtimeType.toString(),
      'event_type': event.runtimeType.toString(),
      'total_elapsed_ms': totalElapsed?.inMilliseconds,
      'status': status.name,
      'errors': errors.map((e) => e.toJson()).toList(),
      'breakpoints': breakpoints
          .map((bp) => bp.toJson(settings.breakpointThreshold))
          .toList(),
    };
  }
}