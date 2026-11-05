from http.server import BaseHTTPRequestHandler, HTTPServer


def saludo(nombre):
    return f"Hola, {nombre}!"


class AppHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            respuesta = "OK"
            self.send_response(200)
        else:
            respuesta = (
                f"{saludo('DevOps')}\n"
                f"{saludo('Mundo')}\n"
                "Aplicacion desplegada en Kubernetes con Helm.\n"
            )
            self.send_response(200)

        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(respuesta.encode("utf-8"))


if __name__ == "__main__":
    servidor = HTTPServer(("0.0.0.0", 8000), AppHandler)
    print("Servidor iniciado en el puerto 8000")
    servidor.serve_forever()
