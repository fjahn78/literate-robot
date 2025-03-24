$modulePath = Join-Path $PSScriptRoot '..\..\NetzlaufwerkTools'
Import-Module $modulePath -Force -Verbose

Describe 'Connect-Drives' {
    Context 'Network Share Available' {
        BeforeAll {
            # Mocks for external functions
            InModuleScope -ModuleName NetzlaufwerkTools {
                Mock Test-ShareAvailability { return $true }
                Mock Write-Log { }
                Mock Disconnect-Drives { }
                Mock Invoke-PSDrive { return 'mocked' }
                Mock Invoke-NetUse { return 'mocked' }
                # Mock cmd { }
            }
            
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

            # mocking global variables
            $Global:success = 0
            $Global:failed = 0
        }
    
        It 'Should connect a drive successfully via New-PSDrive with credentials' {
            $result = Connect-Drives -Drives $drives -Credential $Credential -Method PSDrive
            $result | Should -Be "mocked"
            $Global:success | Should -Be 1
            $Global:failed | Should -Be 0
        }
        It 'Should connect a drive successfully via net use with credentials' {
            $result = Connect-Drives -Drives $drives -Credential $Credential -Method NetUse
            $result | Should -Be "mocked"
            $Global:success | Should -Be 1
            $Global:failed | Should -Be 0
        }
        It 'Should connect a drive successfully via New-PSDrive without credentials (same user)' {
            $result = Connect-Drives -Drives $drives -Method PSDrive
            $result | Should -Be 'mocked'
            $Global:success | Should -Be 1
            $Global:failed | Should -Be 0
        }
        It 'Should connect a drive successfully via net use with credentials (same user)' {
            $result = Connect-Drives -Drives $drives -Method NetUse
            $result | Should -Be 'mocked'
            $Global:success | Should -Be 1
            $Global:failed | Should -Be 0
        }
    }
    Context 'Network Share Unavailable' {
        BeforeAll {
            # Mocks for external functions
            InModuleScope -ModuleName NetzlaufwerkTools {
                Mock Test-ShareAvailability { return $false }
                Mock Write-Log { }
                Mock Disconnect-Drives { }
                Mock Invoke-PSDrive { return 'mocked' }
                Mock Invoke-NetUse { return 'mocked' }
                # Mock cmd { }
            }
            
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

            # mocking global variables
            $Global:success = 0
            $Global:failed = 0
        }
    
        It 'Should fail to connect a drive successfully via New-PSDrive with credentials' {
            $result = Connect-Drives -Drives $drives -Credential $Credential -Method PSDrive
            $result | Should -Be $null
            $Global:success | Should -Be 0
            $Global:failed | Should -Be 1
        }
        It 'Should fail to connect a drive successfully via net use with credentials' {
            $result = Connect-Drives -Drives $drives -Credential $Credential -Method NetUse
            $result | Should -Be $null
            $Global:success | Should -Be 0
            $Global:failed | Should -Be 1
        }
        It 'Should fail to connect a drive successfully via New-PSDrive without credentials (same user)' {
            $result = Connect-Drives -Drives $drives -Method PSDrive
            $result | Should -Be $null
            $Global:success | Should -Be 0
            $Global:failed | Should -Be 1
        }
        It 'Should fail to connect a drive successfully via net use with credentials (same user)' {
            $result = Connect-Drives -Drives $drives -Method NetUse
            $result | Should -Be $null
            $Global:success | Should -Be 0
            $Global:failed | Should -Be 1
        }
    } 
}