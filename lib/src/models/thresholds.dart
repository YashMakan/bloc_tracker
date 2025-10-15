/// Represents the performance status of a trace or breakpoint.
enum TraceStatus {
  /// The operation completed within the warning threshold.
  normal,

  /// The operation completed after the warning threshold but before the severe threshold.
  warning,

  /// The operation completed after the severe threshold.
  severe,

  /// The operation failed due to an exception or was manually raised.
  error,
}

/// Defines warning and severe duration thresholds for performance monitoring.
class Thresholds {
  /// The duration after which a trace is considered a 'warning'.
  final Duration? warning;

  /// The duration after which a trace is considered a 'severe'.
  final Duration? severe;

  /// Creates a new set of thresholds.
  ///
  /// The [severe] duration should be greater than or equal to the [warning] duration.
  const Thresholds({
    this.warning,
    this.severe,
  });

  /// A convenience constructor for thresholds that should never be triggered.
  const Thresholds.none()
      : warning = const Duration(days: 365),
        severe = const Duration(days: 365);
}