$script:AverageDaysInMonth = 30.436875
$script:AverageDaysInYear = 365.2425
$script:DaysInWeek = 7
$script:HoursInDay = 24

$script:UnitMap = [ordered]@{
    'Millennia'    = @{
        Singular     = 'millennium'
        Plural       = 'millennia'
        Abbreviation = 'mill'
        Symbol       = 'kyr'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear * 1000
    }
    'Centuries'    = @{
        Singular     = 'century'
        Plural       = 'centuries'
        Abbreviation = 'cent'
        Symbol       = 'c'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear * 100
    }
    'Decades'      = @{
        Singular     = 'decade'
        Plural       = 'decades'
        Abbreviation = 'dec'
        Symbol       = 'dec'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear * 10
    }
    'Years'        = @{
        Singular     = 'year'
        Plural       = 'years'
        Abbreviation = 'yr'
        Symbol       = 'y'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear
    }
    'Months'       = @{
        Singular     = 'month'
        Plural       = 'months'
        Abbreviation = 'mon'
        Symbol       = 'mo'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInMonth
    }
    'Weeks'        = @{
        Singular     = 'week'
        Plural       = 'weeks'
        Abbreviation = 'wk'
        Symbol       = 'wk'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:DaysInWeek
    }
    'Days'         = @{
        Singular     = 'day'
        Plural       = 'days'
        Abbreviation = 'day'
        Symbol       = 'd'
        Ticks        = [System.TimeSpan]::TicksPerDay
    }
    'Hours'        = @{
        Singular     = 'hour'
        Plural       = 'hours'
        Abbreviation = 'hr'
        Symbol       = 'h'
        Ticks        = [System.TimeSpan]::TicksPerHour
    }
    'Minutes'      = @{
        Singular     = 'minute'
        Plural       = 'minutes'
        Abbreviation = 'min'
        Symbol       = 'm'
        Ticks        = [System.TimeSpan]::TicksPerMinute
    }
    'Seconds'      = @{
        Singular     = 'second'
        Plural       = 'seconds'
        Abbreviation = 'sec'
        Symbol       = 's'
        Ticks        = [System.TimeSpan]::TicksPerSecond
    }
    'Milliseconds' = @{
        Singular     = 'millisecond'
        Plural       = 'milliseconds'
        Abbreviation = 'msec'
        Symbol       = 'ms'
        Ticks        = [System.TimeSpan]::TicksPerMillisecond
    }
    'Microseconds' = @{
        Singular     = 'microsecond'
        Plural       = 'microseconds'
        Abbreviation = 'µsec'
        Symbol       = "µs"
        Ticks        = 10
    }
}
