function Test-ShareAvailability {
    param (
        [string]$NetworkPath
    )
    if (Test-Path -Path $NetworkPath) {
        Write-Log "✅ Share $NetworkPath ist erreichbar."
        return $true
    }
    else {
        Write-Log "❌ Share $NetworkPath ist nicht erreichbar."
        return $false
    }
    
}