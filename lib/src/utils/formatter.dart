import 'dart:math';
import 'package:bloc_tracker/src/bloc_tracker_settings.dart';
import 'package:bloc_tracker/src/models/event_trace.dart';
import 'package:bloc_tracker/src/models/thresholds.dart';
import 'package:bloc_tracker/src/utils/ansi_color.dart';

String defaultTraceFormatter(EventTrace trace, BlocTrackerSettings settings) {
  final ansi = AnsiColor();
  final lines = <String>[];

  final blocType = trace.bloc.runtimeType;
  final eventType = trace.event.runtimeType;
  final duration = trace.totalElapsed?.inMilliseconds ?? 0;

  // Determine header tag based on trace status
  final traceStatus = trace.status;
  final statusTag = switch (traceStatus) {
    TraceStatus.normal => '',
    TraceStatus.warning => ansi.yellow(' [Warning]'),
    TraceStatus.severe => ansi.red(' [Severe]'),
    TraceStatus.error => ansi.red(' [FAILED]'),
  };

  lines.add('$blocType │ $eventType');
  lines.add('COMPLETED in ${duration}ms');

  // Breakpoints
  if (trace.breakpoints.isNotEmpty) {
    lines.add('Breakpoints:');
    for (final bp in trace.breakpoints) {
      final elapsedMs = bp.elapsed?.inMilliseconds ?? 0;
      final percentage = trace.totalElapsed != null && trace.totalElapsed!.inMilliseconds > 0
          ? (elapsedMs / trace.totalElapsed!.inMilliseconds * 100)
          : 0.0;

      final bpStatus = bp.getStatus(settings.breakpointThreshold);
      final bpTag = switch (bpStatus) {
        TraceStatus.normal => '',
        TraceStatus.warning => ansi.yellow(' [W]'),
        TraceStatus.severe => ansi.red(' [S]'),
        TraceStatus.error => ansi.red(' [E]'),
      };

      // Add the main breakpoint line
      lines.add(' - ${bp.name}: ${elapsedMs}ms (${percentage.toStringAsFixed(1)}%)$bpTag');

      if (settings.printErrors && bp.error != null) {
        lines.add(ansi.red('    - Error:'));
        lines.add(ansi.red('      ${bp.error}'));
      }
      if (settings.printStackTraces && bp.stackTrace != null) {
        lines.add(ansi.red('    - StackTrace:'));
        final stackLines = bp.stackTrace.toString().split('\n');
        for (final line in stackLines) {
          lines.add('      $line');
        }
      }
    }
  }

  final contentWidth = lines.fold<int>(0, (prev, line) => max(prev, AnsiColor.strip(line).length));
  final title = 'BlocTracker$statusTag';
  final headerPadding = contentWidth > AnsiColor.strip(title).length
      ? contentWidth - AnsiColor.strip(title).length
      : 0;
  final topBorder = '\n┌─ $title ${'─' * (headerPadding - 1)}┐';

  final sb = StringBuffer();
  sb.writeln(topBorder);

  for (final line in lines) {
    final strippedLine = AnsiColor.strip(line);
    final padding = ' ' * (contentWidth - strippedLine.length);
    sb.writeln('│ $line$padding │');
  }

  final bottomBorder = '└${'─' * (contentWidth + 2)}┘';
  sb.write(bottomBorder);

  return sb.toString();
}