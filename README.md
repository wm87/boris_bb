# Bodenrichtwerte in Brandenburg als WMS

Dieses Projekt stellt die Bodenrichtwerte des Landes Brandenburg als **WMS-Dienst (Web Map Service)** bereit. Die Bodenrichtwerte dienen der Orientierung über den Wert von Grundstücken und können in GIS-Anwendungen eingebunden werden.

## Inhalt

- **Datenquelle:**  
  Landesvermessung und Geobasisinformation Brandenburg (LGB), Landesamt für Vermessung und Geobasisinformation Brandenburg (LVERMGeo)
- **Technische Umsetzung:**  
  - Bash-Skripte zur Datenvorbereitung und Automatisierung
  - MapServer Version **8.4+** als WMS-Server
- **Bereitstellung:**  
  Der Dienst wird über MapServer als WMS-Endpunkt veröffentlicht.

## Voraussetzungen

Um den Dienst selbst zu betreiben, benötigst du:

- Linux-Server oder kompatible Umgebung
- Bash (Shell)
- [MapServer](https://mapserver.org/) ab Version **8.4**
- Webserver (z. B. Apache oder NGINX)
- Zugriff auf die Bodenrichtwertdaten des LVermGeo Brandenburg
