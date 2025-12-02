from flask import Flask, request, make_response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
import re

app = Flask(__name__)

# Prometheus metric
sqli_counter = Counter(
    "sql_injection_attempts_total",
    "Number of detected SQL injection attempts"
)

# SQLi patterns
PATTERNS = [
    r"' OR 1=1",
    r" OR '1'='1",
    r"--",
    r"DROP TABLE",
    r"UNION SELECT",
]

@app.route("/log", methods=["POST"])
def log():
    data = request.get_json() or {}
    payload = data.get("payload", "")

    for p in PATTERNS:
        if re.search(p, payload, re.IGNORECASE):
            sqli_counter.inc()
            return {"detected": True}, 200

    return {"detected": False}, 200

@app.route("/metrics")
def metrics():
    resp = make_response(generate_latest())
    resp.headers["Content-Type"] = CONTENT_TYPE_LATEST
    return resp

@app.route("/health")
def health():
    return "Ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
