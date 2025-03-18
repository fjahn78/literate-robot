function Test-Credentials {
    param (
        [Parameter(Mandatory = $True)]
        [pscredential]
        $Credential
    )
    $username = $Credential.UserName
    $password = $Credential.GetNetworkCredential().Password
    # $domain = "fin-rlp.local"

    $rootDSE = [adsi]'LDAP://RootDSE'
    $ldapPath = "LDAP://$($rootDSE.dnsHostName)/$($rootDSE.defaultNamingContext)"

    try {
        $entry = New-Object System.DirectoryServices.DirectoryEntry($ldapPath, $username, $password)
        # Zugriff auf ein AD-Objekt provoziert die Bindung
        $null = $entry.NativeObject
        Write-Log "✅ AD-Bindung erfolgreich für $username"
        return $true
    }
    catch {
        Write-Log "❌ AD-Bindung fehlgeschlagen für $username - $_"
        return $false
    }
}
