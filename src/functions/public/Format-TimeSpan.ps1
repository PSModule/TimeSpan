function Format-TimeSpan {
    <#
        .SYNOPSIS
        Formats a TimeSpan object into a human-readable string.

        .DESCRIPTION
        This function converts a TimeSpan object into a formatted string based on a chosen unit or precision.
        It allows specifying a base unit, the number of precision levels, and whether to use full unit names.
        If the TimeSpan is negative, it is prefixed with a minus sign.

        .EXAMPLE
        New-TimeSpan -Minutes 90 | Format-TimeSpan

        Output:
        ```powershell
        2h
        ```

        Formats the given TimeSpan into a human-readable format using the most significant unit.

        .EXAMPLE
        [TimeSpan]::FromSeconds(3661) | Format-TimeSpan -Precision 2 -FullNames

        Output:
        ```powershell
        1 hour 1 minute
        ```

        Returns the TimeSpan formatted into multiple components based on the specified precision.

        .EXAMPLE
        [TimeSpan]::FromMilliseconds(500) | Format-TimeSpan -Precision 2 -FullNames

        Output:
        ```powershell
        500 milliseconds 0 microseconds
        ```

        Forces the output to be formatted in milliseconds, regardless of precision.

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

        # If specified, outputs full unit names instead of abbreviations.
        [Parameter()]
        [switch] $FullNames
    )

    process {
        $isNegative = $TimeSpan.Ticks -lt 0
        if ($isNegative) {
            $TimeSpan = [System.TimeSpan]::FromTicks(-1 * $TimeSpan.Ticks)
        }
        $originalTicks = $TimeSpan.Ticks

        # Ordered list of units from most to least significant.
        $orderedUnits = @($script:UnitMap.Keys)

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
            $formatted = Format-UnitValue -value $roundedValue -unit $chosenUnit -FullNames:$FullNames
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
                $resultSegments += Format-UnitValue -value $value -unit $unit -FullNames:$FullNames
            }
            $formatted = $resultSegments -join ' '
            if ($isNegative) { $formatted = "-$formatted" }
            return $formatted
        }
    }
}
