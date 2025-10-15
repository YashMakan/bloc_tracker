import 'package:bloc/bloc.dart';
import 'package:bloc_tracker/src/bloc_tracker_settings.dart';
import 'package:bloc_tracker/src/models/event_trace.dart';
import 'package:bloc_tracker/src/models/thresholds.dart';
import 'package:bloc_tracker/src/server/bloc_tracker_server.dart';
import 'package:bloc_tracker/src/utils/formatter.dart';
import 'package:meta/meta.dart';

part 'models/bloc_breakpoint.dart';

/// A handler function that processes a completed [EventTrace].
typedef TraceHandler = void Function(EventTrace trace);

/// The signature for a trackable event handler function.
/// It's similar to BLoC's `EventHandler` but includes a [BlocBreakpoint] object.
typedef TrackedEventHandler<E, S> =
    Future<void> Function(E event, Emitter<S> emit, BlocBreakpoint bp);

/// A tracker for BLoC event performance.
/// It captures event traces and outputs them via the provided [onTrace] handler.
class BlocTracker {
  /// Creates an instance of the BLoC tracker.
  ///
  /// [onTrace]: A custom handler to process completed traces.
  /// If not provided, a default handler will be used which prints a
  /// formatted string to the console.
  ///
  /// [settings]: Configuration for thresholds and behavior.
  BlocTracker({
    TraceHandler? onTrace,
    this.settings = const BlocTrackerSettings(),
  }) {
    _userOnTrace = onTrace ?? (settings.launch ? null : _defaultPrintHandler);

    if (settings.launch) {
      _server = BlocTrackerServer();
      _server!.start();
    }
  }

  final BlocTrackerSettings settings;
  late TraceHandler? _userOnTrace;
  BlocTrackerServer? _server;

  @internal
  final Map<String, EventTrace> traces = {};

  void _defaultPrintHandler(EventTrace trace) {
    print(defaultTraceFormatter(trace, settings));
  }

  /// Called by the observer when a trace is complete.
  @internal
  void onTraceComplete(EventTrace trace) {
    _server?.broadcastTrace(trace);
    _userOnTrace?.call(trace);
  }

  /// Wraps a BLoC event handler to provide automatic performance tracking.
  ///
  /// Use this inside your BLoC's constructor in place of a direct handler.
  /// It provides the `BlocBreakpoint` object directly to your logic.
  ///
  /// ```dart
  /// class MyBloc extends Bloc<MyEvent, MyState> {
  ///   MyBloc() : super(InitialState()) {
  ///     // Use tracker.on to wrap your handler
  ///     on<FetchData>(tracker.on(this, _onFetchData));
  ///   }
  ///
  ///   // The handler now receives the `bp` object automatically.
  ///   Future<void> _onFetchData(FetchData event, Emitter<MyState> emit, BlocBreakpoint bp) async {
  ///     bp.add('api_call');
  ///     // ...
  ///   }
  /// }
  /// ```
  Future<void> Function(E event, Emitter<S> emit) on<E extends Object, S>(
    Bloc bloc,
    TrackedEventHandler<E, S> handler,
  ) {
    return (E event, Emitter<S> emit) async {
      final bp = start(bloc, event);
      await handler(event, emit, bp);
    };
  }

  /// Creates a contextual breakpoint tracker for the given [bloc] and [event].
  BlocBreakpoint start(Bloc bloc, Object? event) {
    return BlocBreakpoint._(this, bloc, event);
  }

  /// Generates a unique key for an event trace.
  @internal
  String getTraceKey(Bloc bloc, Object? event) =>
      '${bloc.hashCode}-${event.hashCode}';

  /// Records a new performance breakpoint.
  /// This is now intended for internal use by the [BlocBreakpoint] class.
  @internal
  void breakpoint(
    Bloc bloc,
    Object? event, [
    String? name,
    Thresholds? thresholds,
  ]) {
    final key = getTraceKey(bloc, event);
    traces[key]?.recordBreakpoint(name, thresholds);
  }

  /// Internal handler for bp.raise()
  @internal
  void raiseError(
    Bloc bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final key = getTraceKey(bloc, event);
    final trace = traces[key];
    if (trace == null) return;

    final effectiveError = error ?? 'Manually flagged error';

    trace.errors.add(TraceError(effectiveError, stackTrace));

    final currentBreakpoint = trace.getRunningBreakpoint();
    if (currentBreakpoint != null) {
      currentBreakpoint.error = effectiveError;
      currentBreakpoint.stackTrace = stackTrace;
      currentBreakpoint.stop();
    }
  }

  /// Explicitly stops a performance breakpoint.
  /// This is now intended for internal use by the [BlocBreakpoint] class.
  @internal
  void stopBreakpoint(Bloc bloc, Object? event, String name) {
    final key = getTraceKey(bloc, event);
    traces[key]?.stopBreakpoint(name);
  }
}
