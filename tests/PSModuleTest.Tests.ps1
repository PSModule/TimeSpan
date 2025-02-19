Describe 'TimeSpan' {
    Describe 'Format-TimeSpan' {
        Context 'Format-TimeSpan - Basic Usage' {
            It 'Format-TimeSpan - Formats 90 minutes as 2h' {
                $result = New-TimeSpan -Minutes 90 | Format-TimeSpan
                $result | Should -Be '2h'
            }
        }

        Context 'Format-TimeSpan - Precision and FullNames' {
            It 'Format-TimeSpan - Formats 3661 seconds with precision 2 and full names' {
                $result = [TimeSpan]::FromSeconds(3661) | Format-TimeSpan -Precision 2 -FullNames
                $result | Should -Be '1 hour 1 minute'
            }
        }

        Context 'Format-TimeSpan - Smallest Unit Handling' {
            It 'Format-TimeSpan - Formats 500 milliseconds with precision 2 and full names' {
                $result = [TimeSpan]::FromMilliseconds(500) | Format-TimeSpan -Precision 2 -FullNames
                $result | Should -Be '500 milliseconds 0 microseconds'
            }
        }

        Context 'Format-TimeSpan - Negative TimeSpan' {
            It 'Format-TimeSpan - Formats negative 5 minutes correctly' {
                $result = New-TimeSpan -Minutes -5 | Format-TimeSpan
                $result | Should -Be '-5m'
            }
        }

        Context 'Format-TimeSpan - BaseUnit' {
            It 'Format-TimeSpan - Forces formatting in seconds' {
                $result = [TimeSpan]::FromMinutes(2) | Format-TimeSpan -BaseUnit 'Seconds'
                $result | Should -Be '120s'
            }
            # Test micro seconds
            It 'Format-TimeSpan - Forces formatting in microseconds' {
                $result = [TimeSpan]::FromMilliseconds(1) | Format-TimeSpan -BaseUnit 'Microseconds' -FullNames
                $result | Should -Be '1000 microseconds'
            }
            # Test microsecond abbreviation
            It 'Format-TimeSpan - Forces formatting in microseconds with abbreviation' {
                $result = [TimeSpan]::FromMilliseconds(1) | Format-TimeSpan -BaseUnit 'Microseconds'
                $result | Should -Be '1000µs'
            }
        }
    }
}
