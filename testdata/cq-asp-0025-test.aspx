<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Null Checks Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing null checks
        Sub BadNullCheckMethod()
            Dim userName As String = Request.Form("username")
            Dim userLength = userName.Length ' No null check
            
            Dim userEmail = Session("email")
            Dim emailDomain = userEmail.Substring(userEmail.IndexOf("@")) ' No null check
            
            Dim productName = Request.QueryString("product")
            Dim productCode = productName.ToUpper().Substring(0, 3) ' No null check
            
            Dim items = GetItemList()
            Dim itemCount = items.Count() ' No null check
            
            Dim userData = Session("user")
            Dim userInfo = userData.ToString() ' No null check
            
            Dim searchTerm = Request.Form("search")
            Dim searchResults = searchTerm.IndexOf("keyword") ' No null check
        End Sub
        
        Function BadNullCheckFunction() As String
            Dim config = GetConfiguration()
            Return config.ConnectionString.ToLower() ' No null check
        End Function
        
        Sub BadRequestDataUsage()
            Dim categoryId = Request.QueryString("categoryId")
            Dim category = categoryId.ToString() ' No null check
            
            Dim userId = Request.Form("userId")
            Dim userProfile = userId.Substring(0, 5) ' No null check
        End Sub
        
        ' GOOD: Proper null checks
        Sub GoodNullCheckMethod()
            Dim userName As String = Request.Form("username")
            If userName IsNot Nothing AndAlso userName <> "" Then
                Dim userLength = userName.Length
            End If
            
            Dim userEmail = Session("email")
            If userEmail IsNot Nothing Then
                Dim emailStr = userEmail.ToString()
                If emailStr.IndexOf("@") > 0 Then
                    Dim emailDomain = emailStr.Substring(emailStr.IndexOf("@"))
                End If
            End If
            
            Dim productName = Request.QueryString("product")
            If productName IsNot Nothing AndAlso productName.Length >= 3 Then
                Dim productCode = productName.ToUpper().Substring(0, 3)
            End If
            
            Dim items = GetItemList()
            If items IsNot Nothing Then
                Dim itemCount = items.Count()
            End If
        End Sub
        
        Function GoodNullCheckFunction() As String
            Dim config = GetConfiguration()
            If config IsNot Nothing AndAlso config.ConnectionString IsNot Nothing Then
                Return config.ConnectionString.ToLower()
            End If
            Return String.Empty
        End Function
        
        Sub GoodRequestDataUsage()
            Dim categoryId = Request.QueryString("categoryId")
            If Not String.IsNullOrEmpty(categoryId) Then
                Dim category = categoryId.ToString()
            End If
            
            Dim userId = Request.Form("userId")
            If userId IsNot Nothing AndAlso userId.Length >= 5 Then
                Dim userProfile = userId.Substring(0, 5)
            End If
        End Sub
        
        ' Alternative good patterns using IsNull function
        Sub GoodWithIsNullFunction()
            Dim userData = Session("user")
            If Not IsNull(userData) Then
                Dim userInfo = userData.ToString()
            End If
            
            Dim searchTerm = Request.Form("search")
            If Not IsNull(searchTerm) AndAlso searchTerm <> "" Then
                Dim searchResults = searchTerm.IndexOf("keyword")
            End If
        End Sub
        
        ' Helper methods
        Function GetItemList() As Object
            Return Nothing
        End Function
        
        Function GetConfiguration() As Object
            Return Nothing
        End Function
    </script>
</body>
</html>
