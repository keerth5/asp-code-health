<%@ Page Language="VB" %>
<html>
<head>
    <title>Format String Errors Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Format string errors - string formatting operations with mismatched parameters
        
        Sub BadFormatStringExamples()
            ' BAD: String.Format with placeholders but no arguments
            Dim message1 = String.Format("Hello {0}!") ' Bad: {0} placeholder but no arguments
            Dim message2 = String.Format("User {0} has {1} points") ' Bad: {0} and {1} placeholders but no arguments
            Dim message3 = String.Format("Welcome {0}, you have {1} messages and {2} notifications") ' Bad: multiple placeholders, no arguments
            
            ' BAD: String.Format with mismatched parameter count
            Dim userName As String = "John"
            Dim points As Integer = 100
            Dim badFormat1 = String.Format("User {0} has {1} points and {2} badges", userName) ' Bad: 3 placeholders, 1 argument
            Dim badFormat2 = String.Format("Hello {0} and {1}!", userName, points, "extra") ' Bad: 2 placeholders, 3 arguments
            Dim badFormat3 = String.Format("{0} {1} {2} {3} {4}", userName, points) ' Bad: 5 placeholders, 2 arguments
            
            ' BAD: Console.WriteLine with placeholders but no arguments
            Console.WriteLine("Error occurred at {0}") ' Bad: placeholder but no arguments
            Console.WriteLine("Processing {0} of {1} items") ' Bad: placeholders but no arguments
            Console.WriteLine("Status: {0}, Progress: {1}%") ' Bad: placeholders but no arguments
            
            ' BAD: High index placeholders with insufficient arguments
            Dim highIndexFormat = String.Format("Item {5} selected", userName) ' Bad: {5} placeholder but only 1 argument
            Dim outOfRangeFormat = String.Format("Data: {3}", userName, points) ' Bad: {3} placeholder but only 2 arguments
        End Sub
        
        Sub MoreBadFormatExamples()
            ' BAD: Complex format strings with mismatched arguments
            Dim complexBad = String.Format("User: {0}, Score: {1}, Level: {2}, Rank: {3}") ' Bad: 4 placeholders, no arguments
            
            ' BAD: Format strings in loops with wrong parameter counts
            For i As Integer = 1 To 5
                Dim loopFormat = String.Format("Processing item {0} of {1}") ' Bad: 2 placeholders, no arguments in loop
                Console.WriteLine(loopFormat)
            Next
            
            ' BAD: Conditional format strings with mismatched parameters
            Dim condition As Boolean = True
            If condition Then
                Dim conditionalFormat = String.Format("Condition is {0} and value is {1}") ' Bad: 2 placeholders, no arguments
            End If
        End Sub
        
        ' GOOD: Proper string formatting with matching parameters
        
        Sub GoodFormatStringExamples()
            ' GOOD: String.Format with matching placeholders and arguments
            Dim userName As String = "John"
            Dim points As Integer = 100
            Dim level As String = "Expert"
            
            Dim goodMessage1 = String.Format("Hello {0}!", userName) ' Good: 1 placeholder, 1 argument
            Dim goodMessage2 = String.Format("User {0} has {1} points", userName, points) ' Good: 2 placeholders, 2 arguments
            Dim goodMessage3 = String.Format("Welcome {0}, you have {1} points and are {2} level", userName, points, level) ' Good: 3 placeholders, 3 arguments
        End Sub
        
        Sub GoodConsoleWriteLineExamples()
            ' GOOD: Console.WriteLine with matching placeholders and arguments
            Dim timestamp As DateTime = DateTime.Now
            Dim itemCount As Integer = 50
            Dim totalItems As Integer = 100
            
            Console.WriteLine("Error occurred at {0}", timestamp) ' Good: 1 placeholder, 1 argument
            Console.WriteLine("Processing {0} of {1} items", itemCount, totalItems) ' Good: 2 placeholders, 2 arguments
            Console.WriteLine("Status: {0}, Progress: {1}%", "Running", 75) ' Good: 2 placeholders, 2 arguments
        End Sub
        
        Sub GoodComplexFormatExamples()
            ' GOOD: Complex format strings with proper argument counts
            Dim userName As String = "Alice"
            Dim score As Integer = 1500
            Dim level As Integer = 10
            Dim rank As String = "Gold"
            
            Dim complexGood = String.Format("User: {0}, Score: {1}, Level: {2}, Rank: {3}", userName, score, level, rank) ' Good: 4 placeholders, 4 arguments
            ProcessMessage(complexGood)
        End Sub
        
        Sub GoodFormatInLoops()
            ' GOOD: Format strings in loops with proper parameter counts
            For i As Integer = 1 To 5
                Dim loopFormat = String.Format("Processing item {0} of {1}", i, 5) ' Good: 2 placeholders, 2 arguments
                Console.WriteLine(loopFormat)
            Next
        End Sub
        
        Sub GoodConditionalFormatStrings()
            ' GOOD: Conditional format strings with proper parameters
            Dim condition As Boolean = True
            Dim value As Integer = 42
            
            If condition Then
                Dim conditionalFormat = String.Format("Condition is {0} and value is {1}", condition, value) ' Good: 2 placeholders, 2 arguments
                ProcessMessage(conditionalFormat)
            End If
        End Sub
        
        Sub GoodStringInterpolation()
            ' GOOD: Using string interpolation (VB.NET 14+)
            Dim userName As String = "Bob"
            Dim points As Integer = 250
            
            ' Alternative to String.Format - string interpolation
            Dim interpolated = $"Hello {userName}, you have {points} points!" ' Good: string interpolation
            ProcessMessage(interpolated)
        End Sub
        
        Sub GoodStringBuilderFormatting()
            ' GOOD: StringBuilder with proper formatting
            Dim sb As New StringBuilder()
            Dim userName As String = "Charlie"
            Dim status As String = "Active"
            
            sb.AppendFormat("User: {0}", userName) ' Good: 1 placeholder, 1 argument
            sb.AppendFormat(" - Status: {0}", status) ' Good: 1 placeholder, 1 argument
            
            Dim result = sb.ToString()
            ProcessMessage(result)
        End Sub
        
        Sub GoodParameterArrayFormatting()
            ' GOOD: Using parameter arrays for flexible formatting
            Dim values() As Object = {"Test", 123, True, DateTime.Now}
            Dim dynamicFormat = String.Format("Values: {0}, {1}, {2}, {3}", values) ' Good: matches array length
            ProcessMessage(dynamicFormat)
        End Sub
        
        Sub GoodFormatWithCulture()
            ' GOOD: Format with culture specification
            Dim amount As Decimal = 1234.56D
            Dim date As DateTime = DateTime.Now
            
            Dim cultureFormat = String.Format(CultureInfo.InvariantCulture, "Amount: {0:C}, Date: {1:d}", amount, date) ' Good: 2 placeholders, 2 arguments
            ProcessMessage(cultureFormat)
        End Sub
        
        Sub GoodFormatValidation()
            ' GOOD: Validating format strings before use
            Dim formatString As String = GetFormatString()
            Dim args() As Object = GetFormatArguments()
            
            If ValidateFormatString(formatString, args.Length) Then
                Dim validatedFormat = String.Format(formatString, args) ' Good: validated before use
                ProcessMessage(validatedFormat)
            End If
        End Sub
        
        Sub GoodTryFormatPattern()
            ' GOOD: Using try-catch for format protection
            Dim formatString As String = "User {0} has {1} items"
            Dim userName As String = "David"
            Dim itemCount As Integer = 5
            
            Try
                Dim safeFormat = String.Format(formatString, userName, itemCount) ' Good: protected by try-catch
                ProcessMessage(safeFormat)
            Catch ex As FormatException
                ' Handle format exception appropriately
                LogError("Format string error: " & ex.Message)
                ProcessMessage("Format error occurred")
            End Try
        End Sub
        
        Sub GoodSimpleStringConcatenation()
            ' GOOD: Simple concatenation when formatting isn't needed
            Dim userName As String = "Eve"
            Dim simpleMessage = "Hello " & userName & "!" ' Good: simple concatenation
            ProcessMessage(simpleMessage)
        End Sub
        
        Function ValidateFormatString(formatStr As String, argCount As Integer) As Boolean
            ' GOOD: Format string validation function
            If String.IsNullOrEmpty(formatStr) Then Return False
            
            ' Simple validation - count placeholders
            Dim placeholderCount As Integer = 0
            For i As Integer = 0 To 9
                If formatStr.Contains("{" & i.ToString() & "}") Then
                    placeholderCount = i + 1
                End If
            Next
            
            Return placeholderCount <= argCount ' Good: validate argument count
        End Function
        
        Function GetFormatString() As String
            Return "Processing {0} with status {1}"
        End Function
        
        Function GetFormatArguments() As Object()
            Return New Object() {"data", "complete"}
        End Function
        
        Sub ProcessMessage(message As String)
        End Sub
        
        Sub LogError(message As String)
        End Sub
    </script>
</body>
</html>
