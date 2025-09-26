<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Input Validation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing input validation
        Sub BadInputValidationMethod()
            Dim userId = Request.Form("userId") ' No validation
            Dim userName = Request.QueryString("name") ' No validation
            Dim email = Request.Params("email") ' No validation
            
            ' Direct use in SQL - SQL injection risk
            Dim sql = "SELECT * FROM users WHERE id = " & Request.Form("id")
            Dim query = "DELETE FROM products WHERE name = '" & Request.QueryString("product") & "'"
            
            ' Direct output without encoding - XSS risk
            Response.Write("Hello " & Request.Form("username"))
            Response.Write("Search results for: " & Request.QueryString("search"))
            
            ' No validation on form data
            Dim age = Request.Form("age")
            Dim birthDate = Request.Form("birthdate")
            Dim phoneNumber = Request.QueryString("phone")
        End Sub
        
        Function BadSqlQueryFunction() As String
            Dim category = Request.QueryString("category")
            Return "SELECT * FROM products WHERE category = '" & category & "'" ' SQL injection risk
        End Function
        
        Sub BadDirectOutputMethod()
            Dim comment = Request.Form("comment")
            Response.Write("<div>" & comment & "</div>") ' XSS risk
            
            Dim message = Request.QueryString("msg")
            Response.Write(message) ' No HTML encoding
        End Sub
        
        ' GOOD: Proper input validation
        Sub GoodInputValidationMethod()
            Dim userId = Request.Form("userId")
            If ValidateUserId(userId) Then
                ProcessUser(userId)
            End If
            
            Dim userName = Request.QueryString("name")
            If SanitizeInput(userName) AndAlso userName.Length <= 50 Then
                ProcessUserName(userName)
            End If
            
            Dim email = Request.Params("email")
            If ValidateEmail(email) Then
                ProcessEmail(email)
            End If
            
            ' Parameterized queries
            Dim sql = "SELECT * FROM users WHERE id = @userId"
            Dim cmd As New SqlCommand(sql, connection)
            cmd.Parameters.AddWithValue("@userId", ValidateUserId(Request.Form("id")))
            
            ' HTML encoded output
            Dim searchTerm = Request.QueryString("search")
            If ValidateSearchTerm(searchTerm) Then
                Response.Write("Search results for: " & HttpUtility.HtmlEncode(searchTerm))
            End If
            
            ' Validated form data
            Dim age = Request.Form("age")
            If IsNumeric(age) AndAlso CInt(age) >= 0 AndAlso CInt(age) <= 150 Then
                ProcessAge(CInt(age))
            End If
            
            Dim birthDate = Request.Form("birthdate")
            If IsDate(birthDate) Then
                ProcessBirthDate(CDate(birthDate))
            End If
        End Sub
        
        Function GoodSqlQueryFunction() As String
            Dim category = Request.QueryString("category")
            If ValidateCategory(category) Then
                Return "SELECT * FROM products WHERE category = @category"
            End If
            Return String.Empty
        End Function
        
        Sub GoodDirectOutputMethod()
            Dim comment = Request.Form("comment")
            If ValidateComment(comment) Then
                Response.Write("<div>" & HttpUtility.HtmlEncode(comment) & "</div>")
            End If
            
            Dim message = Request.QueryString("msg")
            If ValidateMessage(message) Then
                Response.Write(Server.HtmlEncode(message))
            End If
            
            ' URL encoding for URLs
            Dim redirectUrl = Request.QueryString("returnUrl")
            If ValidateUrl(redirectUrl) Then
                Response.Redirect(HttpUtility.UrlEncode(redirectUrl))
            End If
        End Sub
        
        ' Validation helper methods
        Function ValidateUserId(userId As String) As Boolean
            Return Not String.IsNullOrEmpty(userId) AndAlso IsNumeric(userId)
        End Function
        
        Function SanitizeInput(input As String) As Boolean
            Return Not String.IsNullOrEmpty(input) AndAlso Not input.Contains("<script>")
        End Function
        
        Function ValidateEmail(email As String) As Boolean
            Return Not String.IsNullOrEmpty(email) AndAlso email.Contains("@") AndAlso email.Length <= 100
        End Function
        
        Function ValidateSearchTerm(term As String) As Boolean
            Return Not String.IsNullOrEmpty(term) AndAlso term.Length <= 200
        End Function
        
        Function ValidateCategory(category As String) As Boolean
            Return Not String.IsNullOrEmpty(category) AndAlso category.Length <= 50
        End Function
        
        Function ValidateComment(comment As String) As Boolean
            Return Not String.IsNullOrEmpty(comment) AndAlso comment.Length <= 1000
        End Function
        
        Function ValidateMessage(message As String) As Boolean
            Return Not String.IsNullOrEmpty(message) AndAlso message.Length <= 500
        End Function
        
        Function ValidateUrl(url As String) As Boolean
            Return Not String.IsNullOrEmpty(url) AndAlso url.StartsWith("http")
        End Function
        
        ' Processing methods
        Sub ProcessUser(userId As String)
        End Sub
        
        Sub ProcessUserName(userName As String)
        End Sub
        
        Sub ProcessEmail(email As String)
        End Sub
        
        Sub ProcessAge(age As Integer)
        End Sub
        
        Sub ProcessBirthDate(birthDate As Date)
        End Sub
    </script>
</body>
</html>
