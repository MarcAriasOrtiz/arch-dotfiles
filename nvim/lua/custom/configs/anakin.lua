local util = require("lspconfig.util")

return {
  default_config = {
    cmd = { "anakinls" },
    filetypes = { "python" },
    root_dir = util.root_pattern(
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      ".git"
    ),
    settings = {
      anakinls = {
        pyflakes_errors = {
          "ImportStarNotPermitted",
          "UndefinedExport",
          "UndefinedLocal",
          "UndefinedName",
          "DuplicateArgument",
          "MultiValueRepeatedKeyLiteral",
          "MultiValueRepeatedKeyVariable",
          "FutureFeatureNotDefined",
          "LateFutureImport",
          "ReturnOutsideFunction",
          "YieldOutsideFunction",
          "ContinueOutsideLoop",
          "BreakOutsideLoop",
          "TwoStarredExpressions",
          "TooManyExpressionsInStarredAssignment",
          "ForwardAnnotationSyntaxError",
          "RaiseNotImplemented",
          "StringDotFormatExtraPositionalArguments",
          "StringDotFormatExtraNamedArguments",
          "StringDotFormatMissingArgument",
          "StringDotFormatMixingAutomatic",
          "StringDotFormatInvalidFormat",
          "PercentFormatInvalidFormat",
          "PercentFormatMixedPositionalAndNamed",
          "PercentFormatUnsupportedFormat",
          "PercentFormatPositionalCountMismatch",
          "PercentFormatExtraNamedArguments",
          "PercentFormatMissingArgument",
          "PercentFormatExpectedMapping",
          "PercentFormatExpectedSequence",
          "PercentFormatStarRequiresSequence"
        }
      }
    }
  }
}
