from fastapi import FastAPI
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from starlette.responses import Response

app = FastAPI()

ATTACKS = Counter("attack_attempts_total", "Number of simulated attacks")

@app.get("/")
async def root():
	return {"message": "Attack simulator API - alive"}

@app.post("/simulate_attack")
async def simulate_attack():
	ATTACKS.inc()
	return {"status": "attack recorded"}


@app.get("/metrics")
async def metrics():
	data = generate_latest()
	return Response(content=data, media_type=CONTENT_TYPE_LATEST)
