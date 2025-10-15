import 'dart:convert';
import 'dart:io';
import 'package:bloc_tracker/src/models/event_trace.dart';

part 'html.dart';
part 'css.dart';
part 'js.dart';

/// A self-contained, real-time web server for monitoring BLoC performance traces.
class BlocTrackerServer {
  HttpServer? _server;
  final List<WebSocket> _clients = [];
  int _port = 0;

  /// Starts the HTTP and WebSocket server on an available port.
  Future<void> start() async {
    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      _port = _server!.port;
      print('--- BlocTracker UI available at: http://localhost:$_port ---');

      _server!.listen(_handleRequest);
    } catch (e) {
      print('--- Failed to start BlocTracker UI server: $e ---');
    }
  }

  /// Stops the server and closes all client connections.
  Future<void> stop() async {
    for (final client in _clients) {
      await client.close();
    }
    await _server?.close(force: true);
    print('--- BlocTracker UI server stopped. ---');
  }

  /// Broadcasts a completed event trace to all connected web clients.
  void broadcastTrace(EventTrace trace) {
    if (_clients.isEmpty) return;
    final jsonString = jsonEncode(trace.toJson());
    for (final client in _clients) {
      client.add(jsonString);
    }
  }

  void _handleRequest(HttpRequest request) {
    final path = request.uri.path;
    if (path == '/ws') {
      WebSocketTransformer.upgrade(request).then(_handleWebSocket);
    } else {
      switch (path) {
        case '/':
          request.response
            ..headers.contentType = ContentType.html
            ..write(htmlContent);
          break;
        case '/styles.css':
          request.response
            ..headers.contentType =
            ContentType('text', 'css', charset: 'utf-8')
            ..write(cssContent);
          break;
        case '/script.js':
          request.response
            ..headers.contentType =
            ContentType('application', 'javascript', charset: 'utf-8')
            ..write(jsContent(_port));
          break;
        default:
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found');
      }
      request.response.close();
    }
  }

  void _handleWebSocket(WebSocket socket) {
    _clients.add(socket);
    socket.done.then((_) {
      _clients.remove(socket);
    });
  }
}