function Format-UnitValue {
    <#
        .SYNOPSIS
        Formats a numerical value with its corresponding unit.

        .DESCRIPTION
        This function takes an integer value and a unit and returns a formatted string.
        If the -FullNames switch is specified, the function uses the singular or plural full unit name.
        If the -UseSymbols switch is specified, the function uses symbols instead of abbreviations.
        Otherwise, it returns the value with the unit abbreviation.

        .EXAMPLE
        Format-UnitValue -Value 5 -Unit 'Hours'

        Output:
        ```powershell
        5hr
        ```

        Returns the formatted value with its abbreviation.

        .EXAMPLE
        Format-UnitValue -Value 5 -Unit 'Hours' -UseSymbols

        Output:
        ```powershell
        5h
        ```

        Returns the formatted value with its symbol.

        .EXAMPLE
        Format-UnitValue -Value 1 -Unit 'Hours' -FullNames

        Output:
        ```powershell
        1 hour
        ```

        Returns the formatted value with the full singular unit name.

        .EXAMPLE
        Format-UnitValue -Value 2 -Unit 'Hours' -FullNames

        Output:
        ```powershell
        2 hours
        ```

        Returns the formatted value with the full plural unit name.

        .OUTPUTS
        string. A formatted string combining the value and its corresponding unit abbreviation, symbol, or full name.

        .LINK
        https://psmodule.io/Format/Functions/Format-UnitValue/
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        # The numerical value to be formatted with a unit.
        [Parameter(Mandatory)]
        [System.Int128] $Value,

        # The unit type to append to the value.
        [Parameter(Mandatory)]
        [string] $Unit,

        # Switch to use full unit names instead of abbreviations or symbols.
        [Parameter()]
        [switch] $FullNames,

        # Switch to use symbols instead of abbreviations.
        [Parameter()]
        [switch] $UseSymbols
    )

    if ($FullNames) {
        # Choose singular or plural form based on the value.
        $unitName = if ($Value -eq 1) { $script:UnitMap[$Unit].Singular } else { $script:UnitMap[$Unit].Plural }
        return "$Value $unitName"
    }

    if ($UseSymbols) {
        "$Value$($script:UnitMap[$Unit].Symbol)"
    } else {
        "$Value$($script:UnitMap[$Unit].Abbreviation)"
    }
}
