# TimeSpan

A PowerShell module for formatting TimeSpan objects into human-readable strings with customizable precision and formatting options.

## Prerequisites

This module uses the [PSModule framework](https://github.com/PSModule) for building, testing and publishing the module.

## Installation

To install the module from the PowerShell Gallery, you can use the following commands:

### For PowerShell 5.1 and later
```powershell
Install-Module -Name TimeSpan -Repository PSGallery
Import-Module -Name TimeSpan
```

### For PowerShell 7+ with PSResourceGet
```powershell
Install-PSResource -Name TimeSpan
Import-Module -Name TimeSpan
```

### For the latest version
```powershell
Install-Module -Name TimeSpan -Force
```

## Usage

The primary function in this module is `Format-TimeSpan`, which converts TimeSpan objects into human-readable formatted strings.

### Example 1: Basic formatting with all non-zero units (new default behavior)

```powershell
New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName
# Output: 2 hours 30 minutes 10 seconds
```

### Example 2: Including zero values

```powershell
New-TimeSpan -Hours 2 -Minutes 30 -Seconds 10 | Format-TimeSpan -Format FullName -IncludeZeroValues
# Output: 2 hours 30 minutes 10 seconds 0 milliseconds 0 microseconds
```

### Example 3: Using different format styles

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

```powershell
# Show only the most significant unit (rounded)
New-TimeSpan -Minutes 90 | Format-TimeSpan -Precision 1
# Output: 2h

# Show specific number of units
[TimeSpan]::FromSeconds(3661) | Format-TimeSpan -Precision 2 -Format FullName
# Output: 1 hour 1 minute
```

### Example 5: Force specific base unit

```powershell
[TimeSpan]::FromMinutes(2) | Format-TimeSpan -BaseUnit 'Seconds'
# Output: 120s
```

### Find more examples

To find more examples of how to use the module, please refer to the [examples](examples) folder.

Alternatively, you can use `Get-Command -Module TimeSpan` to find more commands that are available in the module.
To find examples of each of the commands you can use `Get-Help -Examples Format-TimeSpan`.

## Parameters

### Format-TimeSpan

- **TimeSpan** (Required): The TimeSpan object to format
- **Precision** (Optional): Number of units to include in output. If not specified, shows all non-zero units
- **BaseUnit** (Optional): Force formatting from a specific unit (e.g., 'Seconds', 'Minutes')
- **Format** (Optional): Display format - 'Symbol' (default), 'Abbreviation', or 'FullName'
- **IncludeZeroValues** (Switch): Include units with zero values in the output

## Supported Time Units

The module supports formatting for the following time units (from largest to smallest):
- Millennia, Centuries, Decades, Years, Months, Weeks, Days, Hours, Minutes, Seconds, Milliseconds, Microseconds

## Documentation

For detailed function documentation, use:
```powershell
Get-Help Format-TimeSpan -Full
```

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
