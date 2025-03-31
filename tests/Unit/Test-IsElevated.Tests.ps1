$modulePath = Join-Path $PSScriptRoot '..\..\NetzlaufwerkTools'
Import-Module $modulePath -Force -Verbose

InModuleScope -ModuleName NetzlaufwerkTools {
    Describe 'Test-IsElevated' {
        BeforeAll {
            Mock Get-CurrentIdentity -MockWith { @{ Name = 'MockUser'; IsAuthenticated = $true } }
            Mock Get-CurrentPrincipal -MockWith {
                param ($Identity)
                $principal = New-Object PSObject -Property @{ Identity = $Identity }
                $principal | Add-Member -MemberType ScriptMethod -Name IsInRole -Value { param ($role) return $false }
                return $principal
            }
        }

        It 'Should return $false if user is NOT an Administrator' {
            Test-IsElevated | Should -Be $false
        }
    }
}