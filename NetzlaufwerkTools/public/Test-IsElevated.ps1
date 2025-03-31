function Test-IsElevated {
    $identity = Get-CurrentIdentity
    if (!$identity) { return $false }
    $principal = Get-CurrentPrincipal -Identity $identity
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
