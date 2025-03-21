function Test-Credentials {
    param (
        [Parameter(Mandatory = $True)]
        [pscredential]
        $Credential,
        $Domain = 'fin-rlp.local'
    )
    $username = $Credential.UserName
    $password = $Credential.GetNetworkCredential().Password

    if ($Domain -and ($username -notmatch '\\|@')) {
        $username = ('{0}@{1}' -f $username, $Domain)
    }

    $rootDSE = [adsi]'LDAP://RootDSE'
    $ldapPath = "LDAP://$($rootDSE.dnsHostName)/$($rootDSE.defaultNamingContext)"

    try {
        $entry = New-Object System.DirectoryServices.DirectoryEntry($ldapPath, $username, $password)
        $searcher = New-Object System.DirectoryServices.DirectorySearcher($entry)
        $searcher.Filter = "(objectClass=user)"
        $searcher.SizeLimit = 1
        $searcher.PageSize = 1

        # erste harte Suche
        $result = $searcher.FindOne()

        if ($null -ne $result) {
            Write-Log "✅ AD-Authentifizierung erfolgreich für $username"
            return $true
        }
        else {
            Write-Log ('❌ AD-Authentifizierung fehlgeschlagen für {0} - Kein Ergebnis gefunden' -f $username) -Level Error
        }
    }
    catch {
        Write-Log ('❌ Fehler bei der AD-Authentifizierung für {0} - {1}' -f $username, $_) -Level Error
        return $false
    }
    finally {
        if ($entry) { $entry.Dispose() }
        if ($searcher) { $searcher.Dispose()}
    }
}
