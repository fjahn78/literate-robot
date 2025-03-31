function Connect-Drives {
    param (
        [Parameter(Mandatory = $false)]
        [hashtable[]]
        $Drives,
        [Parameter(ValueFromPipeline = $true)]
        [hashtable]
        $InputObject,
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential,
        [Parameter(Mandatory = $true)]
        [ValidateSet('NetUse', 'PSDrive')]
        [string]
        $Method,
        [switch]
        $ForceReconnect = $false,
        [switch]
        $DryRun = $false
    )

    begin { 
        $Script:success = 0
        $Script:failed = 0
        if (!$Drives) {
            $Drives = @()
        }
    }
    process {
        if ($InputObject) {
            $Drives += $InputObject
        }
    }
    end {
        $summary = @()
        foreach ($drive in $Drives) {
            # Zunächst prüfen, ob der Share verfügbar ist
            $shareAvailable = Test-ShareAvailability -NetworkPath $drive.Root
            if (-not $shareAvailable) {
                Write-Log ('⚠️ Das Netzlaufwerk {0}: kann nicht verbunden werden, da das Share nicht erreichbar ist.' -f $name) -Level Warning
                $failed++
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


            try {
                switch ($Method) {
                    'PSDrive' { 
                        Write-Log ('Mapping {0}: -> {1} via PSDrive' -f $name, $root)
                        if ($Credential) {
                            $result = Invoke-PSDrive -Drive $drive -Credential $Credential
                        }
                        else {
                            $result = Invoke-PSDrive -Drive $drive
                        }
                    }
                    'NetUse' {
                        Write-Log ('Mapping {0}: -> {1} via net use' -f $name, $root)
                        if ($Credential) {
                            $result = Invoke-NetUse -Drive $drive -Credential $Credential
                        }
                        else {
                            $result = Invoke-NetUse -Drive $drive
                        }
                    }
                    Default { }
                }
                if ($result) {
                    $success++
                    $summary += $result
                }
            }
            catch {
                Write-Log ("❌ Fehler beim Mapping von {0}: $_" -f $name) -Level Error
                $failed++
            }
        }
        return @{ success = $success; failed = $failed }
    }
}