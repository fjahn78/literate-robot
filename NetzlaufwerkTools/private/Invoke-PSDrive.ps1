function Invoke-PSDrive {
    [CmdletBinding()]
    param (
        # Drive Letter / name
        [Parameter(Mandatory = $true)]
        [hashtable]
        $Drive,
        # optional credentials
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential,
        [switch]
        $Disconnect
    )
    
    
    if (!$Disconnect) {
        if ($Credential) {
            $Drive.Add('Credential', $Credential)
        }
        $result = New-PSDrive @Drive -PSProvider FileSystem -Persist
    }
    else {
        $mapped = Get-PSDrive -Name $name -ErrorAction SilentlyContinue
        if ($mapped) {
            $result = Remove-PSDrive -Name $Drive['Name'] -Force -Confirm:$False
        }
        else {
            $result = Write-Log ('PSDrive {0}: nicht gefunden.' -f $name)
        }
    }
    return $result
}