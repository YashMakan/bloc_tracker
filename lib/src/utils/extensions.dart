/// Provides convenient extension methods on [num] to create [Duration] objects.
///
/// Example:
/// ```dart
/// final duration = 100.ms;
/// final halfSecond = 0.5.s;
/// ```
extension DurationNumX on num {
  /// Returns a [Duration] of this number of microseconds.
  /// Handles both integers and doubles.
  Duration get micro => Duration(microseconds: (this).round());

  /// Returns a [Duration] of this number of milliseconds.
  /// Handles both integers and doubles.
  Duration get ms => Duration(microseconds: (this * 1000).round());

  /// Returns a [Duration] of this number of seconds.
  /// Handles both integers and doubles.
  Duration get s => Duration(microseconds: (this * 1000000).round());
}