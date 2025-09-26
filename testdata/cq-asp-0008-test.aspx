<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="UnusedNamespace" %>
<html>
<head>
    <title>Unused Code Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Unused variables
        Dim unusedVariable As String
        Private unusedPrivateVar As Integer
        Public unusedPublicVar As Boolean
        
        ' BAD: Unused methods
        Sub UnusedMethod()
            Response.Write("This method is never called")
        End Sub
        
        Function UnusedFunction() As String
            Return "This function is never used"
        End Function
        
        Private Sub UnusedPrivateMethod()
            ' This method is never called
        End Sub
        
        ' GOOD: Used variables and methods
        Dim usedVariable As String = "Hello"
        Private usedPrivateVar As Integer = 42
        
        Sub UsedMethod()
            Response.Write(usedVariable)
            Response.Write(usedPrivateVar.ToString())
            CallAnotherUsedMethod()
        End Sub
        
        Function UsedFunction() As String
            Return "This function is used"
        End Function
        
        Sub CallAnotherUsedMethod()
            Dim result As String = UsedFunction()
            Response.Write(result)
        End Sub
        
        Sub Page_Load()
            UsedMethod()
        End Sub
        
        ' More unused code examples
        Dim anotherUnusedVar As Double
        Public unusedCounter As Long
        Private unusedFlag As Boolean
        
        Function AnotherUnusedFunction() As Integer
            Return 0
        End Function
        
        Sub OneMoreUnusedMethod()
            Dim localUnused As String = "local"
        End Sub
    </script>
</body>
</html>
