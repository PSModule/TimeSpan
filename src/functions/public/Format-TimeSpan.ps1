function Format-TimeSpan {
    <#

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [TimeSpan] $TimeSpan,

        [Parameter()]
        [int] $Precision = 1,

        [Parameter()]
        [ValidateScript({ $_ -in $script:UnitMap.Keys })]
        [string] $BaseUnit,

        [Parameter()]
        [switch] $FullNames
    )

    process {
        $isNegative = $TimeSpan.Ticks -lt 0
        if ($isNegative) {
            $TimeSpan = New-TimeSpan -Ticks (-1 * $TimeSpan.Ticks)
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
                    if ($unitTicksMapping.ContainsKey($unit) -and $originalTicks -ge $unitTicksMapping[$unit]) {
                        $chosenUnit = $unit; break
                    }
                }
                if (-not $chosenUnit) { $chosenUnit = 'Microseconds' }
            }

            $fractionalValue = $originalTicks / $unitTicksMapping[$chosenUnit]
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
                    if ($unitTicksMapping.ContainsKey($unit) -and $originalTicks -ge $unitTicksMapping[$unit]) { break }
                    $startingIndex++
                }
                if ($startingIndex -ge $orderedUnits.Count) { $startingIndex = $orderedUnits.Count - 1 }
            }

            $resultSegments = @()
            $remainder = $originalTicks
            $endIndex = [Math]::Min($startingIndex + $Precision - 1, $orderedUnits.Count - 1)
            for ($i = $startingIndex; $i -le $endIndex; $i++) {
                $unit = $orderedUnits[$i]
                $unitTicks = $unitTicksMapping[$unit]
                if ($i -eq $endIndex) {
                    $value = [math]::Round($remainder / $unitTicks, 0, [System.MidpointRounding]::AwayFromZero)
                } else {
                    $value = [math]::Floor($remainder / $unitTicks)
                }
                $remainder = $remainder - ($value * $unitTicks)
                $resultSegments += Format-UnitValue -value $value -unit $unit
            }
            $formatted = $resultSegments -join ' '
            if ($isNegative) { $formatted = "-$formatted" }
            return $formatted
        }
    }
}
