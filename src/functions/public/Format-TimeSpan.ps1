function Format-TimeSpan {
    <#
        .SYNOPSIS
        Formats a TimeSpan object into a human-readable string.

        .DESCRIPTION
        This function converts a TimeSpan object into a formatted string based on a chosen unit or precision.
        By default, it shows all units that have non-zero values. You can specify a base unit, the number of 
        precision levels, and the format for displaying units. If the TimeSpan is negative, it is prefixed 
        with a minus sign.

        .EXAMPLE
        New-TimeSpan -Minutes 90 | Format-TimeSpan

        Output:
        ```powershell
        1h 30m
        ```

        Formats the given TimeSpan showing all non-zero units with symbols (default behavior).

        .EXAMPLE
        New-TimeSpan -Minutes 90 | Format-TimeSpan -Format Abbreviation

        Output:
        ```powershell
        1hr 30min
        ```

        Formats the given TimeSpan showing all non-zero units using abbreviations instead of symbols.

        .EXAMPLE
        New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName

        Output:
        ```powershell
        2 hours 30 minutes 10 seconds
        ```

        Shows all non-zero units in full name format.

        .EXAMPLE
        New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName -IncludeZeroValues

        Output:
        ```powershell
        2 hours 30 minutes 10 seconds 0 milliseconds 0 microseconds
        ```

        Shows all units including those with zero values when the IncludeZeroValues switch is used.

        .EXAMPLE
        [TimeSpan]::FromSeconds(3661) | Format-TimeSpan -Precision 2 -Format FullName

        Output:
        ```powershell
        1 hour 1 minute
        ```

        Returns the TimeSpan formatted into exactly 2 components using full unit names.

        .EXAMPLE
        New-TimeSpan -Minutes 90 | Format-TimeSpan -Precision 1

        Output:
        ```powershell
        2h
        ```

        When precision is explicitly set to 1, uses the traditional behavior of showing only the most significant unit (rounded).



        .OUTPUTS
        System.String

        .NOTES
        The formatted string representation of the TimeSpan.

        .LINK
        https://psmodule.io/TimeSpan/Functions/Format-TimeSpan/
    #>
    [CmdletBinding()]
    param(
        # The TimeSpan object to format.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [TimeSpan] $TimeSpan,

        # Specifies the number of precision levels to include in the output. If not specified, automatically shows all units with non-zero values.
        [Parameter()]
        [int] $Precision,

        # Specifies the base unit to use for formatting the TimeSpan.
        [Parameter()]
        [string] $BaseUnit,

        # Specifies the format for displaying time units.
        [Parameter()]
        [ValidateSet('Symbol', 'Abbreviation', 'FullName')]
        [string] $Format = 'Symbol',

        # Includes units with zero values in the output. By default, only non-zero units are shown.
        [Parameter()]
        [switch] $IncludeZeroValues
    )

    process {
        $isNegative = $TimeSpan.Ticks -lt 0
        if ($isNegative) {
            $TimeSpan = [System.TimeSpan]::FromTicks(-1 * $TimeSpan.Ticks)
        }
        $originalTicks = $TimeSpan.Ticks

        # Ordered list of units from most to least significant.
        $orderedUnits = [System.Collections.ArrayList]::new()
        foreach ($key in $script:UnitMap.Keys) {
            $null = $orderedUnits.Add($key)
        }

        # If Precision is not specified, calculate it based on non-zero units or all units if IncludeZeroValues
        if ($PSBoundParameters.ContainsKey('Precision') -eq $false) {
            if ($IncludeZeroValues) {
                # Include all units when IncludeZeroValues is specified
                $Precision = $orderedUnits.Count
            } else {
                # Calculate how many units have non-zero values
                $nonZeroUnits = 0
                $remainder = $originalTicks
                
                foreach ($unit in $orderedUnits) {
                    $unitTicks = $script:UnitMap[$unit].Ticks
                    $value = [math]::Floor($remainder / $unitTicks)
                    if ($value -gt 0) {
                        $nonZeroUnits++
                    }
                    $remainder = $remainder - ($value * $unitTicks)
                }
                
                # Set precision to the number of non-zero units, minimum 1
                $Precision = [Math]::Max($nonZeroUnits, 1)
            }
        }

        if ($Precision -eq 1) {
            # For precision=1, use the "fractional" approach.
            if ($BaseUnit) {
                $chosenUnit = $BaseUnit
            } else {
                # Pick the most significant unit that fits (unless all are zero).
                $chosenUnit = $null
                foreach ($unit in $orderedUnits) {
                    if (($script:UnitMap.Keys -contains $unit) -and $originalTicks -ge $script:UnitMap[$unit].Ticks) {
                        $chosenUnit = $unit; break
                    }
                }
                if (-not $chosenUnit) { $chosenUnit = 'Microseconds' }
            }

            $fractionalValue = $originalTicks / $script:UnitMap[$chosenUnit].Ticks
            $roundedValue = [math]::Round($fractionalValue, 0, [System.MidpointRounding]::AwayFromZero)
            $formatted = Format-UnitValue -Value $roundedValue -Unit $chosenUnit -Format $Format
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
                    if (($script:UnitMap.Keys -contains $unit) -and $originalTicks -ge $script:UnitMap[$unit].Ticks) { break }
                    $startingIndex++
                }
                if ($startingIndex -ge $orderedUnits.Count) { $startingIndex = $orderedUnits.Count - 1 }
            }

            $resultSegments = @()
            $remainder = $originalTicks
            $endIndex = [Math]::Min($startingIndex + $Precision - 1, $orderedUnits.Count - 1)
            for ($i = $startingIndex; $i -le $endIndex; $i++) {
                $unit = $orderedUnits[$i]
                $unitTicks = $script:UnitMap[$unit].Ticks
                if ($i -eq $endIndex) {
                    $value = [math]::Round($remainder / $unitTicks, 0, [System.MidpointRounding]::AwayFromZero)
                } else {
                    $value = [math]::Floor($remainder / $unitTicks)
                }
                $remainder = $remainder - ($value * $unitTicks)
                
                # When precision is explicitly specified, include values even if they're zero
                # When precision is not specified and IncludeZeroValues is false, only include non-zero values
                $shouldInclude = ($value -gt 0) -or $IncludeZeroValues -or ($PSBoundParameters.ContainsKey('Precision'))
                if ($shouldInclude) {
                    $resultSegments += Format-UnitValue -Value $value -Unit $unit -Format $Format
                }
            }
            $formatted = $resultSegments -join ' '
            if ($isNegative) { $formatted = "-$formatted" }
            return $formatted
        }
    }
}
