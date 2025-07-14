
BeforeAll {
    . "$PSScriptRoot/../src/variables/private/UnitMap.ps1"
    . "$PSScriptRoot/../src/functions/private/Format-UnitValue.ps1"
    . "$PSScriptRoot/../src/functions/public/Format-TimeSpan.ps1"
}

Describe 'TimeSpan' {
    Describe 'Format-TimeSpan' {
        Context 'Format-TimeSpan - Basic Usage' {
            It 'Format-TimeSpan - Formats 90 minutes showing all non-zero units (default symbols)' {
                $result = New-TimeSpan -Minutes 90 | Format-TimeSpan
                $result | Should -Be '1h 30m'
            }
        }

        Context 'Format-TimeSpan - Precision and FullNames' {
            It 'Format-TimeSpan - Formats 3661 seconds with precision 2 and full names' {
                $result = [TimeSpan]::FromSeconds(3661) | Format-TimeSpan -Precision 2 -Format FullName
                $result | Should -Be '1 hour 1 minute'
            }
        }

        Context 'Format-TimeSpan - Smallest Unit Handling' {
            It 'Format-TimeSpan - Formats 500 milliseconds with precision 2 and full names' {
                $result = [TimeSpan]::FromMilliseconds(500) | Format-TimeSpan -Precision 2 -Format FullName
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
                $result = [TimeSpan]::FromMilliseconds(1) | Format-TimeSpan -BaseUnit 'Microseconds' -Format FullName
                $result | Should -Be '1000 microseconds'
            }
            # Test microsecond symbol
            It 'Format-TimeSpan - Forces formatting in microseconds with symbol' {
                $result = [TimeSpan]::FromMilliseconds(1) | Format-TimeSpan -BaseUnit 'Microseconds' -Format Symbol
                $result | Should -Be "1000$([char]0x00B5)s"
            }
        }

        Context 'Format-TimeSpan - IncludeZeroValues Parameter' {
            It 'Format-TimeSpan - Shows all non-zero units by default' {
                $result = New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName
                $result | Should -Be '2 hours 30 minutes 10 seconds'
            }
            
            It 'Format-TimeSpan - Shows zero values when IncludeZeroValues is specified' {
                $result = New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName -IncludeZeroValues
                $result | Should -Be '2 hours 30 minutes 10 seconds 0 milliseconds 0 microseconds'
            }
            
            It 'Format-TimeSpan - Single unit without IncludeZeroValues' {
                $result = [TimeSpan]::FromMilliseconds(500) | Format-TimeSpan -Format FullName
                $result | Should -Be '500 milliseconds'
            }
            
            It 'Format-TimeSpan - Single unit with IncludeZeroValues' {
                $result = [TimeSpan]::FromMilliseconds(500) | Format-TimeSpan -Format FullName -IncludeZeroValues
                $result | Should -Be '500 milliseconds 0 microseconds'
            }
        }

        Context 'Format-TimeSpan - Backward Compatibility' {
            It 'Format-TimeSpan - Explicit Precision 1 works as before (rounded)' {
                $result = New-TimeSpan -Minutes 90 | Format-TimeSpan -Precision 1
                $result | Should -Be '2h'
            }
            
            It 'Format-TimeSpan - Explicit precision with zero values still shows zeros' {
                $result = [TimeSpan]::FromMilliseconds(500) | Format-TimeSpan -Precision 2 -Format FullName
                $result | Should -Be '500 milliseconds 0 microseconds'
            }
        }

        Context 'Format-TimeSpan - Format Parameter' {
            It 'Format-TimeSpan - Formats 90 minutes using symbols (shows all non-zero units)' {
                $result = New-TimeSpan -Minutes 90 | Format-TimeSpan -Format Symbol
                $result | Should -Be '1h 30m'
            }
            It 'Format-TimeSpan - Formats 90 minutes using abbreviations (shows all non-zero units)' {
                $result = New-TimeSpan -Minutes 90 | Format-TimeSpan -Format Abbreviation
                $result | Should -Be '1hr 30min'
            }
            It 'Format-TimeSpan - Formats 5 minutes using symbols' {
                $result = New-TimeSpan -Minutes 5 | Format-TimeSpan -Format Symbol
                $result | Should -Be '5m'
            }
            It 'Format-TimeSpan - Formats seconds using symbols' {
                $result = [TimeSpan]::FromMinutes(2) | Format-TimeSpan -BaseUnit 'Seconds' -Format Symbol
                $result | Should -Be '120s'
            }
            It 'Format-TimeSpan - Formats microseconds using symbols' {
                $result = [TimeSpan]::FromMilliseconds(1) | Format-TimeSpan -BaseUnit 'Microseconds' -Format Symbol
                $result | Should -Be '1000µs'
            }
            It 'Format-TimeSpan - Formats negative 5 minutes using symbols' {
                $result = New-TimeSpan -Minutes -5 | Format-TimeSpan -Format Symbol
                $result | Should -Be '-5m'
            }

            It 'Format-TimeSpan - Formats days using symbols' {
                $result = New-TimeSpan -Days 3 | Format-TimeSpan -Format Symbol
                $result | Should -Be '3d'
            }

            It 'Format-TimeSpan - Formats weeks using symbols' {
                $result = New-TimeSpan -Days 14 | Format-TimeSpan -Format Symbol
                $result | Should -Be '2wk'
            }

            It 'Format-TimeSpan - Formats milliseconds using symbols' {
                $result = [TimeSpan]::FromMilliseconds(500) | Format-TimeSpan -Format Symbol
                $result | Should -Be '500ms'
            }
        }
    }
}
