# literate-robot
![Pester Tests](https://github.com/fjahn78/literate-robot/actions/workflows/test.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/fjahn78/literate-robot/badge.svg)](https://coveralls.io/github/fjahn78/literate-robot)

**Literate-Robot** ist ein PowerShell-Modul zur Verwaltung von Netzlaufwerken. Es bietet eine Sammlung von Funktionen, die es ermöglichen, Netzlaufwerke zu verbinden, zu trennen und ihre Verfügbarkeit zu prüfen. Zusätzlich bietet das Modul erweiterte Fehlerbehandlung, Logging und Benachrichtigungen per E-Mail.

## Features

- **Verwalten von Netzlaufwerken**: Funktionen wie `Connect-Drives` und `Disconnect-Drives` zum einfachen Management von Netzlaufwerken.
- **Verfügbarkeitsprüfung**: Überprüft die Erreichbarkeit von Netzlaufwerken mit `Test-ShareAvailability`.
- **Fehlerbehandlung und Retry-Mechanismus**: Integrierte Logik für Wiederholungsversuche und Fehlerprotokollierung.
- **E-Mail-Benachrichtigungen**: Automatisches Senden von E-Mails bei Fehlern oder Erfolgen.

## Installation

Installiere das Modul mit PowerShell:

```powershell
Install-Module -Name NetzlaufwerkTools -Scope CurrentUser
```

## Verwendung

### Netzlaufwerk verbinden

```powershell
$drives = @(
    @{
        'Name' = 'Z'
        'Root' = '\server\share'
    }
)
$credential = Get-Credential
Connect-Drives -Drives $drives -Credential $credential -Method PSDrive
```

### Netzlaufwerk trennen

```powershell
Disconnect-Drives -Name 'Z'
```

### Netzlaufwerk-Verfügbarkeit prüfen

```powershell
Test-ShareAvailability '\server\share'
```

## Tests

Dieses Projekt verwendet [Pester](https://pester.dev/) für Unit-Tests. So führst du die Tests aus:

1. Installiere Pester:

   ```powershell
   Install-Module Pester -Scope CurrentUser
   ```

2. Führe die Tests aus:

   ```powershell
   Invoke-Pester -Script 'tests\Unit\*Tests.ps1'
   ```

## Beitrag leisten

1. Forke das Repository.
2. Erstelle einen neuen Branch (`git checkout -b feature-branch`).
3. Führe deine Änderungen durch.
4. Committe deine Änderungen (`git commit -am 'Add new feature'`).
5. Push deine Änderungen (`git push origin feature-branch`).
6. Erstelle einen Pull-Request.
