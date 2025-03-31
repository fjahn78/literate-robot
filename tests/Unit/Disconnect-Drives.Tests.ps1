$modulePath = Join-Path $PSScriptRoot '..\..\NetzlaufwerkTools'
Import-Module $modulePath -Force -Verbose

InModuleScope -ModuleName NetzlaufwerkTools {
    Describe 'Disconnect-Drives' {
        BeforeAll {
            # Mocks for external functions
            Mock Write-Log { }
            Mock Invoke-NetUse -ParameterFilter { $Disconnect -eq $true } { return 'mocked' }
            Mock Invoke-PSDrive -ModuleName NetzlaufwerkTools -ParameterFilter { $Disconnect -eq $true } { return 'mocked' }
        }    
        
        BeforeEach {
            # sample test drive
            $drives = @(
                @{
                    'Name' = 'Z'
                    'Root' = '\\server\share'
                }
                @{
                    'Name' = 'Y'
                    'Root' = '\\server\share2'
                }
            )
        }
        It 'Should call the respektive Wrapper for <method>' -ForEach @(
            @{ Method = 'PSDrive' }
            @{ Method = 'NetUse' }
        ) {
            $result = Disconnect-Drives -Drive $drives[0] -Method $Method
            Assert-MockCalled "Invoke-$Method" -ModuleName NetzlaufwerkTools -ParameterFilter { $Disconnect -eq $true } -Exactly 1
            $result | Should -Be 'mocked'
        }
        It 'Should not call the respektive Wrapper for <method> when using DryRun' -ForEach @(
            @{ Method = 'PSDrive' }
            @{ Method = 'NetUse' }
        ) {
            $result = Disconnect-Drives -Drive $drives[0] -Method $Method -DryRun
            Assert-MockCalled "Invoke-$Method" -ModuleName NetzlaufwerkTools -ParameterFilter { $Disconnect -eq $true } -Exactly 0
            $result | Should -Be $null
        }

        It 'Should disconnect drives with <method> when passing drives through a pipeline' -ForEach @(
            @{ Method = 'PSDrive' }
            @{ Method = 'NetUse' }
        ) {
            $result = $drives | Disconnect-Drives -Method $Method
            Assert-MockCalled "Invoke-$Method" -ModuleName NetzlaufwerkTools -ParameterFilter { $Disconnect -eq $true } -Exactly $drives.Count
            foreach ($r in $result) {
                $r | Should -Be 'mocked'
            }
        }
    }
}