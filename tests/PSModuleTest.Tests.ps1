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
        Context 'Get-TimeSpan - Default Behavior' {
            It 'Get-TimeSpan - Returns Zero when both Start and End use defaults' {
                $result = Get-TimeSpan
                $result | Should -Be ([TimeSpan]::Zero)
            }
        }

        Context 'Get-TimeSpan - Future End DateTime' {
            It 'Get-TimeSpan - Returns positive TimeSpan for future end datetime' {
                $future = [DateTime]::Now.AddMinutes(30)
                $result = Get-TimeSpan -End $future
                $result.TotalMinutes | Should -BeGreaterThan 29
                $result.TotalMinutes | Should -BeLessThan 31
            }
        }

        Context 'Get-TimeSpan - Past End DateTime' {
            It 'Get-TimeSpan - Returns negative TimeSpan for past end datetime by default' {
                $past = [DateTime]::Now.AddMinutes(-30)
                $result = Get-TimeSpan -End $past
                $result.TotalMinutes | Should -BeLessThan -29
                $result.TotalMinutes | Should -BeGreaterThan -31
            }

            It 'Get-TimeSpan - Returns Zero for past end datetime with StopAtZero' {
                $past = [DateTime]::Now.AddMinutes(-30)
                $result = Get-TimeSpan -End $past -StopAtZero
                $result | Should -Be ([TimeSpan]::Zero)
            }
        }

        Context 'Get-TimeSpan - Start and End Parameters' {
            It 'Get-TimeSpan - Calculates difference between Start and End' {
                $start = [DateTime]::Now.AddHours(-2)
                $end = [DateTime]::Now
                $result = Get-TimeSpan -Start $start -End $end
                $result.TotalHours | Should -BeGreaterThan 1.9
                $result.TotalHours | Should -BeLessThan 2.1
            }

            It 'Get-TimeSpan - Returns negative when End is before Start' {
                $start = [DateTime]::Now
                $end = [DateTime]::Now.AddHours(-1)
                $result = Get-TimeSpan -Start $start -End $end
                $result.TotalHours | Should -BeLessThan -0.9
                $result.TotalHours | Should -BeGreaterThan -1.1
            }

            It 'Get-TimeSpan - Returns Zero for negative difference with StopAtZero' {
                $start = [DateTime]::Now
                $end = [DateTime]::Now.AddHours(-1)
                $result = Get-TimeSpan -Start $start -End $end -StopAtZero
                $result | Should -Be ([TimeSpan]::Zero)
            }
        }

        Context 'Get-TimeSpan - Pipeline Support' {
            It 'Get-TimeSpan - Accepts DateTime from pipeline as End parameter' {
                $future = [DateTime]::Now.AddMinutes(15)
                $result = $future | Get-TimeSpan
                $result.TotalMinutes | Should -BeGreaterThan 14
                $result.TotalMinutes | Should -BeLessThan 16
            }
        }

        Context 'Get-TimeSpan - Exact Same Time' {
            It 'Get-TimeSpan - Returns near Zero for same Start and End times' {
                $time = [DateTime]::Now
                $result = Get-TimeSpan -Start $time -End $time
                # Should be exactly zero for same time
                $result.TotalMilliseconds | Should -Be 0
            }
        }
    }
}
