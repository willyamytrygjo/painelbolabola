import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse


HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", "3000"))
VIEW_FILE = Path(__file__).with_name("view.js")


class ApiHandler(BaseHTTPRequestHandler):
    def send_cors_headers(self, content_type: str) -> None:
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")
        self.send_header("Content-Type", content_type)
        self.send_header("X-Content-Type-Options", "nosniff")

    def do_OPTIONS(self) -> None:
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self) -> None:
        route = urlparse(self.path).path

        if route in ("/bypass.js", "/view.js"):
            try:
                body = VIEW_FILE.read_bytes()
            except OSError:
                self.send_text(500, "Erro interno: view.js não encontrado")
                return
            self.send_response(200)
            self.send_cors_headers("application/javascript; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        if route == "/health":
            self.send_text(200, '{"ok":true}', "application/json; charset=utf-8")
            return

        self.send_text(404, "Não encontrado")

    def send_text(self, status: int, body: str, content_type: str = "text/plain; charset=utf-8") -> None:
        encoded = body.encode("utf-8")
        self.send_response(status)
        self.send_cors_headers(content_type)
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        self.wfile.write(encoded)

    def log_message(self, format: str, *args: object) -> None:
        print(f"{self.address_string()} - {format % args}")


if __name__ == "__main__":
    server = ThreadingHTTPServer((HOST, PORT), ApiHandler)
    print(f"API disponível em http://localhost:{PORT}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nAPI encerrada")
    finally:
        server.server_close()
