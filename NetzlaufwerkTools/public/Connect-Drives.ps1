function Connect-Drives {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $Drives,
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential,
        [Parameter(Mandatory = $true)]
        [ValidateSet('NetUse', 'PSDrive')]
        [string]
        $Method
    )

    begin { 
        $global:success = 0
        $global:failed = 0
    }
    end {
        foreach ($drive in $Drives) {
            # Zunächst prüfen, ob der Share verfügbar ist
            $shareAvailable = Test-ShareAvailability -NetworkPath $root
            if (-not $shareAvailable) {
                Write-Log ('⚠️ Das Netzlaufwerk {0}: kann nicht verbunden werden, da das Share nicht erreichbar ist.' -f $name) -Level Warning
                $global:failed++
                continue
            }

            if ($ForceReconnect -or $DryRun) {
                Write-Log ('ForceReconnect oder DryRun aktiv - versuche {0}: zu trennen' -f $name)
                if (-not $DryRun) { $drive | Disconnect-Drives -Method $Method }
            }

            if ($DryRun) {
                Write-Log ('[DryRun] Würde {0}: -> {1} mappen via {2}' -f $name, $root, $Method)
                continue
            }

            if ($Credential) {
                $drive.Add('Credential', $Credential)
            }

            try {
                switch ($Method) {
                    'PSDrive' { 
                        Write-Log ('Mapping {0}: -> {1} via PSDrive' -f $name, $root)
                        $result = Invoke-PSDrive @drive 
                        
                    }
                    'NetUse' {
                        Write-Log ('Mapping {0}: -> {1} via net use' -f $name, $root)
                        $result = Invoke-NetUse @drive
                        
                    }
                    Default { Write-Log "❌ Falsche Eingabe: Bitte wählen Sie zwischen 'PSDrive' und 'NetUse'" -Level Error }
                }
                if ($result) {
                    $global:success++
                    return $result
                }
            }
            catch {
                Write-Log ("❌ Fehler beim Mapping von {0}: $_" -f $name) -Level Error
                $global:failed++
            }
        }
    }
}