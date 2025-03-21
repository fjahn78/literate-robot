function Get-ValidCredential {
    param(
        [parameter(Mandatory = $true)]
        [string]$CrPath
    )
    $retryCount = 0
    
    do {
        if (!(Test-Path $CrPath)) {
            $credentials = Get-Credential
        }
        else {
            $credentials = Import-Clixml $CrPath
            Write-Log 'Credentials aus Datei geladen'
        }
    
        if (Test-Credentials -Credential $credentials) {
            if (!(Test-Path -Path $CrPath)) {
                # $credentials = Get-Credential
                $credentials | Export-Clixml $CrPath
                Write-Log 'Neue Credentials wurden gespeichert'
            }
            return $credentials
        }
        else {
            Remove-Item -Path $CrPath -ErrorAction SilentlyContinue
            $retryCount++
            if ($retryCount -lt $MaxRetries) {
                Write-Log ('Neuer Versuch ({0} von {1})...' -f $retryCount, $MaxRetries)
            }
            else {
                throw 'Maximale Anzahl an Fehlversuchen erreicht'
            }
        }
    } while ($retryCount -lt $MaxRetries)
}