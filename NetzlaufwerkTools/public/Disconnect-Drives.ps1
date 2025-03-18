function Disconnect-Drives {
    [CmdletBinding()]
    param (
        # hastable for splatting
        [Parameter(ValueFromPipeline = $true)]
        [hashtable]
        $drive,
        # Method to use
        [Parameter(Mandatory = $true)]
        [string]
        $Method
    )
    process {
        $name = $drive['Name']

        if ($DryRun) {
            Write-Log ('[DryRun] Würde {0}: trennen via {1}' -f $name, $Method)
            return
        }

        if ($Method -eq 'PSDrive') {
            $mapped = Get-PSDrive -Name $name -ErrorAction SilentlyContinue
            if ($mapped) {
                Write-Log('Trenne PSDrive {0}:' -f $name)
                Remove-PSDrive -Name $name -Force -Confirm:$False
            }
            else {
                Write-Log ('PSDrive {0}: nicht gefunden.' -f $name)
            }
        }
        elseif ($Method -eq 'NetUse') {
            $output = cmd /c "net use ${name}:"
            if ($output -match '\\' -or $output -match 'OK') {
                Write-Log ('Trenne net use Mapping {0}:' -f $name)
                cmd /c "net use ${name}: /delete /y"
            }
            else {
                Write-Log ('Kein aktives net use Mapping für {0}: gefunden' -f $name)
            }
        }
    }
}
