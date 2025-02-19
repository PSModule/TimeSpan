function Format-TimeSpan {
    <#
    .SYNOPSIS
      Formats a TimeSpan into a human-readable string with configurable precision, base unit, name style,
      and support for extended units (decade, century, millennia).

    .DESCRIPTION
      This version of Format-TimeSpan supports several parameters:
        - Precision: The number of units to display. Default is 1.
        - BaseUnit: Forces the breakdown to start at a specified unit (e.g. 'Millennia','Centuries','Decades',
          'Years','Months','Weeks','Days','Hours','Minutes','Seconds','Milliseconds','Microseconds','Nanoseconds').
        - FullNames: If specified, the function returns the full unit name (with proper singular/plural) instead of abbreviations.

      For Precision=1, the function uses a “fractional” approach (rounding the total time to the chosen unit).
      For multi-component output (Precision > 1), it performs a sequential breakdown (using floor for higher components
      and rounding for the final component).

    .PARAMETER TimeSpan
      The TimeSpan object to be formatted.

    .PARAMETER Precision
      The number of units to display. Default is 1.

    .PARAMETER BaseUnit
      The unit at which to start the breakdown. Valid values are:
      'Millennia','Centuries','Decades','Years','Months','Weeks','Days','Hours','Minutes','Seconds','Milliseconds','Microseconds','Nanoseconds'.
      If not provided, the function picks the most significant nonzero unit.

    .PARAMETER FullNames
      Switch to output full unit names (e.g. "year"/"years") instead of abbreviations (e.g. "y").

    .EXAMPLE
      [TimeSpan]::FromDays(45) | Format-TimeSpan -Precision 1
      # Might output: "1mo"

    .EXAMPLE
      [TimeSpan]::FromDays(45) | Format-TimeSpan -Precision 2 -FullNames
      # Might output: "1 month 14 days"

    .EXAMPLE
      [TimeSpan]::FromDays(3652) | Format-TimeSpan -Precision 2 -FullNames
      # Might output: "1 decade 1 year" (depending on rounding)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [TimeSpan] $TimeSpan,

        [int] $Precision = 1,

        [ValidateSet('Millennia', 'Centuries', 'Decades', 'Years', 'Months', 'Weeks', 'Days', 'Hours', 'Minutes', 'Seconds', 'Milliseconds', 'Microseconds', 'Nanoseconds')]
        [string] $BaseUnit,

        [switch] $FullNames
    )

    process {
        #----- 1) Handle negative TimeSpan -----
        $isNegative = $TimeSpan.Ticks -lt 0
        if ($isNegative) {
            $TimeSpan = New-TimeSpan -Ticks (-1 * $TimeSpan.Ticks)
        }
        $originalTicks = $TimeSpan.Ticks

        #----- 2) Define tick constants -----
        [long] $ticksInMillisecond = 10000       # 1 ms = 10,000 ticks
        [long] $ticksInSecond = 10000000      # 1 s  = 10,000,000 ticks
        [long] $ticksInMinute = $ticksInSecond * 60
        [long] $ticksInHour = $ticksInMinute * 60
        [long] $ticksInDay = $ticksInHour * 24
        [long] $ticksInWeek = $ticksInDay * 7

        # Approximate day-based constants for months & years
        [double] $daysInMonth = 30.436875
        [double] $daysInYear = 365.2425
        [long] $ticksInMonth = [long]($daysInMonth * $ticksInDay)
        [long] $ticksInYear = [long]($daysInYear * $ticksInDay)

        # Extended units
        [long] $ticksInDecade = 10 * $ticksInYear
        [long] $ticksInCentury = 100 * $ticksInYear
        [long] $ticksInMillennia = 1000 * $ticksInYear

        $unitTicksMapping = @{
            'Millennia'    = $ticksInMillennia
            'Centuries'    = $ticksInCentury
            'Decades'      = $ticksInDecade
            'Years'        = $ticksInYear
            'Months'       = $ticksInMonth
            'Weeks'        = $ticksInWeek
            'Days'         = $ticksInDay
            'Hours'        = $ticksInHour
            'Minutes'      = $ticksInMinute
            'Seconds'      = $ticksInSecond
            'Milliseconds' = $ticksInMillisecond
            'Microseconds' = 10
        }

        # Ordered list of units from most to least significant.
        $orderedUnits = @(
            'Millennia'
            'Centuries'
            'Decades'
            'Years'
            'Months'
            'Weeks'
            'Days'
            'Hours'
            'Minutes'
            'Seconds'
            'Milliseconds'
            'Microseconds'
            'Nanoseconds'
        )

        #----- 4) Single-component vs. Multi-component formatting -----
        if ($Precision -eq 1) {
            # For precision=1, use the “fractional” approach.
            if ($BaseUnit) {
                $chosenUnit = $BaseUnit
            } else {
                # Pick the most significant unit that fits (unless all are zero).
                $chosenUnit = $null
                foreach ($unit in $orderedUnits) {
                    if ($unit -eq 'Nanoseconds') {
                        if ($originalTicks -gt 0) { $chosenUnit = 'Nanoseconds'; break }
                    } else {
                        if ($unitTicksMapping.ContainsKey($unit) -and $originalTicks -ge $unitTicksMapping[$unit]) {
                            $chosenUnit = $unit; break
                        }
                    }
                }
                if (-not $chosenUnit) { $chosenUnit = 'Nanoseconds' }
            }

            if ($chosenUnit -eq 'Nanoseconds') {
                $fractionalValue = $originalTicks * 100
            } else {
                $fractionalValue = $originalTicks / $unitTicksMapping[$chosenUnit]
            }
            $roundedValue = [math]::Round($fractionalValue, 0, [System.MidpointRounding]::AwayFromZero)
            $formatted = Format-UnitValue -value $roundedValue -unit $chosenUnit
            if ($isNegative) { $formatted = "-$formatted" }
            return $formatted
        } else {
            # For multi-component output, perform a sequential breakdown.
            if ($BaseUnit) {
                $startingIndex = $orderedUnits.IndexOf($BaseUnit)
                if ($startingIndex -lt 0) { throw "Invalid BaseUnit value: $BaseUnit" }
            } else {
                $startingIndex = 0
                foreach ($unit in $orderedUnits) {
                    if ($unit -eq 'Nanoseconds') {
                        if ($originalTicks -gt 0) { break }
                    } else {
                        if ($unitTicksMapping.ContainsKey($unit) -and $originalTicks -ge $unitTicksMapping[$unit]) { break }
                    }
                    $startingIndex++
                }
                if ($startingIndex -ge $orderedUnits.Count) { $startingIndex = $orderedUnits.Count - 1 }
            }

            $resultSegments = @()
            $remainder = $originalTicks
            $endIndex = [Math]::Min($startingIndex + $Precision - 1, $orderedUnits.Count - 1)
            for ($i = $startingIndex; $i -le $endIndex; $i++) {
                $unit = $orderedUnits[$i]
                if ($unit -eq 'Nanoseconds') {
                    $value = $remainder * 100
                    $remainder = 0
                } else {
                    $unitTicks = $unitTicksMapping[$unit]
                    if ($i -eq $endIndex) {
                        $value = [math]::Round($remainder / $unitTicks, 0, [System.MidpointRounding]::AwayFromZero)
                    } else {
                        $value = [math]::Floor($remainder / $unitTicks)
                    }
                    $remainder = $remainder - ($value * $unitTicks)
                }
                $resultSegments += Format-UnitValue -value $value -unit $unit
            }
            $formatted = $resultSegments -join ' '
            if ($isNegative) { $formatted = "-$formatted" }
            return $formatted
        }
    }
}
