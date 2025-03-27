Param(
    [switch]$Disconnect = $False,
    [switch]$ForceReconnect = $false,
    [switch]$DryRun = $false,
    [switch]$Silent = $false,
    [int]$MaxRetries = 3,
    [ValidateSet('NetUse', 'PSDrive')]
    [string]$Method = 'NetUse'
    )
    
    Import-Module .\NetzlaufwerkTools -Force
    
    
# Elevated shell check

If (Test-IsElevated) {
    Write-Log '⚠️ Script läuft mit Admin-Rechten. Netzlaufwerke könnten im Benutzerkontext fehlen' -Level Warning
}

$credentials = Get-ValidCredential -CrPath "$PSScriptRoot\cred.xml"

# Definition Netzlaufwerke
$netDrives = @(
    @{
        Name = 'H'
        Root = "\\lsfs01.fin-rlp.local\zd_h_dfs$\$(($credentials.UserName -split '\\')[-1])" 
    }
    @{
        Name = 'G'
        Root = '\\lsfs01.fin-rlp.local\zd_g_dfs$'
    }
    @{
        Name = 'L'
        Root = '\\lsfs03.fin-rlp.local\projekterlp_dfs$'
    }
    @{
        Name = 'P'
        Root = '\\lsfs01.fin-rlp.local\zd_p_dfs$'
    }
    @{
        Name = 'S'
        Root = '\\lsprog02.fin-rlp.local\daten_dfs$\softw'
    }
    @{
        Name = 'W'
        Root = '\\lsprog02.fin-rlp.local\daten_dfs$\doku'
    }
)

# Logfile prüfen
Move-Log
Write-Log '--- STARTE SKRIPT ---'

# Ausführung
if ($Disconnect) {
    Write-Log '--- STARTE DISCONNECT ---'
    $netDrives | Disconnect-Drives -Method $Method
    Write-Log '--- DISCONNECT FERTIG ---'
}
else {
    Write-Log ('--- STARTE CONNECT ({0}) ---' -f $Method)
    $result = Connect-Drives -Drives $netDrives -Credential $credentials -Method $Method -ForceReconnect:$ForceReconnect -DryRun:$DryRun
    Write-Log '--- CONNECT FERTIG ---'
    Write-Log ("✔️ Erfolgreich verbunden: {0} | ❌ Fehler: {1}" -f $result.success,$result.failed)
}