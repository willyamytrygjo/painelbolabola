import os
import time
from collections import defaultdict, deque
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse


HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", "3000"))
VIEW_FILE = Path(__file__).with_name("view.js")
PUBLIC_DIR = Path(__file__).with_name("public")
RATE_WINDOW_SECONDS = 60
RATE_LIMIT = 60
MAX_PATH_LENGTH = 2048
request_times: dict[str, deque[float]] = defaultdict(deque)


class ApiHandler(BaseHTTPRequestHandler):
    server_version = "SpeakFlowAPI"
    sys_version = ""

    def send_cors_headers(self, content_type: str) -> None:
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Content-Type", content_type)
        self.send_header("Cross-Origin-Resource-Policy", "cross-origin")
        self.send_header("Permissions-Policy", "camera=(), microphone=(), geolocation=(), payment=(), usb=()")
        self.send_header("Referrer-Policy", "no-referrer")
        self.send_header("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")

    def client_key(self) -> str:
        return self.client_address[0]

    def rate_limited(self) -> bool:
        now = time.monotonic()
        attempts = request_times[self.client_key()]
        while attempts and now - attempts[0] > RATE_WINDOW_SECONDS:
            attempts.popleft()
        if len(attempts) >= RATE_LIMIT:
            return True
        attempts.append(now)
        if len(request_times) > 10_000:
            for key in list(request_times):
                if not request_times[key]:
                    del request_times[key]
        return False

    def do_OPTIONS(self) -> None:
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.send_header("Access-Control-Max-Age", "600")
        self.end_headers()

    def do_GET(self) -> None:
        if len(self.path) > MAX_PATH_LENGTH:
            self.send_text(414, "URI muito longa")
            return

        route = urlparse(self.path).path

        if route in ("/", "/index.html"):
            self.send_file(PUBLIC_DIR / "index.html", "text/html; charset=utf-8")
            return

        if route in ("/app.js", "/styles.css"):
            file_path = PUBLIC_DIR / route.lstrip("/")
            content_type = "application/javascript; charset=utf-8" if route.endswith(".js") else "text/css; charset=utf-8"
            self.send_file(file_path, content_type)
            return

        if route in ("/bypass.js", "/view.js"):
            if self.rate_limited():
                self.send_response(429)
                self.send_cors_headers("text/plain; charset=utf-8")
                self.send_header("Retry-After", str(RATE_WINDOW_SECONDS))
                self.end_headers()
                self.wfile.write(b"Muitas requisicoes; tente novamente depois")
                return
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

    def do_POST(self) -> None:
        self.send_text(405, "Método não permitido")
        self.close_connection = True

    do_PUT = do_POST
    do_PATCH = do_POST
    do_DELETE = do_POST

    def send_text(self, status: int, body: str, content_type: str = "text/plain; charset=utf-8") -> None:
        encoded = body.encode("utf-8")
        self.send_response(status)
        self.send_cors_headers(content_type)
        if status == 405:
            self.send_header("Allow", "GET, OPTIONS")
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        self.wfile.write(encoded)

    def send_file(self, file_path: Path, content_type: str) -> None:
        try:
            body = file_path.read_bytes()
        except OSError:
            self.send_text(404, "Não encontrado")
            return
        self.send_response(200)
        self.send_cors_headers(content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format: str, *args: object) -> None:
        print(f"{self.address_string()} - {format % args}")


if __name__ == "__main__":
    ThreadingHTTPServer.daemon_threads = True
    server = ThreadingHTTPServer((HOST, PORT), ApiHandler)
    print(f"API disponível em http://localhost:{PORT}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nAPI encerrada")
    finally:
        server.server_close()
