<%@ Page Language="VB" %>
<html>
<head>
    <title>Long Line Length Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Lines exceeding 120 characters
        Dim VeryLongVariableNameThatExceedsTheRecommendedLineLengthLimitAndShouldBeReportedAsAViolationBecauseItMakesCodeHardToRead As String
        Private AnotherVeryLongVariableNameThatDefinitelyExceedsTheMaximumLineLengthAndShouldTriggerTheRuleForLongLinesInTheCode As Integer
        
        Sub VeryLongMethodNameThatExceedsRecommendedLengthLimitsAndMakesCodeDifficultToReadAndShouldBeDetectedByTheLongLineRule()
            Response.Write("This is a very long line that exceeds the recommended maximum line length of 120 characters and should be detected")
            Dim result = CalculateVeryComplexResultWithMultipleParametersAndLongMethodNamesThatsExceedTheLineLengthLimit(param1, param2, param3)
        End Sub
        
        Function AnotherVeryLongMethodNameThatExceedsTheRecommendedLineLengthAndShouldBeDetectedByTheStaticAnalysisRule() As String
            Return "This is another very long line that definitely exceeds the maximum recommended line length and should be flagged by the rule"
        End Function
        
        ' BAD: Even longer lines exceeding 150 characters
        Dim ExtremelyLongVariableNameThatDefinitelyExceedsEvenTheExtendedLineLengthLimitOf150CharactersAndShouldAbsolutelyBeDetectedByTheStaticAnalysisRuleForLongLines As String = "Very long value"
        
        ' GOOD: Lines within acceptable length
        Dim ShortName As String
        Private Counter As Integer
        Public IsActive As Boolean
        
        Sub ShortMethod()
            Response.Write("Short line")
            Dim result = Calculate(param1, param2)
        End Sub
        
        Function GetValue() As String
            Return "Short return value"
        End Function
        
        ' GOOD: Properly wrapped long lines
        Dim LongButWrappedVariable As String = _
            "This long string is properly wrapped"
        
        Sub MethodWithLongParameters( _
            parameter1 As String, _
            parameter2 As Integer, _
            parameter3 As Boolean)
            ' Method body
        End Sub
        
        ' Edge case: Line exactly at 120 characters
        Dim ExactlyAtLimitVariableNameThatIsExactly120CharactersLongAndShouldNotTriggerTheRuleForLongLines As String
    </script>
</body>
</html>
