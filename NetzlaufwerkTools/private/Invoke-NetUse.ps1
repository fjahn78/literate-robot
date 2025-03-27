function Invoke-NetUse {
    param (
        # Drive Name
        [Parameter(Mandatory = $true)]
        [hashtable]
        $Drive,
        [switch]
        $Disconnect,
        # optional credentials
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )
    $name = $Drive.Name
    $root = $Drive.Root
    if (!$Disconnect) {
        $cmd = "net use ${name}: `"$root`" /persistent:yes"
        if ($Credential) {
            $username = $Credential.UserName
            $password = $Credential.GetNetworkCredential().Password
            $cmd += " /user:`"$username`" `"$password`""
        }
    }
    else {
        $output = cmd /c "net use ${name}:"
        if ($output -match '\\' -or $output -match 'OK') {
            $cmd = "net use ${name}: /delete /y"
        }
        else {
            $result = Write-Log ('Kein aktives net use Mapping für {0}: gefunden' -f $name)
        }
    }
    $result = cmd /c $cmd
    return $result[0]
}