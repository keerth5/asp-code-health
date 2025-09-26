<%@ Page Language="VB" %>
<html>
<head>
    <title>Inconsistent Access Modifiers Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing access modifiers
        Sub MethodWithoutModifier()
            Response.Write("No access modifier")
        End Sub
        
        Function FunctionWithoutModifier() As String
            Return "No access modifier"
        End Function
        
        Property PropertyWithoutModifier As String
        
        Class ClassWithoutModifier
            Sub InnerMethod()
            End Sub
        End Class
        
        Structure StructureWithoutModifier
            Dim Field As String
        End Structure
        
        ' BAD: Inconsistent modifier ordering
        Shared Public Sub BadOrderMethod()
            Response.Write("Bad order")
        End Sub
        
        Static Private Function BadOrderFunction() As String
            Return "Bad order"
        End Function
        
        Shared Protected Property BadOrderProperty As String
        
        ' BAD: More missing modifiers
        Sub AnotherMethodWithoutModifier()
        End Sub
        
        Function AnotherFunctionWithoutModifier() As Integer
            Return 0
        End Function
        
        Property AnotherPropertyWithoutModifier As Boolean
        
        ' GOOD: Explicit access modifiers
        Public Sub PublicMethod()
            Response.Write("Public method")
        End Sub
        
        Private Function PrivateFunction() As String
            Return "Private function"
        End Function
        
        Protected Property ProtectedProperty As String
        
        Friend Sub FriendMethod()
            Response.Write("Friend method")
        End Sub
        
        Public Class PublicClass
            Private Sub PrivateInnerMethod()
            End Sub
            
            Public Function PublicInnerFunction() As String
                Return "Public inner"
            End Function
        End Class
        
        Private Structure PrivateStructure
            Public Field As String
        End Structure
        
        ' GOOD: Consistent modifier ordering
        Public Shared Sub GoodOrderMethod()
            Response.Write("Good order")
        End Sub
        
        Private Static Function GoodOrderFunction() As String
            Return "Good order"
        End Function
        
        Protected Shared Property GoodOrderProperty As String
    </script>
</body>
</html>
