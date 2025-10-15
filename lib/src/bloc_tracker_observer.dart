import 'package:bloc/bloc.dart';
import 'package:bloc_tracker/src/bloc_tracker.dart';
import 'package:bloc_tracker/src/models/event_trace.dart';
import 'package:meta/meta.dart';

/// A [BlocObserver] that tracks and logs event performance.
class BlocTrackerObserver extends BlocObserver {
  BlocTrackerObserver({required this.tracker});

  final BlocTracker tracker;

  @override
  @mustCallSuper
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (!tracker.settings.enabled) return;

    final key = tracker.getTraceKey(bloc, event);
    tracker.traces[key] = EventTrace(
      bloc: bloc,
      event: event,
      settings: tracker.settings,
    );
  }

  @override
  @mustCallSuper
  void onDone(
    Bloc bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    super.onDone(bloc, event, error, stackTrace);
    if (!tracker.settings.enabled) return;

    final key = tracker.getTraceKey(bloc, event);
    final trace = tracker.traces.remove(key);

    if (trace == null) return;

    trace.complete(error: error, stackTrace: stackTrace);
    tracker.onTraceComplete(trace);
  }
}
