# Modul laden
Import-Module "$PSScriptRoot\..\NetzlaufwerkTools\Netzlaufwerktools.psm1" -Force

# Lade alle Unit-Tests
$config = New-PesterConfiguration
$config.Run.Path = ".\tests\Unit"
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.OutputFormat = 'CoverageGutters'
$config.CodeCoverage.Path = '.\NetzlaufwerkTools\'
$config.TestResult.Enabled = $true
Invoke-Pester -Configuration $config