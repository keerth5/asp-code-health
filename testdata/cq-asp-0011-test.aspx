<%@ Page Language="VB" %>
<html>
<head>
    <title>Inconsistent Naming Conventions Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inconsistent naming conventions
        Dim badVariableName As String ' Mixed case inconsistently
        Private another_badName As Integer ' Underscore + camelCase
        Public BadName_withUnderscore As Boolean ' Mixed styles
        Dim mixedCase123Name As String ' Numbers mixed with case
        Private AnotherBadNamingStyle As Double ' Inconsistent PascalCase
        
        ' BAD: Inconsistent method names
        Sub badMethodName() ' Should be PascalCase
        End Sub
        
        Function another_badMethod() As String ' Underscore style
            Return ""
        End Function
        
        Sub MixedCase_MethodName() ' Mixed styles
        End Sub
        
        Function inconsistent123Method() As Integer ' Numbers mixed with case
            Return 0
        End Function
        
        ' GOOD: Consistent naming conventions
        Dim GoodVariableName As String ' PascalCase
        Private AnotherGoodName As Integer ' PascalCase
        Public ConsistentNaming As Boolean ' PascalCase
        
        Sub GoodMethodName() ' PascalCase
        End Sub
        
        Function AnotherGoodMethod() As String ' PascalCase
            Return ""
        End Function
        
        Function ConsistentMethodName() As Integer ' PascalCase
            Return 0
        End Function
        
        ' Edge cases
        Dim Name As String ' Simple PascalCase - Good
        Private value As String ' Simple lowercase - could be bad depending on convention
    </script>
</body>
</html>
