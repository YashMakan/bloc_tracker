## 1.0.1 - 2025-10-15

- Updated README.md to include a banner and web ui image

## [1.0.0] - 2025-10-15

### Added

-   **Initial Release of `bloc_tracker`!** 🎉
-   **Automatic Performance Profiling:** Core functionality to track the total execution time of BLoC event handlers using the `onDone` observer.
-   **Breakpoint Tracking:** Introduced the `BlocBreakpoint` class with the `bp.add()` method to measure the duration of specific, named sections of code within an event handler.
-   **Declarative Handler API:** Added the `tracker.on()` wrapper, providing a clean, declarative way to instrument BLoC event handlers and automatically receive the `bp` object.
-   **Configurable Performance Thresholds:**
    -   Created the `Thresholds` class to define performance budgets.
    -   Added `warning` and `severe` status levels for granular performance feedback.
    -   Thresholds can be set globally in `BlocTrackerSettings` and overridden on a per-breakpoint basis.
-   **Granular Error Reporting:**
    -   Introduced `bp.raise([error, stackTrace])` to manually flag a failure from within an event handler, perfect for functional error patterns (`Either.fold`).
    -   Errors are attached directly to the breakpoint where they occurred, providing precise context.
-   **Real-time Web UI:**
    -   Added a self-contained, local web server that launches via the `launch` setting.
    -   The web UI provides a real-time stream of all BLoC event traces using WebSockets.
-   **Flexible Output & Integration:**
    -   A beautifully formatted, color-coded console logger is enabled by default.
    -   Added the `onTrace` callback in `BlocTracker` to allow for custom integration with any logging or monitoring service.
    -   The `EventTrace` object includes `prettyPrint()` for on-demand console logging and `toJson()` for easy serialization.
-   **Developer Experience Enhancements:**
    -   Added `Duration` extensions (`.ms`, `.s`, `.micro`) for a more readable and concise API when defining thresholds.
    -   Added configurable settings (`printErrors`, `printStackTraces`) to control the verbosity of the console output.