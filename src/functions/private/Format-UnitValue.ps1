function Format-UnitValue {
    <#
        .SYNOPSIS
        Formats a numerical value with its corresponding unit.

        .DESCRIPTION
        This function takes an integer value and a unit and returns a formatted string.
        The format can be specified as Symbol, Abbreviation, FullName, or FullNameWithAlternative.

        .EXAMPLE
        Format-UnitValue -Value 5 -Unit 'Hours' -Format Symbol

        Output:
        ```powershell
        5h
        ```

        Returns the formatted value with its symbol.

        .EXAMPLE
        Format-UnitValue -Value 5 -Unit 'Hours' -Format Abbreviation

        Output:
        ```powershell
        5hr
        ```

        Returns the formatted value with its abbreviation.

        .EXAMPLE
        Format-UnitValue -Value 1 -Unit 'Hours' -Format FullName

        Output:
        ```powershell
        1 hour
        ```

        Returns the formatted value with the full singular unit name.

        .EXAMPLE
        Format-UnitValue -Value 2 -Unit 'Hours' -Format FullName

        Output:
        ```powershell
        2 hours
        ```

        Returns the formatted value with the full plural unit name.



        .OUTPUTS
        string. A formatted string combining the value and its corresponding unit in the specified format.

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

        # The format for displaying the unit.
        [Parameter()]
        [ValidateSet('Symbol', 'Abbreviation', 'FullName')]
        [string] $Format = 'Symbol'
    )

    switch ($Format) {
        'FullName' {
            # Choose singular or plural form based on the value.
            $unitName = if ($Value -eq 1) { $script:UnitMap[$Unit].Singular } else { $script:UnitMap[$Unit].Plural }
            return "$Value $unitName"
        }
        'Abbreviation' {
            return "$Value$($script:UnitMap[$Unit].Abbreviation)"
        }
        'Symbol' {
            return "$Value$($script:UnitMap[$Unit].Symbol)"
        }
    }
}
