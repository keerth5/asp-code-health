<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing XML Documentation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Public class without XML documentation
        Public Class BadUndocumentedClass
            Public Sub BadUndocumentedMethod()
                Response.Write("No documentation")
            End Sub
            
            Public Function BadUndocumentedFunction() As String
                Return "No documentation"
            End Function
        End Class
        
        ' BAD: Another undocumented public class
        Partial Class AnotherBadClass
            Public Sub AnotherBadMethod()
                Response.Write("Missing docs")
            End Sub
        End Class
        
        ' GOOD: Class with XML documentation comments
        ''' <summary>
        ''' This is a well-documented class
        ''' </summary>
        Public Class GoodDocumentedClass
            ''' <summary>
            ''' This method has proper documentation
            ''' </summary>
            Public Sub GoodDocumentedMethod()
                Response.Write("Well documented")
            End Sub
            
            ''' <summary>
            ''' This function returns a documented result
            ''' </summary>
            ''' <returns>A string value</returns>
            Public Function GoodDocumentedFunction() As String
                Return "Well documented"
            End Function
        End Class
        
        ' GOOD: Class with HTML-style documentation
        <!-- <summary>This class uses HTML-style documentation</summary> -->
        Public Class HtmlDocumentedClass
            <!-- <summary>This method is documented with HTML comments</summary> -->
            Public Sub HtmlDocumentedMethod()
                Response.Write("HTML documented")
            End Sub
        End Class
        
        ' BAD: More undocumented public members
        Public Class YetAnotherBadClass
            Public Sub UndocumentedMethod1()
            End Sub
            
            Public Function UndocumentedFunction1() As Integer
                Return 0
            End Function
            
            Public Sub UndocumentedMethod2()
            End Sub
        End Class
        
        ' GOOD: Private/internal classes don't need documentation (per rule scope)
        Private Class PrivateClass
            Sub PrivateMethod()
            End Sub
        End Class
        
        Class InternalClass
            Sub InternalMethod()
            End Sub
        End Class
    </script>
</body>
</html>
