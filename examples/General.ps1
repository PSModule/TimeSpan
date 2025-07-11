<#
  .SYNOPSIS
    This is a general example of how to use the module.
#>

# Import required functions
. ./src/variables/private/UnitMap.ps1
. ./src/functions/private/Format-UnitValue.ps1
. ./src/functions/public/Format-TimeSpan.ps1
. ./src/functions/public/Get-TimeSpan.ps1

Write-Host "=== TimeSpan Module Examples ===" -ForegroundColor Green

# Example 1: Format existing TimeSpan
Write-Host "`n1. Formatting TimeSpan objects:" -ForegroundColor Yellow
$timespan = New-TimeSpan -Hours 2 -Minutes 30 -Seconds 15
Write-Host "Original TimeSpan: $($timespan.ToString())"
Write-Host "Formatted: $(Format-TimeSpan $timespan)"
Write-Host "Formatted with precision 3: $(Format-TimeSpan $timespan -Precision 3 -FullNames)"

# Example 2: Get TimeSpan using default behavior (returns Zero)
Write-Host "`n2. Default behavior (both Start and End use current time):" -ForegroundColor Yellow
$defaultResult = Get-TimeSpan
Write-Host "Get-TimeSpan with no parameters: $($defaultResult.ToString())"

# Example 3: Get TimeSpan to future event
Write-Host "`n3. Getting TimeSpan to future events:" -ForegroundColor Yellow
$futureEvent = [DateTime]::Now.AddHours(3).AddMinutes(45)
$countdown = Get-TimeSpan -End $futureEvent
Write-Host "Event in future: $($futureEvent.ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Host "Time until event: $($countdown.ToString())"
Write-Host "Formatted countdown: $(Format-TimeSpan $countdown -Precision 2 -FullNames)"

# Example 4: Get TimeSpan between two specific times
Write-Host "`n4. Getting TimeSpan between specific Start and End times:" -ForegroundColor Yellow
$startTime = [DateTime]::Now.AddHours(-2)
$endTime = [DateTime]::Now.AddHours(1)
$duration = Get-TimeSpan -Start $startTime -End $endTime
Write-Host "Start time: $($startTime.ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Host "End time: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Host "Duration: $($duration.ToString())"
Write-Host "Formatted duration: $(Format-TimeSpan $duration -Precision 2 -FullNames)"

# Example 5: Handling negative values
Write-Host "`n5. Handling negative TimeSpan values:" -ForegroundColor Yellow
$pastDeadline = [DateTime]::Now.AddHours(-2)
$defaultResult = Get-TimeSpan -End $pastDeadline
$stopAtZeroResult = Get-TimeSpan -End $pastDeadline -StopAtZero

Write-Host "Past deadline: $($pastDeadline.ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Host "Default result (allows negative): $($defaultResult.ToString())"
Write-Host "StopAtZero result: $($stopAtZeroResult.ToString())"
Write-Host "Formatted negative: $(Format-TimeSpan $defaultResult -FullNames)"

# Example 6: Pipeline usage
Write-Host "`n6. Pipeline usage:" -ForegroundColor Yellow
$events = @(
    [DateTime]::Now.AddMinutes(15),
    [DateTime]::Now.AddHours(2),
    [DateTime]::Now.AddDays(1)
)

Write-Host "Multiple upcoming events:"
$events | ForEach-Object {
    $timeLeft = $_ | Get-TimeSpan
    Write-Host "  Event at $($_.ToString('HH:mm:ss')): $(Format-TimeSpan $timeLeft -Precision 2)"
}

Write-Host "`n=== Examples Complete ===" -ForegroundColor Green
