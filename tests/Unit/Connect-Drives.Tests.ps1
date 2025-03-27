$modulePath = Join-Path $PSScriptRoot '..\..\NetzlaufwerkTools'
Import-Module $modulePath -Force -Verbose

InModuleScope -ModuleName NetzlaufwerkTools {
    Describe 'Connect-Drives' {
        Context 'Network Share Available' {
            BeforeAll {
                # Mocks for external functions
                Mock Test-ShareAvailability { return $true }
                Mock Write-Log { }
                Mock Disconnect-Drives { }
                Mock Invoke-PSDrive { return 'mocked' }
                Mock Invoke-NetUse { return 'mocked' }
                # Mock cmd { }
            }
            
            # sample credentials
            $Credential = New-Object PSCredential('user', (ConvertTo-SecureString 'password' -AsPlainText -Force))
            
            BeforeEach {
                # sample test drive
                $drives = @(
                    @{
                        'Name' = 'Z'
                        'Root' = '\\server\share'
                    }
                )
            }
        
            It 'Should output a log message, when called with -DryRun using <method>' -ForEach @(
                @{ Method = 'PSDrive' }
                @{ Method = 'NetUse' }
            ) {
                $result = Connect-Drives -Drives $drives -Method $Method -DryRun
                Assert-MockCalled -Scope It -CommandName "Invoke-$Method" -Exactly -Times 0
                Assert-MockCalled -CommandName Write-Log -ModuleName NetzlaufwerkTools -Exactly 2
                $result.success | Should -Be 0
                $result.failed | Should -Be 0
            }
        
            It 'Should connect a drive successfully via <method> with credentials' -ForEach @(
                @{ Method = 'PSDrive' }
                @{ Method = 'NetUse' }
            ) {
                $result = Connect-Drives -Drives $drives -Credential $Credential -Method $Method
                $result.success | Should -Be 1
                $result.failed | Should -Be 0
            }
            It 'Should connect a drive successfully via <method> without credentials (same user)' -ForEach @(
                @{ Method = 'PSDrive' }
                @{ Method = 'NetUse' }
            ) {
                $result = Connect-Drives -Drives $drives -Method $Method
                $result.success | Should -Be 1
                $result.failed | Should -Be 0
            }
        
            It 'Should disconnect drives when using -ForceDisconnect via <method>' -ForEach @(
                @{ Method = 'PSDrive' }
                @{ Method = 'NetUse' }
            ) {
                Connect-Drives -Drives $drives -Method $Method -ForceReconnect
                Assert-MockCalled -CommandName Disconnect-Drives -ModuleName NetzlaufwerkTools -Exactly 1
            }
        }
        Context 'Network Share Unavailable' {
            BeforeAll {
                # Mocks for external functions
                Mock Test-ShareAvailability { return $false }
                Mock Write-Log { }
                Mock Disconnect-Drives { }
                Mock Invoke-PSDrive { return 'mocked' }
                Mock Invoke-NetUse { return 'mocked' }
                
                # sample credentials
                $Credential = New-Object PSCredential('user', (ConvertTo-SecureString 'password' -AsPlainText -Force))
            }

            BeforeEach {
                # sample test drive
                $drives = @(
                    @{
                        'Name' = 'Z'
                        'Root' = '\\server\share'
                    }
                )

            }
        
            It 'Should fail to connect a drive successfully via <method> with credentials' -ForEach @(
                @{ Method = 'PSDrive' }
                @{ Method = 'NetUse' }
            ) {
                $result = Connect-Drives -Drives $drives -Method $Method
                Assert-MockCalled -Scope It -CommandName "Invoke-$Method" -Exactly 0
                $result.success | Should -Be 0
                $result.failed | Should -Be 1
            }
            It 'Should fail to connect a drive successfully via <method> without credentials (same user)' -ForEach @(
                @{ Method = 'PSDrive' }
                @{ Method = 'NetUse' }
            ) {
                $result = Connect-Drives -Drives $drives -Method $Method
                Assert-MockCalled -Scope It -CommandName "Invoke-$Method" -Exactly 0
                $result.success | Should -Be 0
                $result.failed | Should -Be 1
            }
        }
        Context 'Connection Wrapper throw exeception' {
            BeforeAll {
                Mock Test-ShareAvailability { return $true }
                Mock Write-Log { }
                Mock Disconnect-Drives { }
                Mock Invoke-PSDrive { throw }
                Mock Invoke-NetUse { throw }
            }
        
            BeforeEach {
                # sample test drive
                $drives = @(
                    @{
                        'Name' = 'Z'
                        'Root' = '\\server\share'
                    }
                )
            }
        
            It 'Should throw an exception using <method>' -ForEach @(
                @{ Method = 'PSDrive' }
                @{ Method = 'NetUse' }
            ) {
                $result = Connect-Drives -Drives $drives -Method $Method
                Assert-MockCalled -Scope It -CommandName "Invoke-$Method" -Exactly -Times 1
                Assert-MockCalled -CommandName Write-Log -Scope It -ParameterFilter { $Level -eq 'Error' } -ModuleName NetzlaufwerkTools -Exactly 1
                $result.success | Should -Be 0
                $result.failed | Should -Be 1
            }
        }
    }
}