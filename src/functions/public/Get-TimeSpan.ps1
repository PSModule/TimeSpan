function Get-TimeSpan {
    <#
        .SYNOPSIS
        Gets a TimeSpan representing the difference between two DateTime values.

        .DESCRIPTION
        This function calculates the time difference between a Start DateTime and End DateTime.
        By default, both Start and End parameters default to the current time ([DateTime]::Now).
        If neither Start nor End is provided (both use defaults), the function returns TimeSpan.Zero.
        The function allows negative values by default, but can return zero for negative values using the StopAtZero parameter.

        .EXAMPLE
        $futureTime = [DateTime]::Now.AddMinutes(30)
        Get-TimeSpan -End $futureTime

        Output:
        ```powershell
        00:30:00
        ```

        Returns a TimeSpan representing 30 minutes until the end time.

        .EXAMPLE
        $pastTime = [DateTime]::Now.AddMinutes(-30)
        Get-TimeSpan -End $pastTime

        Output:
        ```powershell
        -00:30:00
        ```

        Returns a negative TimeSpan showing the end time was 30 minutes ago.

        .EXAMPLE
        $pastTime = [DateTime]::Now.AddMinutes(-30)
        Get-TimeSpan -End $pastTime -StopAtZero

        Output:
        ```powershell
        00:00:00
        ```

        Returns TimeSpan.Zero since the result would be negative and StopAtZero is specified.

        .EXAMPLE
        $startTime = [DateTime]::Now.AddHours(-2)
        $endTime = [DateTime]::Now
        Get-TimeSpan -Start $startTime -End $endTime

        Output:
        ```powershell
        02:00:00
        ```

        Returns a positive TimeSpan showing the duration between start and end times.

        .EXAMPLE
        Get-TimeSpan

        Output:
        ```powershell
        00:00:00
        ```

        Returns TimeSpan.Zero when both Start and End use their default values.

        .OUTPUTS
        System.TimeSpan

        .NOTES
        The TimeSpan representing the difference between the Start and End DateTime values (End - Start).

        .LINK
        https://psmodule.io/TimeSpan/Functions/Get-TimeSpan/
    #>
    [CmdletBinding()]
    [OutputType([TimeSpan])]
    param(
        # The start DateTime. Defaults to current time.
        [Parameter(ValueFromPipelineByPropertyName)]
        [DateTime] $Start = [DateTime]::Now,

        # The end DateTime. Defaults to current time.
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [DateTime] $End = [DateTime]::Now,

        # If specified, returns TimeSpan.Zero instead of negative values.
        [Parameter()]
        [switch] $StopAtZero
    )

    process {
        # Check if both parameters are using their default values
        $startIsDefault = $PSBoundParameters.Keys -notcontains 'Start'
        $endIsDefault = $PSBoundParameters.Keys -notcontains 'End'
        
        if ($startIsDefault -and $endIsDefault) {
            return [TimeSpan]::Zero
        }

        # Calculate the time difference: End - Start
        $timeSpan = $End - $Start

        # Handle negative values based on StopAtZero parameter
        if ($timeSpan.TotalSeconds -lt 0 -and $StopAtZero) {
            return [TimeSpan]::Zero
        }

        return $timeSpan
    }
}