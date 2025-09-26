<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Blank Lines Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing blank lines between methods
        Sub FirstMethod()
            Response.Write("First")
        End Sub
        Sub SecondMethod()
            Response.Write("Second")
        End Sub
        
        Function FirstFunction() As String
            Return "First"
        End Function
        Function SecondFunction() As String
            Return "Second"
        End Function
        
        ' BAD: Missing blank lines between control structures
        Sub MethodWithMissingBlankLines()
            If True Then
                Response.Write("If block")
            End If
            While counter < 10
                counter = counter + 1
            End While
            
            For i = 1 To 5
                Response.Write(i)
            Next
            If False Then
                Response.Write("Another if")
            End If
        End Sub
        
        ' BAD: Missing blank lines between classes and methods
        Class FirstClass
            Sub Method1()
            End Sub
        End Class
        Class SecondClass
            Sub Method2()
            End Sub
        End Class
        Sub MethodAfterClass()
        End Sub
        
        ' GOOD: Proper blank lines between methods
        Sub GoodFirstMethod()
            Response.Write("Good first")
        End Sub
        
        Sub GoodSecondMethod()
            Response.Write("Good second")
        End Sub
        
        Function GoodFirstFunction() As String
            Return "Good first"
        End Function
        
        Function GoodSecondFunction() As String
            Return "Good second"
        End Function
        
        ' GOOD: Proper blank lines in method body
        Sub GoodMethodWithBlankLines()
            If True Then
                Response.Write("If block")
            End If
            
            While counter < 10
                counter = counter + 1
            End While
            
            For i = 1 To 5
                Response.Write(i)
            Next
            
            If False Then
                Response.Write("Another if")
            End If
        End Sub
        
        ' GOOD: Proper blank lines between classes
        Class GoodFirstClass
            Sub Method1()
            End Sub
        End Class
        
        Class GoodSecondClass
            Sub Method2()
            End Sub
        End Class
        
        Sub GoodMethodAfterClass()
        End Sub
    </script>
</body>
</html>
