$script:logFile = "netzlaufwerke_log.txt"
$script:maxLogSize = 1MB

Get-ChildItem "$PSScriptRoot\public\*.ps1" | ForEach-Object { . $_.FullName }

Export-ModuleMember -Function *