part of 'bloc_tracker_server.dart';

const String cssContent = '''
  :root {
      --bg-color: #1a1a1a;
      --text-color: #e0e0e0;
      --border-color: #444;
      --header-bg: #252526;
      --entry-bg: #2d2d2d;
      --normal-color: #00b894;
      --warning-color: #fdcb6e;
      --severe-color: #e17055;
      --error-color: #d63031;
  }
  body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background-color: var(--bg-color);
      color: var(--text-color);
      margin: 0;
      padding: 0;
  }
  header {
      background-color: var(--header-bg);
      padding: 1rem 1.5rem;
      border-bottom: 1px solid var(--border-color);
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: sticky;
      top: 0;
      z-index: 10;
  }
  header h1 { margin: 0; font-size: 1.2rem; }
  #status-light {
      width: 12px; height: 12px;
      border-radius: 50%;
      transition: background-color 0.3s;
  }
  .disconnected { background-color: #d63031; }
  .connected { background-color: #00b894; }
  main {
      padding: 1rem;
      display: flex;
      flex-direction: column;
      gap: 1rem;
  }
  .log-entry {
      background-color: var(--entry-bg);
      border: 1px solid var(--border-color);
      border-radius: 8px;
      overflow: hidden;
      animation: fadeIn 0.5s ease-out;
  }
  .log-header {
      padding: 0.8rem 1rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid var(--border-color);
  }
  .log-header h2 {
      margin: 0;
      font-size: 1rem;
      font-weight: 600;
  }
  .log-header .status-tag {
      padding: 0.2rem 0.6rem;
      border-radius: 12px;
      font-size: 0.8rem;
      font-weight: bold;
  }
  .log-entry.normal .status-tag { background-color: var(--normal-color); color: #111; }
  .log-entry.warning .status-tag { background-color: var(--warning-color); color: #111; }
  .log-entry.severe .status-tag { background-color: var(--severe-color); color: var(--text-color); }
  .log-entry.error .status-tag { background-color: var(--error-color); color: var(--text-color); }
  .log-details { padding: 1rem; }
  .breakpoints-list {
      list-style: none;
      padding: 0;
      margin: 0;
  }
  .breakpoint-item {
      display: flex;
      justify-content: space-between;
      padding: 0.4rem 0;
      border-bottom: 1px solid #3a3a3a;
  }
  .breakpoint-item:last-child { border-bottom: none; }
  .breakpoint-item .name { font-family: "SF Mono", "Fira Code", monospace; }
  .breakpoint-item .duration { font-weight: 600; }
  .bp-status.warning { color: var(--warning-color); }
  .bp-status.severe { color: var(--severe-color); }
  .bp-status.error { color: var(--error-color); }
  .error-details {
      margin-top: 1rem;
      padding: 0.8rem;
      background-color: rgba(214, 48, 49, 0.1);
      border-radius: 4px;
      border-left: 3px solid var(--error-color);
  }
  .error-details pre {
      white-space: pre-wrap;
      word-wrap: break-word;
      margin: 0;
  }
  @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
  }
  ''';