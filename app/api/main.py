from fastapi import FastAPI
from fastapi.responses import JSONResponse
import time
import os
import random

app = FastAPI(title="netchaos-api")

BASE_DELAY_MS = int(os.getenv("BASE_DELAY_MS", "15"))

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/api/compute")
def compute(n: int = 50000):
    # Small CPU work to make latency visible under chaos
    start = time.time()
    s = 0
    for i in range(n):
        s += (i * 3) % 97
    # small baseline delay
    time.sleep(BASE_DELAY_MS / 1000.0)
    took_ms = int((time.time() - start) * 1000)
    return JSONResponse({"result": s, "took_ms": took_ms})
