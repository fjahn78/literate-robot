function Test-IsElevated {
    $currentIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    if (!$currentIdentity) {
        return $false
    }
    $principal = [System.Security.Principal.WindowsPrincipal]::new($currentIdentity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}