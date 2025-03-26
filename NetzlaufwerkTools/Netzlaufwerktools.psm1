$script:logFile = ".\netzlaufwerke.log"
$script:maxLogSize = 1MB

Get-ChildItem "$PSScriptRoot\public\*.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem "$PSScriptRoot\private\*.ps1" | ForEach-Object { . $_.FullName }

Export-ModuleMember -Function Connect-Drives, Disconnect-Drives, Test-IsElevated, Get-ValidCredential, Write-Log, Move-Log