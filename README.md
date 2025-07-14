# TimeSpan

A PowerShell module to manage and build functionality on top of the TimeSpan object.

## Prerequisites

This module uses the [PSModule framework](https://github.com/PSModule) for building, testing and publishing the module.

## Installation

To install the module from the PowerShell Gallery, you can use the following commands:

```powershell
Install-PSResource -Name TimeSpan
Import-Module -Name TimeSpan
```

## Usage

### Example 1: Basic formatting with all non-zero units

This example shows the default behavior of `Format-TimeSpan`, which converts TimeSpan objects into human-readable formatted strings showing all units that have non-zero values.

```powershell
New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName
# Output: 2 hours 30 minutes 10 seconds
```

### Example 2: Including zero values

Use the `IncludeZeroValues` parameter to include units with zero values in the output, showing all time units from the highest non-zero unit down to the smallest unit.

```powershell
New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName -IncludeZeroValues
# Output: 2 hours 30 minutes 10 seconds 0 milliseconds 0 microseconds
```

### Example 3: Using different format styles

The Format-TimeSpan function supports three different format styles to display time units in various ways.

```powershell
# Symbol format (default)
New-TimeSpan -Minutes 90 | Format-TimeSpan
# Output: 1h 30m

# Abbreviation format
New-TimeSpan -Minutes 90 | Format-TimeSpan -Format Abbreviation
# Output: 1hr 30min

# Full name format
New-TimeSpan -Minutes 90 | Format-TimeSpan -Format FullName
# Output: 1 hour 30 minutes
```

### Example 4: Explicit precision (backward compatibility)

You can specify an exact number of time units to display using the Precision parameter, which maintains backward compatibility with previous versions.

```powershell
# Show only the most significant unit (rounded)
New-TimeSpan -Minutes 90 | Format-TimeSpan -Precision 1
# Output: 2h

# Show specific number of units
[TimeSpan]::FromSeconds(3661) | Format-TimeSpan -Precision 2 -Format FullName
# Output: 1 hour 1 minute
```

### Example 5: Force specific base unit

Use the BaseUnit parameter to force formatting from a specific time unit, regardless of the actual values in the TimeSpan.

```powershell
[TimeSpan]::FromMinutes(2) | Format-TimeSpan -BaseUnit 'Seconds'
# Output: 120s
```

### Find more examples

To find more examples of how to use the module, please refer to the [examples](examples) folder.

Alternatively, you can use `Get-Command -Module TimeSpan` to find more commands that are available in the module.
To find examples of each of the commands you can use `Get-Help -Examples Format-TimeSpan`.

## Supported Time Units

The module supports formatting for the following time units (from largest to smallest):

| Unit | Singular | Plural | Abbreviation | Symbol |
|------|----------|--------|--------------|--------|
| Millennia | millennium | millennia | mill | kyr |
| Centuries | century | centuries | cent | c |
| Decades | decade | decades | dec | dec |
| Years | year | years | yr | y |
| Months | month | months | mon | mo |
| Weeks | week | weeks | wk | wk |
| Days | day | days | day | d |
| Hours | hour | hours | hr | h |
| Minutes | minute | minutes | min | m |
| Seconds | second | seconds | sec | s |
| Milliseconds | millisecond | milliseconds | msec | ms |
| Microseconds | microsecond | microseconds | µsec | µs |

## Documentation

For detailed function documentation, use:
```powershell
Get-Help Format-TimeSpan -Full
Get-Help Format-TimeSpan -Online
```

You can also use the `-Online` parameter to get the function documentation online. While in VSCode, users can move the cursor to a function and press `Shift+F1` to get to the online documentation.

## Contributing

Coder or not, you can contribute to the project! We welcome all contributions.

### For Users

If you don't code, you still sit on valuable information that can make this project even better. If you experience that the
product does unexpected things, throw errors or is missing functionality, you can help by submitting bugs and feature requests.
Please see the issues tab on this project and submit a new issue that matches your needs.

### For Developers

If you do code, we'd love to have your contributions. Please read the [Contribution guidelines](CONTRIBUTING.md) for more information.
You can either help by picking up an existing issue or submit a new one if you have an idea for a new feature or improvement.

## Acknowledgements

Here is a list of people and projects that helped this project in some way.
