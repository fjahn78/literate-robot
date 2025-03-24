# Modul laden
Import-Module "$PSScriptRoot\..\NetzlaufwerkTools\Netzlaufwerktools.psm1" -Force

# Lade alle Unit-Tests
Invoke-Pester -Path "$PSScriptRoot\Unit" -Output Detailed -PassThru