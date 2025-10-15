import 'package:bloc_tracker/bloc_tracker.dart';

// Example of a custom onTrace handler for structured logging
void sendTraceToMonitoringService(EventTrace trace) {
  final report = trace.toJson();

  // Pretty-print the trace if needed
  trace.prettyPrint();

  // In a real app, you would send this JSON to your logging backend
  // MyLoggingService.sendPerformanceReport(report);
  // example: {bloc_type: CounterBloc, event_type: IncrementCounter, total_elapsed_ms: 235, status: error, errors: [{error: Exception: db blew up!, stack_trace: null}], breakpoints: [{name: database_read, elapsed_ms: 152, status: error, error: Exception: db blew up!, stack_trace: null}, {name: calculation, elapsed_ms: 83, status: normal, error: null, stack_trace: null}]}
  print('--- STRUCTURED LOG ---');
  print(report);
  print('----------------------');
}