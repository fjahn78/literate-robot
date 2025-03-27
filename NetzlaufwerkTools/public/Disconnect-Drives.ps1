function Disconnect-Drives {
    [CmdletBinding()]
    param (
        # hastable for splatting
        [Parameter(ValueFromPipeline = $true)]
        [hashtable]
        $Drive,
        # Method to use
        [Parameter(Mandatory = $true)]
        [string]
        $Method,
        [switch]
        $DryRun
    )
    process {
        $name = $Drive['Name']

        if ($DryRun) {
            Write-Log ('[DryRun] Würde {0}: trennen via {1}' -f $name, $Method)
            return
        }
        switch ($Method) {
            'PSDrive' {
                Write-Log('Trenne PSDrive {0}:' -f $name)
                $result = Invoke-PSDrive -Drive $Drive -Disconnect
            }
            'NetUse' {
                Write-Log ('Trenne net use Mapping {0}:' -f $name)
                $result = Invoke-NetUse -Drive $Drive -Disconnect
            }
        }
        return $result
    }
}
