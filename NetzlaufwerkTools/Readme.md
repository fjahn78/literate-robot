# NetzlaufwerkTools

![Pester Tests](https://github.com/fjahn78/literate-robot/actions/workflows/test.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/fjahn78/literate-robot/badge.svg?branch=main)](https://coveralls.io/github/fjahn78/literate-robot?branch=main)

**NetzlaufwerkTools** ist ein PowerShell-Modul, das das sichere Verbinden und Trennen von Netzlaufwerken erleichtert. Es unterstützt verschiedene Mapping-Methoden (z. B. PSDrive und net use), beinhaltet ein flexibles Logging, AD-Authentifizierung zur Validierung von Anmeldeinformationen und bietet Optionen wie ForceReconnect und DryRun.

## Inhaltsverzeichnis

- [Funktionen](#funktionen)
- [Installation](#installation)
- [Verwendung](#verwendung)
- [Konfiguration](#konfiguration)
- [Beispiele](#beispiele)
- [Abhängigkeiten](#abhängigkeiten)
- [Support und Beiträge](#support-und-beiträge)

## Funktionen

Das Modul exportiert folgende Hauptfunktionen:

- **Move-Log**  
  Rotiert das Logfile, wenn eine definierte maximale Größe überschritten wird.

- **Log**  
  Schreibt Logeinträge mit Zeitstempel in das Logfile.

- **IsElevated**  
  Prüft, ob das aktuelle PowerShell-Skript mit Administratorrechten ausgeführt wird.

- **Test-Credentials**  
  Validiert die übergebenen Anmeldeinformationen gegen das Active Directory.

- **Connect-NetDrives**  
  Verbindet definierte Netzlaufwerke unter Verwendung der gewählten Mapping-Methode (PSDrive oder net use). Unterstützt Optionen wie ForceReconnect und DryRun.

- **Disconnect-NetDrives**  
  Trennt die angegebenen Netzlaufwerke.

## Installation

1. Klone oder lade das Repository herunter:

   ```powershell
   git clone https://github.com/fjahn78/fluffy-waffle.git
   ```

2. Kopiere den Ordner `NetzlaufwerkTools` an einen Ort, der im Modulpfad von PowerShell liegt oder importiere ihn direkt:

   ```powershell
   Import-Module "Pfad\zu\NetzlaufwerkTools\NetzlaufwerkTools.psm1"
   ```

3. Alternativ kannst du den Modulordner auch in dein PowerShell-Modulverzeichnis kopieren (z. B. `$env:USERPROFILE\Documents\WindowsPowerShell\Modules\`).

## Verwendung

Das Modul kann in Skripten oder interaktiv genutzt werden. Hier ein Beispiel, wie du Netzlaufwerke verbindest:

```powershell
# Importiere das Modul
Import-Module NetzlaufwerkTools

# Lade die Credentials (hier wird erwartet, dass du eine Variable oder Datei angibst)
$credentialFile = Join-Path -Path (Get-Location) -ChildPath "cred.xml"
$credentials = Get-ValidCredential -CredPath $credentialFile  # Beispiel-Funktion, falls integriert

# Definiere deine Netzlaufwerke als Hashtable-Array
$netDrives = @(
    @{ Name = "H"; Root = "\\server\freigabe1" },
    @{ Name = "G"; Root = "\\server\freigabe2" }
)

# Verbinde die Netzlaufwerke mit der Methode "NetUse" (oder "PSDrive")
Connect-NetDrives -Drives $netDrives -Credential $credentials -Method "NetUse"

# Trenne die Laufwerke wieder
Disconnect-NetDrives -Drives $netDrives -Method "NetUse"
```

### Optionen
- **ForceReconnect:** Erzwingt, dass bereits gemappte Laufwerke zuerst getrennt werden.
- **DryRun:** Simuliert den Vorgang ohne tatsächliche Änderung.

## Konfiguration

- **Logging:**  
  Die Logdatei wird standardmäßig im Modulverzeichnis unter `netzlaufwerke_log.txt` abgelegt. Mit der Funktion `Move-Log` wird das Logfile rotiert, sobald es größer als 1 MB ist.

- **AD-Authentifizierung:**  
  Die Funktion `Test-Credentials` prüft die übergebenen Anmeldeinformationen anhand des LDAP-Pfads. Dieser Pfad kann bei Bedarf über den Parameter angepasst werden.

- **Credential Storage:**  
  Falls du eine Funktion zum Abrufen gültiger Credentials (wie z. B. `Get-ValidCredential`) integriert hast, kannst du hier den Speicherort (z. B. neben dem aufrufenden Skript) konfigurieren.

## Beispiele

Weitere Beispiele und Anwendungsfälle findest du in den Beispielskripten im Repository (z. B. `Example.ps1`):

- **Mapping mit PSDrive:**  
  Verwende `-Method "PSDrive"`, um Netzlaufwerke über New-PSDrive zu verbinden.

- **Mapping mit net use:**  
  Verwende `-Method "NetUse"` für eine systemweite Verbindung, die auch außerhalb von PowerShell-Sitzungen sichtbar ist.

- **Fehlerbehandlung:**  
  Die Funktionen loggen Fehler und geben bei Problemen aussagekräftige Meldungen aus.

## Abhängigkeiten

- **PowerShell 5.1 oder höher** (in Windows)  
- Standardmäßig keine externen Module erforderlich – das Modul verwendet .NET-Klassen zur AD-Authentifizierung und Logging.

## Support und Beiträge

Wenn du Fragen hast, Fehler findest oder Beiträge leisten möchtest, kannst du gerne Issues im Repository erstellen oder einen Pull Request senden.
