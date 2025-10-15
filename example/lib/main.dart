import 'package:bloc_tracker/bloc_tracker.dart';
import 'package:example/counter_bloc/counter_bloc.dart';
import 'package:example/counter_page.dart';
import 'package:example/send_logs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Create a global instance of your tracker or better use a service locator like get_it
final tracker = BlocTracker(
  settings: BlocTrackerSettings(
    launch: true,
    threshold: Thresholds(
      warning: 200.ms,
      severe: 500.ms,
    ),
    breakpointThreshold: Thresholds(
      warning: 200.ms,
      severe: 1000.ms,
    ),
  ),
  onTrace: sendTraceToMonitoringService,

);

void main() {
  Bloc.observer = BlocTrackerObserver(tracker: tracker);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const MaterialApp(home: CounterPage()),
    );
  }
}
