<%@ Page Language="VB" %>
<html>
<head>
    <title>Inefficient Regular Expressions Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inefficient regular expressions - uncompiled regex and catastrophic backtracking
        
        Sub BadRegexInLoop()
            ' BAD: Creating new Regex objects in loops
            For i = 1 To 1000
                Dim emailRegex As New Regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}") ' Bad: new Regex in loop
                If emailRegex.IsMatch(emails(i)) Then
                    ProcessValidEmail(emails(i))
                End If
            Next
            
            While hasMoreData
                Dim phoneRegex As New Regex("\d{3}-\d{3}-\d{4}") ' Bad: new Regex in loop
                Dim match = phoneRegex.Match(GetNextPhoneNumber())
                ProcessPhoneMatch(match)
            End While
            
            For Each text In textData
                Dim urlRegex As New Regex("https?://[^\s]+") ' Bad: new Regex in loop
                Dim matches = urlRegex.Matches(text)
                ProcessUrlMatches(matches)
            Next
        End Sub
        
        Sub BadCatastrophicBacktracking()
            ' BAD: Regex patterns prone to catastrophic backtracking
            Dim badPattern1 = "(a+)+b" ' Bad: nested quantifiers
            Dim badPattern2 = "(a|a)*b" ' Bad: alternation with overlap
            Dim badPattern3 = "a*a*a*a*a*a*b" ' Bad: multiple quantifiers
            
            Dim catastrophicRegex1 As New Regex(badPattern1)
            Dim catastrophicRegex2 As New Regex(badPattern2)
            Dim catastrophicRegex3 As New Regex(badPattern3)
            
            ' These will be very slow on certain inputs
            Dim result1 = catastrophicRegex1.IsMatch("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaac")
            Dim result2 = catastrophicRegex2.IsMatch("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaac")
            Dim result3 = catastrophicRegex3.IsMatch("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaac")
        End Sub
        
        Function BadRegexStaticMethods() As Boolean
            ' BAD: Using static Regex methods repeatedly with same patterns
            For Each email In emails
                If Regex.IsMatch(email, "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}") Then ' Bad: static method with pattern
                    ProcessValidEmail(email)
                End If
            Next
            
            For Each phone In phoneNumbers
                Dim match = Regex.Match(phone, "\d{3}-\d{3}-\d{4}") ' Bad: static method with pattern
                If match.Success Then
                    ProcessPhone(match.Value)
                End If
            Next
            
            Return True
        End Function
        
        Sub BadComplexRegexPatterns()
            ' BAD: Overly complex regex patterns that should be simplified
            Dim complexPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
            Dim anotherComplex = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            
            For Each password In passwords
                Dim passwordRegex As New Regex(complexPattern) ' Bad: complex pattern + new instance
                If passwordRegex.IsMatch(password) Then
                    ProcessValidPassword(password)
                End If
            Next
        End Sub
        
        ' GOOD: Efficient regular expression patterns
        
        Public Class GoodRegexPatterns
            ' GOOD: Pre-compiled regex patterns as static fields
            Private Shared ReadOnly EmailRegex As New Regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}", RegexOptions.Compiled)
            Private Shared ReadOnly PhoneRegex As New Regex("\d{3}-\d{3}-\d{4}", RegexOptions.Compiled)
            Private Shared ReadOnly UrlRegex As New Regex("https?://[^\s]+", RegexOptions.Compiled)
            
            Sub GoodCompiledRegexUsage()
                ' GOOD: Using pre-compiled regex objects
                For i = 1 To 1000
                    If EmailRegex.IsMatch(emails(i)) Then ' Good: reusing compiled regex
                        ProcessValidEmail(emails(i))
                    End If
                Next
                
                While hasMoreData
                    Dim match = PhoneRegex.Match(GetNextPhoneNumber()) ' Good: reusing compiled regex
                    ProcessPhoneMatch(match)
                End While
                
                For Each text In textData
                    Dim matches = UrlRegex.Matches(text) ' Good: reusing compiled regex
                    ProcessUrlMatches(matches)
                Next
            End Sub
        End Class
        
        Sub GoodEfficientPatterns()
            ' GOOD: Efficient regex patterns without catastrophic backtracking
            Dim goodPattern1 As New Regex("a+b", RegexOptions.Compiled) ' Good: single quantifier
            Dim goodPattern2 As New Regex("a*b", RegexOptions.Compiled) ' Good: simple pattern
            Dim goodPattern3 As New Regex("a{1,10}b", RegexOptions.Compiled) ' Good: bounded quantifier
            
            ' These are efficient and won't cause performance issues
            Dim result1 = goodPattern1.IsMatch("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaab")
            Dim result2 = goodPattern2.IsMatch("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaab")
            Dim result3 = goodPattern3.IsMatch("aaaaaaaaaaaab")
        End Sub
        
        Sub GoodRegexCaching()
            ' GOOD: Caching compiled regex objects
            Dim regexCache As New Dictionary(Of String, Regex)()
            
            For Each pattern In commonPatterns
                If Not regexCache.ContainsKey(pattern) Then
                    regexCache(pattern) = New Regex(pattern, RegexOptions.Compiled)
                End If
                
                Dim regex = regexCache(pattern) ' Use cached compiled regex
                ProcessWithRegex(regex, testData)
            Next
        End Sub
        
        Function GoodRegexWithTimeout() As Boolean
            ' GOOD: Using regex with timeout to prevent long-running operations
            Dim safeRegex As New Regex("a*a*a*b", RegexOptions.Compiled, TimeSpan.FromMilliseconds(100))
            
            Try
                Return safeRegex.IsMatch("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaac")
            Catch ex As RegexMatchTimeoutException
                ' Handle timeout gracefully
                Return False
            End Try
        End Function
        
        Sub GoodSimplifiedPatterns()
            ' GOOD: Simplified patterns that are easier to understand and faster
            Dim emailRegex As New Regex("\w+@\w+\.\w+", RegexOptions.Compiled) ' Simplified email pattern
            Dim phoneRegex As New Regex("\d{10}", RegexOptions.Compiled) ' Simplified phone pattern
            Dim ipRegex As New Regex("\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", RegexOptions.Compiled) ' Simplified IP pattern
            
            For Each email In emails
                If emailRegex.IsMatch(email) Then
                    ProcessValidEmail(email)
                End If
            Next
        End Sub
        
        Sub GoodRegexAlternatives()
            ' GOOD: Using string methods instead of regex when appropriate
            For Each email In emails
                ' Good: Simple validation without regex
                If email.Contains("@") AndAlso email.Contains(".") Then
                    ProcessValidEmail(email)
                End If
            Next
            
            For Each phone In phoneNumbers
                ' Good: Using string methods for simple patterns
                If phone.Length = 12 AndAlso phone(3) = "-"c AndAlso phone(7) = "-"c Then
                    ProcessPhone(phone)
                End If
            Next
        End Sub
        
        Sub GoodRegexOptions()
            ' GOOD: Using appropriate RegexOptions for performance
            Dim caseInsensitiveRegex As New Regex("test", RegexOptions.Compiled Or RegexOptions.IgnoreCase)
            Dim multilineRegex As New Regex("^line", RegexOptions.Compiled Or RegexOptions.Multiline)
            Dim singlelineRegex As New Regex("start.*end", RegexOptions.Compiled Or RegexOptions.Singleline)
            
            ' Use appropriate options for the context
            ProcessRegexResults(caseInsensitiveRegex, multilineRegex, singlelineRegex)
        End Sub
        
        Function GoodRegexValidation() As Boolean
            ' GOOD: Validating regex patterns before use
            Dim pattern = GetUserInputPattern()
            
            Try
                Dim testRegex As New Regex(pattern, RegexOptions.Compiled, TimeSpan.FromMilliseconds(500))
                ' Test with safe input first
                testRegex.IsMatch("test")
                Return True
            Catch ex As ArgumentException
                ' Invalid pattern
                Return False
            Catch ex As RegexMatchTimeoutException
                ' Pattern too slow
                Return False
            End Try
        End Function
        
        Sub GoodRegexReplacement()
            ' GOOD: Efficient regex replacement patterns
            Dim htmlTagRegex As New Regex("<[^>]+>", RegexOptions.Compiled)
            Dim whitespaceRegex As New Regex("\s+", RegexOptions.Compiled)
            
            For Each htmlText In htmlTexts
                ' Remove HTML tags efficiently
                Dim cleanText = htmlTagRegex.Replace(htmlText, "")
                ' Normalize whitespace efficiently
                cleanText = whitespaceRegex.Replace(cleanText, " ")
                ProcessCleanText(cleanText)
            Next
        End Sub
        
        ' Helper methods and fields
        Private emails(1000) As String
        Private phoneNumbers As New List(Of String)()
        Private passwords As New List(Of String)()
        Private textData As New List(Of String)()
        Private hasMoreData As Boolean = True
        Private testData As String = "test"
        Private commonPatterns As New List(Of String)()
        Private htmlTexts As New List(Of String)()
        
        Sub ProcessValidEmail(email As String)
        End Sub
        
        Function GetNextPhoneNumber() As String
            Return "555-123-4567"
        End Function
        
        Sub ProcessPhoneMatch(match As Match)
        End Sub
        
        Sub ProcessUrlMatches(matches As MatchCollection)
        End Sub
        
        Sub ProcessValidPassword(password As String)
        End Sub
        
        Sub ProcessWithRegex(regex As Regex, data As String)
        End Sub
        
        Sub ProcessPhone(phone As String)
        End Sub
        
        Sub ProcessRegexResults(regex1 As Regex, regex2 As Regex, regex3 As Regex)
        End Sub
        
        Function GetUserInputPattern() As String
            Return "test"
        End Function
        
        Sub ProcessCleanText(text As String)
        End Sub
    </script>
</body>
</html>
