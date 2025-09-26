<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Final Newline Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: This file will end without a final newline
        ' The rule should detect files that don't end with \r\n or \n
        
        Sub TestMethod()
            Response.Write("This file ends without a newline")
        End Sub
        
        Function GetMessage() As String
            Return "No final newline at end of file"
        End Function
        
        ' This file intentionally ends without a newline character
        ' to test the missing final newline detection rule
    </script>
</body>
</html>
