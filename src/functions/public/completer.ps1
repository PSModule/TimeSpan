Register-ArgumentCompleter -CommandName Format-TimeSpan -ParameterName BaseUnit -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    $null = $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter
    $($script:UnitMap.Keys) | Where-Object { $_ -like "$wordToComplete*" }
}
