import 'package:bloc_tracker/src/models/thresholds.dart';

/// Settings for the BlocTrackerObserver.
class BlocTrackerSettings {
  const BlocTrackerSettings({
    this.enabled = true,
    this.threshold = const Thresholds(
      warning: Duration(milliseconds: 100),
      severe: Duration(milliseconds: 300),
    ),
    this.breakpointThreshold = const Thresholds(
      warning: Duration(milliseconds: 50),
      severe: Duration(milliseconds: 150),
    ),
    this.printErrors = true,
    this.printStackTraces = false,
    this.launch = false,
  });

  /// Master switch to enable or disable all tracking.
  final bool enabled;

  /// Defines the performance thresholds for the entire event/cubit handler trace.
  final Thresholds threshold;

  /// Defines the default performance thresholds for individual breakpoints.
  /// This can be overridden on a per-breakpoint basis.
  final Thresholds breakpointThreshold;

  /// Defaults to `true`.
  final bool printErrors;

  /// Defaults to `false` as stack traces can be verbose.
  final bool printStackTraces;

  /// When `true`, a URL will be printed to the console.
  /// Defaults to `false`. This feature is not available on web builds.
  final bool launch;
}