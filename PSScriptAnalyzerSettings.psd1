# Find a detailed list of available settings using:
# Get-ScriptAnalyzerRule

@{
    Rules = @{
        #region Braces (OTBS / K&R Style)

        # Enforce opening brace on the same line as keywords (if, function, etc.)
        # This is the core definition of OTBS for PowerShell.
        PSPlaceOpenBrace = @{
            Enable               = $true
            OnSameLine           = $true    # { must be on the same line as the statement
            NewLineAfter         = $true    # Force a newline after {
            IgnoreOneLineBlock   = $true    # Allow single-line blocks: if ($x) { return }
        }

        # Enforce closing brace placement.
        # Allows cuddled else/catch ( } else { ) which is standard for OTBS.
        PSPlaceCloseBrace = @{
            Enable               = $true
            NoEmptyLineBefore    = $true    # Prevents extra blank lines before }
            NewLineAfter         = $true    # Force a newline after }
            IgnoreOneLineBlock   = $true
        }

        #endregion

        #region Indentation & Whitespace

        # Ensure consistent indentation (standard 4 spaces)
        PSUseConsistentIndentation = @{
            Enable          = $true
            Kind            = "space"
            IndentationSize = 4
        }

        # Clean up unnecessary whitespace
        PSUseConsistentWhitespace = @{
            Enable         = $true
            CheckOpenBrace = $true
            CheckOperator  = $true
            CheckPipe      = $true
        }

        #endregion
    }

    ExcludeRules = @(
        "PSAvoidUsingCmdletAliases",
        "PSAvoidUsingInvokeExpression",
        "PSUseShouldProcessForStateChangingFunctions"
    )
}
