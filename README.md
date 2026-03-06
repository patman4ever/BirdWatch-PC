# 🐦 BirdWatch-PC

Windows versie van [BirdWatch](https://github.com/patman4ever/BirdWatch), draaiend via Docker Desktop.  
Herkent vogelgeluiden via BirdNET en toont resultaten in een web dashboard op `http://localhost:7766`.

---

## ✅ Vereisten

| Software | Versie | Download |
|---|---|---|
| Windows | 10 / 11 (64-bit) | — |
| Docker Desktop | ≥ 4.20 | [docker.com](https://www.docker.com/products/docker-desktop) |
| Git | Nieuwste | [git-scm.com](https://git-scm.com) |

> **WSL2 backend** moet ingeschakeld zijn in Docker Desktop (standaard het geval op moderne installaties).

---

## 🚀 Snelstart

### Optie A — Dubbelklik (makkelijkst)

1. Download of clone deze repo
2. Dubbelklik op **`birdwatch.bat`**
3. Kies **1** om te installeren, dan **2** om te starten
4. Open je browser op **http://localhost:7766**

---

### Optie B — PowerShell

```powershell
# Eenmalige installatie
.\birdwatch.ps1 -Install

# Starten
.\birdwatch.ps1 -Start

# Stoppen
.\birdwatch.ps1 -Stop

# Updaten naar nieuwste versie
.\birdwatch.ps1 -Update

# Logs bekijken
.\birdwatch.ps1 -Logs
```

> Als PowerShell meldt dat scripts niet mogen worden uitgevoerd:
> ```powershell
> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
> ```

---

### Optie C — Docker Compose handmatig

```bash
# Image ophalen
docker compose pull

# Starten (op de achtergrond)
docker compose up -d

# Stoppen
docker compose down
```

---

## ⚙️ Configuratie

Pas het bestand **`.env`** aan (wordt aangemaakt bij installatie):

```env
TZ=Europe/Amsterdam       # Tijdzone
LATITUDE=51.9             # Jouw breedtegraad
LONGITUDE=4.5             # Jouw lengtegraad
MIN_CONFIDENCE=0.7        # Minimale betrouwbaarheid (0.0 – 1.0)
SENSITIVITY=1.0           # BirdNET gevoeligheid
```

Herstart na aanpassen:
```powershell
.\birdwatch.ps1 -Stop
.\birdwatch.ps1 -Start
```

---

## 🎙️ Microfoon / geluidskaart

Op Windows gebruikt Docker de microfoon via **WSL2 audio forwarding**.  
Zorg dat je microfoon toegankelijk is:

1. Open Docker Desktop → Settings → Resources → WSL Integration
2. Schakel je WSL2 distro in
3. Sluit een microfoon aan (USB of 3.5mm)

---

## 📁 Mappenstructuur

```
BirdWatch-PC/
├── .github/
│   └── workflows/
│       └── docker-build.yml   # Automatische Docker builds
├── data/
│   ├── recordings/            # Opgenomen geluidsbestanden
│   └── detections/            # Herkende vogels (JSON/CSV)
├── config/                    # Configuratiebestanden
├── Dockerfile                 # Docker image definitie
├── docker-compose.yml         # Services configuratie
├── requirements.txt           # Python dependencies
├── birdwatch.ps1              # PowerShell launcher
├── birdwatch.bat              # Batch launcher (dubbelklik)
└── .env                       # Jouw instellingen (lokaal, niet in git)
```

---

## 🔄 Automatische updates (GitHub Actions)

Bij elke push naar `main` wordt automatisch een nieuwe Docker image gebouwd en gepubliceerd op  
`ghcr.io/patman4ever/birdwatch-pc:latest`

Gebruik `.\birdwatch.ps1 -Update` om de nieuwste versie op te halen.

---

## 🐞 Problemen?

| Probleem | Oplossing |
|---|---|
| Dashboard niet bereikbaar | Controleer of Docker Desktop draait |
| Geen vogeldetecties | Controleer microfoon in Windows instellingen |
| PowerShell script geblokkeerd | Zie Optie B hierboven |
| Image wordt niet gevonden | Voer `docker compose pull` uit |

Logs bekijken: `.\birdwatch.ps1 -Logs`

---

## 🔗 Gerelateerd

- [BirdWatch (Raspberry Pi)](https://github.com/patman4ever/BirdWatch) — originele versie
- [BirdNET-Analyzer](https://github.com/kahst/BirdNET-Analyzer) — onderliggend AI model
