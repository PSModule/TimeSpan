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
                $result | Should -Be '-5min'
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

    Describe 'Get-TimeSpan' {
        Context 'Get-TimeSpan - Future DateTime' {
            It 'Get-TimeSpan - Returns positive TimeSpan for future datetime' {
                $future = [DateTime]::Now.AddMinutes(30)
                $result = Get-TimeSpan -Target $future
                $result.TotalMinutes | Should -BeGreaterThan 29
                $result.TotalMinutes | Should -BeLessThan 31
            }
        }

        Context 'Get-TimeSpan - Past DateTime without AllowNegative' {
            It 'Get-TimeSpan - Returns Zero for past datetime' {
                $past = [DateTime]::Now.AddMinutes(-30)
                $result = Get-TimeSpan -Target $past
                $result | Should -Be ([TimeSpan]::Zero)
            }
        }

        Context 'Get-TimeSpan - Past DateTime with AllowNegative' {
            It 'Get-TimeSpan - Returns negative TimeSpan for past datetime when AllowNegative is specified' {
                $past = [DateTime]::Now.AddMinutes(-30)
                $result = Get-TimeSpan -Target $past -AllowNegative
                $result.TotalMinutes | Should -BeLessThan -29
                $result.TotalMinutes | Should -BeGreaterThan -31
            }
        }

        Context 'Get-TimeSpan - AsAge parameter' {
            It 'Get-TimeSpan - Returns positive elapsed time for past datetime with AsAge' {
                $past = [DateTime]::Now.AddHours(-2)
                $result = Get-TimeSpan -Target $past -AsAge
                $result.TotalHours | Should -BeGreaterThan 1.9
                $result.TotalHours | Should -BeLessThan 2.1
            }

            It 'Get-TimeSpan - Returns negative elapsed time for future datetime with AsAge and AllowNegative' {
                $future = [DateTime]::Now.AddHours(2)
                $result = Get-TimeSpan -Target $future -AsAge -AllowNegative
                $result.TotalHours | Should -BeLessThan -1.9
                $result.TotalHours | Should -BeGreaterThan -2.1
            }
        }

        Context 'Get-TimeSpan - Pipeline Support' {
            It 'Get-TimeSpan - Accepts DateTime from pipeline' {
                $future = [DateTime]::Now.AddMinutes(15)
                $result = $future | Get-TimeSpan
                $result.TotalMinutes | Should -BeGreaterThan 14
                $result.TotalMinutes | Should -BeLessThan 16
            }
        }

        Context 'Get-TimeSpan - Exact Zero Case' {
            It 'Get-TimeSpan - Returns Zero for exactly current time' {
                $now = [DateTime]::Now
                $result = Get-TimeSpan -Target $now
                # Allow for small timing differences (should be very close to zero)
                [Math]::Abs($result.TotalMilliseconds) | Should -BeLessThan 100
            }
        }
    }
}
