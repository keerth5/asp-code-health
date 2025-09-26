<%@ Page Language="VB" %>
<html>
<head>
    <title>Inconsistent Brace Style Test</title>
</head>
<body>
    <script runat="server">
        ' Note: VB.NET doesn't use braces like C#, but this tests brace-style patterns
        ' BAD: Inconsistent brace placement (if this were C# style)
        Sub BadBraceMethod()
        { ' Brace on new line
            Response.Write("Bad style")
        }
        
        Function BadBraceFunction()
        { ' Brace on new line inconsistent with other methods
            Return "Bad"
        }
        
        Class BadBraceClass
        { ' Brace on new line
            Sub Method1() {
                ' Mixed styles within same class
            }
            
            Sub Method2()
            {
                ' Different style
            }
        }
        
        ' BAD: More inconsistent patterns
        Sub AnotherBadMethod()
        {
            If True Then
            {
                Response.Write("Mixed brace styles")
            }
        }
        
        ' GOOD: Consistent VB.NET style (no braces)
        Sub GoodVBMethod()
            Response.Write("Good VB.NET style")
        End Sub
        
        Function GoodVBFunction() As String
            Return "Good"
        End Function
        
        Class GoodVBClass
            Sub Method1()
                ' Consistent VB.NET style
            End Sub
            
            Sub Method2()
                ' Same consistent style
            End Sub
        End Class
        
        ' GOOD: If using C# style, be consistent
        Sub ConsistentCSharpStyleMethod() {
            Response.Write("Consistent")
        }
        
        Function ConsistentCSharpStyleFunction() As String {
            Return "Consistent"
        }
    </script>
</body>
</html>
