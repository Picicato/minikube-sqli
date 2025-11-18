from flask import Flask, request, jsonify
import logging
import os

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200

@app.route("/alert", methods=["POST"])
def alert():
    payload = request.get_json()
    # Ici tu peux filtrer, enrichir, relayer vers Slack/Email/etc.
    # Exemple : log + print des alertes.
    logging.info("Received alert from Alertmanager: %s", payload)
    # Exemple d'action simple : récupérer les alertes et afficher un résumé
    alerts = payload.get("alerts", [])
    for a in alerts:
        status = a.get("status")
        labels = a.get("labels", {})
        annotations = a.get("annotations", {})
        logging.info("Alert: status=%s, labels=%s, annotations=%s", status, labels, annotations)
        # TODO: appeler API tiers ici (Slack, MS Teams, ticketing...)
    return jsonify({"received": len(alerts)}), 200

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
