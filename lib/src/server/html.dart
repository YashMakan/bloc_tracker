part of 'bloc_tracker_server.dart';

const String htmlContent = '''
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>BlocTracker Live</title>
      <link rel="stylesheet" href="/styles.css">
  </head>
  <body>
      <header>
          <h1>BlocTracker Live</h1>
          <div id="status-light" class="disconnected" title="Disconnected"></div>
      </header>
      <main id="log-container"></main>
      <script src="/script.js"></script>
  </body>
  </html>
  ''';