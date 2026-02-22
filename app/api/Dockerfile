FROM python:3.11-slim

# --- System tools needed for chaos engineering (tc/netem, ping, curl) ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends iproute2 iputils-ping curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
