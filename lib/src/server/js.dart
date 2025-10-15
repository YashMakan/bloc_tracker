part of 'bloc_tracker_server.dart';

String jsContent(int port) => '''
  document.addEventListener('DOMContentLoaded', () => {
      const logContainer = document.getElementById('log-container');
      const statusLight = document.getElementById('status-light');
      let socket;

      function connect() {
          socket = new WebSocket(`ws://localhost:$port/ws`);

          socket.onopen = () => {
              statusLight.classList.remove('disconnected');
              statusLight.classList.add('connected');
              statusLight.title = 'Connected';
          };

          socket.onmessage = (event) => {
              const trace = JSON.parse(event.data);
              renderTrace(trace);
          };

          socket.onclose = () => {
              statusLight.classList.remove('connected');
              statusLight.classList.add('disconnected');
              statusLight.title = 'Disconnected. Attempting to reconnect...';
              setTimeout(connect, 2000); // Try to reconnect every 2 seconds
          };

          socket.onerror = (error) => {
              console.error('WebSocket Error:', error);
              socket.close();
          };
      }

      function renderTrace(trace) {
          const entry = document.createElement('div');
          entry.className = `log-entry \${trace.status}`;

          const breakpointsHTML = trace.breakpoints.map(bp => `
              <li class="breakpoint-item">
                  <span class="name \${bp.status}">\${bp.name}</span>
                  <span class="duration bp-status \${bp.status}">\${bp.elapsed_ms}ms</span>
              </li>
          `).join('');

          const errorsHTML = trace.errors.map(err => `
              <div class="error-details">
                  <strong>Error:</strong>
                  <pre>\${escapeHtml(err.error)}</pre>
                  \${err.stack_trace ? `<strong>Stack Trace:</strong><pre>\${escapeHtml(err.stack_trace)}</pre>` : ''}
              </div>
          `).join('');

          entry.innerHTML = `
              <div class="log-header">
                  <h2>\${trace.bloc_type} &rsaquo; \${trace.event_type}</h2>
                  <span class="status-tag">\${trace.status.toUpperCase()} in \${trace.total_elapsed_ms}ms</span>
              </div>
              <div class="log-details">
                  <ul class="breakpoints-list">
                      \${breakpointsHTML}
                  </ul>
                  \${errorsHTML}
              </div>
          `;

          logContainer.prepend(entry);
      }
      
      function escapeHtml(unsafe) {
          return unsafe
               .replace(/&/g, "&amp;")
               .replace(/</g, "&lt;")
               .replace(/>/g, "&gt;")
               .replace(/"/g, "&quot;")
               .replace(/'/g, "&#039;");
      }

      connect();
  });
  ''';