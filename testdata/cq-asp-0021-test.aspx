<%@ Page Language="VB" %>
<html>
<head>
    <title>Magic Number Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Magic numbers usage
        Sub BadMagicNumberMethod()
            If age > 65 Then ' Magic number 65
                Response.Write("Senior citizen")
            End If
            
            While counter < 100 Then ' Magic number 100
                counter = counter + 1
            End While
            
            For i = 1 To 50 ' Magic number 50
                Response.Write(i)
            Next
            
            Dim timeout As Integer = 5000 ' Magic number 5000
            Dim maxRetries As Integer = 3 ' Magic number 3
            Dim percentage As Double = 0.15 ' Magic number 0.15
            
            If score >= 85.5 Then ' Magic number 85.5
                Response.Write("Excellent")
            End If
            
            If price = 99.99 Then ' Magic number 99.99
                Response.Write("Special price")
            End If
            
            Dim buffer(255) As Byte ' Magic number 255
            Dim maxLength As Integer = 1024 ' Magic number 1024
        End Sub
        
        ' GOOD: Using named constants
        Const RETIREMENT_AGE As Integer = 65
        Const MAX_ITERATIONS As Integer = 100
        Const DEFAULT_TIMEOUT As Integer = 5000
        Const PASSING_SCORE As Double = 85.5
        
        Sub GoodNamedConstantsMethod()
            If age > RETIREMENT_AGE Then
                Response.Write("Senior citizen")
            End If
            
            While counter < MAX_ITERATIONS
                counter = counter + 1
            End While
            
            Dim timeout As Integer = DEFAULT_TIMEOUT
            
            If score >= PASSING_SCORE Then
                Response.Write("Excellent")
            End If
            
            ' Acceptable numbers: 0, 1, and simple calculations
            If count = 0 Then
                Response.Write("Empty")
            End If
            
            If isFirst = 1 Then
                Response.Write("First item")
            End If
        End Sub
    </script>
</body>
</html>
