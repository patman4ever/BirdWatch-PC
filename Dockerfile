# BirdWatch-PC — Windows/Docker image
# Gebaseerd op de Raspberry Pi versie, aangepast voor x86_64 / amd64

FROM python:3.11-slim-bookworm

LABEL maintainer="patman4ever"
LABEL description="BirdWatch — BirdNET geluidherkenning + web dashboard (Windows/Docker)"

# Systeem dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsndfile1 \
    alsa-utils \
    pulseaudio-utils \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Werkdirectory
WORKDIR /app

# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# App broncode kopiëren
COPY . .

# Data mappen aanmaken
RUN mkdir -p /data/recordings /data/detections /config

# Standaard poort voor het dashboard
EXPOSE 7766

# Standaard startcommando: BirdNET analyse
CMD ["python", "birdnet_analysis.py"]
