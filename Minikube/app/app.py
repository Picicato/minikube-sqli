from flask import Flask
from prometheus_client import make_wsgi_app, Gauge
from werkzeug.middleware.dispatcher import DispatcherMiddleware

app = Flask(__name__)
metrics_app = make_wsgi_app()
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {"/metrics": metrics_app})

# Métrique personnalisée pour déclencher une alerte
CUSTOM_ALERT = Gauge("custom_alert", "Alerte personnalisée pour tester Alertmanager")

@app.route("/")
def home():
    return "API d'alerting opérationnelle !"

@app.route("/trigger_alert")
def trigger_alert():
    CUSTOM_ALERT.set(1)  # Déclenche l'alerte
    return "Alerte déclenchée ! (custom_alert=1)"

@app.route("/resolve_alert")
def resolve_alert():
    CUSTOM_ALERT.set(0)  # Résout l'alerte
    return "Alerte résolue ! (custom_alert=0)"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
