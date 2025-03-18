function Connect-Drives {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $Drives,
        [Parameter(Mandatory = $true)]
        [pscredential]
        $Credential,
        [Parameter(Mandatory = $true)]
        [string]
        $Method
    )
    $global:success = 0
    $global:failed = 0

    foreach ($drive in $Drives) {
        $username = $Credential.UserName
        $password = $Credential.GetNetworkCredential().Password
        $root = $drive["Root"]
        $name = $drive["Name"]

        # Zunächst prüfen, ob der Share verfügbar ist
        $shareAvailable = Test-ShareAvailability -NetworkPath $root
        if (-not $shareAvailable) {
            Write-Log "⚠️ Das Netzlaufwerk {0}: kann nicht verbunden werden, da das Share nicht erreichbar ist." -f $name
            continue
        }

        if ($ForceReconnect -or $DryRun) {
            Write-Log ("ForceReconnect oder DryRun aktiv - versuche {0}: zu trennen" -f $name)
            if (-not $DryRun) { $drive | disconnect -Method $Method }
        }

        if ($DryRun) {
            Write-Log ("[DryRun] Würde {0}: -> {1} mappen via {2}" -f $name, $root, $Method)
            continue
        }


        try {
            if ($Method -eq "PSDrive") {
                Write-Log ("Mapping {0}: -> {1} via PSDrive" -f $name, $root)
                New-PSDrive -Name $name -PSProvider FileSystem -Root $root -Persist -Credential $Credential
            }
            elseif ($Method -eq "NetUse") {
                Write-Log ("Mapping {0}: -> {1} via net use" -f $name,$root)
                cmd /c "net use ${name}: `"$root`" /user:`"$username`" `"$password`" /persistent:yes"
            }
            $global:success++
        }
        catch {
            Write-Log ("❌ Fehler beim Mapping von {0}: $_" -f $name)
            $global:failed++
        }
    }
}