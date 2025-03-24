function Invoke-PSDrive {
    [CmdletBinding()]
    param (
        # Drive Letter / name
        [Parameter(Mandatory = $true)]
        [string]
        $Name,
        # Path to be mapped
        [Parameter(Mandatory = $true)]
        [string]
        $Root,
        # optional credentials
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )
    
    $drive = @(
        Name = $Name
        Root = $Root
    )
    if ($Credential) {
        $drive.Add('Credential', $Credential)
    }
    $result = New-PSDrive @drive -PSProvider FileSystem -Persist
    return $result
}