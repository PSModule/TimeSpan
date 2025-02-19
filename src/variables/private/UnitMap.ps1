$script:AverageDaysInMonth = 30.436875
$script:AverageDaysInYear = 365.2425
$script:DaysInWeek = 7
$script:HoursInDay = 24

$script:UnitMap = [ordered]@{
    'Millennia'    = @{
        Singular     = 'millennium'
        Plural       = 'millennia'
        Abbreviation = 'mil'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear * 1000
    }
    'Centuries'    = @{
        Singular     = 'century'
        Plural       = 'centuries'
        Abbreviation = 'cent'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear * 100
    }
    'Decades'      = @{
        Singular     = 'decade'
        Plural       = 'decades'
        Abbreviation = 'dec'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear * 10
    }
    'Years'        = @{
        Singular     = 'year'
        Plural       = 'years'
        Abbreviation = 'y'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInYear
    }
    'Months'       = @{
        Singular     = 'month'
        Plural       = 'months'
        Abbreviation = 'mo'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:AverageDaysInMonth
    }
    'Weeks'        = @{
        Singular     = 'week'
        Plural       = 'weeks'
        Abbreviation = 'w'
        Ticks        = [System.TimeSpan]::TicksPerDay * $script:DaysInWeek
    }
    'Days'         = @{
        Singular     = 'day'
        Plural       = 'days'
        Abbreviation = 'd'
        Ticks        = [System.TimeSpan]::TicksPerDay
    }
    'Hours'        = @{
        Singular     = 'hour'
        Plural       = 'hours'
        Abbreviation = 'h'
        Ticks        = [System.TimeSpan]::TicksPerHour
    }
    'Minutes'      = @{
        Singular     = 'minute'
        Plural       = 'minutes'
        Abbreviation = 'm'
        Ticks        = [System.TimeSpan]::TicksPerMinute
    }
    'Seconds'      = @{
        Singular     = 'second'
        Plural       = 'seconds'
        Abbreviation = 's'
        Ticks        = [System.TimeSpan]::TicksPerSecond
    }
    'Milliseconds' = @{
        Singular     = 'millisecond'
        Plural       = 'milliseconds'
        Abbreviation = 'ms'
        Ticks        = [System.TimeSpan]::TicksPerMillisecond
    }
    'Microseconds' = @{
        Singular     = 'microsecond'
        Plural       = 'microseconds'
        Abbreviation = 'us'
        Ticks        = 10
    }
}
