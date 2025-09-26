<%@ Page Language="VB" %>
<html>
<head>
    <title>Duplicate Code Blocks Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Duplicate code blocks with similar patterns
        Sub BadDuplicateMethod1()
            If Request.Form("username") <> "" Then
                Response.Write("Username: " & Request.Form("username"))
                Server.MapPath("~/data/users.txt")
            End If
            
            ' Duplicate similar block
            If Request.Form("email") <> "" Then
                Response.Write("Email: " & Request.Form("email"))
                Server.MapPath("~/data/emails.txt")
            End If
        End Sub
        
        Sub BadDuplicateMethod2()
            For i As Integer = 1 To 10
                Response.Write("Processing item " & i)
                Server.MapPath("~/temp/item" & i & ".txt")
                Request.Form("item" & i)
            Next
            
            ' Another duplicate pattern
            For j As Integer = 1 To 5
                Response.Write("Processing data " & j)
                Server.MapPath("~/temp/data" & j & ".txt")
                Request.Form("data" & j)
            Next
        End Sub
        
        Function BadDuplicateFunction()
            Dim user As String
            Dim email As String
            Dim phone As String
            
            ' Multiple variable declarations - duplicate pattern
            Set user = Request.Form("user")
            Set email = Request.Form("email")
            Set phone = Request.Form("phone")
            
            Return user & email & phone
        End Function
        
        Sub AnotherBadMethod()
            While Request.Form("continue") = "true"
                Response.Write("Continuing process...")
                Server.MapPath("~/logs/process.log")
                Request.Form("step")
            End While
            
            ' Duplicate while pattern
            While Request.Form("active") = "true"
                Response.Write("Active process...")
                Server.MapPath("~/logs/active.log")
                Request.Form("status")
            End While
        End Sub
        
        ' GOOD: Non-duplicate, unique code blocks
        Sub GoodUniqueMethod()
            If Request.Form("username") <> "" Then
                Dim user As String = Request.Form("username")
                Response.Write("Welcome " & user)
            End If
        End Sub
        
        Function GoodUniqueFunction() As String
            Dim result As String = ""
            For i As Integer = 1 To 5
                result += "Item " & i & vbCrLf
            Next
            Return result
        End Function
    </script>
</body>
</html>
