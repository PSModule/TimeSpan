function Format-TimeSpan {
    <#
        .SYNOPSIS
        Formats a TimeSpan object into a human-readable string.

        .DESCRIPTION
        This function converts a TimeSpan object into a formatted string based on a chosen unit or precision.
        It allows specifying a base unit, the number of precision levels, and the format for displaying units.
        If the TimeSpan is negative, it is prefixed with a minus sign.

        .EXAMPLE
        New-TimeSpan -Minutes 90 | Format-TimeSpan

        Output:
        ```powershell
        2h
        ```

        Formats the given TimeSpan into a human-readable format using the most significant unit with symbols (default).

        .EXAMPLE
        New-TimeSpan -Minutes 90 | Format-TimeSpan -Format Abbreviation

        Output:
        ```powershell
        2hr
        ```

        Formats the given TimeSpan using abbreviations instead of symbols.

        .EXAMPLE
        [TimeSpan]::FromSeconds(3661) | Format-TimeSpan -Precision 2 -Format FullName

        Output:
        ```powershell
        1 hour 1 minute
        ```

        Returns the TimeSpan formatted into multiple components using full unit names.



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

        # Specifies the number of precision levels to include in the output.
        [Parameter()]
        [int] $Precision = 1,

        # Specifies the base unit to use for formatting the TimeSpan.
        [Parameter()]
        [string] $BaseUnit,

        # Specifies the format for displaying time units.
        [Parameter()]
        [ValidateSet('Symbol', 'Abbreviation', 'FullName')]
        [string] $Format = 'Symbol'
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
            $orderedUnits.Add($key) | Out-Null
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
                $resultSegments += Format-UnitValue -Value $value -Unit $unit -Format $Format
            }
            $formatted = $resultSegments -join ' '
            if ($isNegative) { $formatted = "-$formatted" }
            return $formatted
        }
    }
}
