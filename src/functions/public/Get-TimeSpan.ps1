function Get-TimeSpan {
    <#
        .SYNOPSIS
        Gets a TimeSpan representing the difference between a target DateTime and the current time.

        .DESCRIPTION
        This function calculates the time difference between a specified target DateTime and the current time.
        By default, it calculates Target - Now, which gives a positive value for future times and negative for past times.
        The function can return zero for negative values or the actual negative TimeSpan based on the AllowNegative parameter.
        It can also calculate elapsed time (age) by using the AsAge parameter, which calculates Now - Target.

        .EXAMPLE
        $futureTime = [DateTime]::Now.AddMinutes(30)
        Get-TimeSpan -Target $futureTime

        Output:
        ```powershell
        00:30:00
        ```

        Returns a TimeSpan representing 30 minutes until the target time.

        .EXAMPLE
        $pastTime = [DateTime]::Now.AddMinutes(-30)
        Get-TimeSpan -Target $pastTime

        Output:
        ```powershell
        00:00:00
        ```

        Returns TimeSpan.Zero since the target time is in the past and AllowNegative is not specified.

        .EXAMPLE
        $pastTime = [DateTime]::Now.AddMinutes(-30)
        Get-TimeSpan -Target $pastTime -AllowNegative

        Output:
        ```powershell
        -00:30:00
        ```

        Returns a negative TimeSpan showing the target time was 30 minutes ago.

        .EXAMPLE
        $pastTime = [DateTime]::Now.AddHours(-2)
        Get-TimeSpan -Target $pastTime -AsAge

        Output:
        ```powershell
        02:00:00
        ```

        Returns a positive TimeSpan showing the age/elapsed time since the target.

        .OUTPUTS
        System.TimeSpan

        .NOTES
        The TimeSpan representing the difference between the target DateTime and now.

        .LINK
        https://psmodule.io/TimeSpan/Functions/Get-TimeSpan/
    #>
    [CmdletBinding()]
    [OutputType([TimeSpan])]
    param(
        # The target DateTime to calculate the time difference from.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [DateTime] $Target,

        # If specified, allows returning negative TimeSpan values instead of TimeSpan.Zero for past dates.
        [Parameter()]
        [switch] $AllowNegative,

        # If specified, calculates elapsed time (Now - Target) instead of remaining time (Target - Now).
        [Parameter()]
        [switch] $AsAge
    )

    process {
        if ($AsAge) {
            # Calculate elapsed time: Now - Target
            $timeSpan = [DateTime]::Now - $Target
        } else {
            # Calculate remaining time: Target - Now
            $timeSpan = $Target - [DateTime]::Now
        }

        # Handle negative values based on AllowNegative parameter
        if ($timeSpan.TotalSeconds -lt 0 -and -not $AllowNegative) {
            return [TimeSpan]::Zero
        }

        return $timeSpan
    }
}