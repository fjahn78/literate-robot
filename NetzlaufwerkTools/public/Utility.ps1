function Move-Log {
    if ((Test-Path $script:logFile) -and ((Get-Item $script:logFile).Length -gt $script:maxLogSize)) {
        $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        Rename-Item $script:logFile "$(Split-Path -Parent $script:logFile)\netzlaufwerke_log_$timestamp.txt"
        Write-Log "Logfile rotiert: netzlaufwerke_log_$timestamp.txt"
    }    
}

function Write-Log {
    param (
        [string]$msg,
        [ValidateSet('Info', 'Warning', 'Error', 'Debug')]
        [string]$Level = 'Info'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    switch ($Level) {
        'Warning' { $msg = 'WARNING -' + $msg }
        'Error' { $msg = 'ERROR -' + $msg }
        'Debug' { $msg = 'DEBUG -' + $msg }
        Default {}
    }
    $logMsg = "$timestamp - $msg"
    if (!$Silent) { Write-Host $logMsg }
    Add-Content -Path $script:logFile -Value $logMsg
}