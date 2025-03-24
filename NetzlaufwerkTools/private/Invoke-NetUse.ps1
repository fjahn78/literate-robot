function Invoke-NetUse {
    param (
        # Drive Name
        [Parameter(Mandatory = $true)]
        [string]
        $Name,
        # Network path
        [Parameter(Mandatory = $true)]
        [string]
        $Root,
        # optional credentials
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )
    if ($Credential) {
        $username = $Credential.UserName
        $password = $Credential.GetNetworkCredential().Password
    }

    $cmd = "net use ${name}: `"$root`" /persistent:yes"
    if ($Credential) {
        $cmd += " /user:`"$username`" `"$password`""
    }
    else {
    }
    $result = cmd /c $cmd
    return $result
}