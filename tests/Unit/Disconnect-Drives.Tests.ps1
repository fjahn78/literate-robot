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
    }
}