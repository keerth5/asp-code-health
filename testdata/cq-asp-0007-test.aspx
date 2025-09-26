<%@ Page Language="VB" %>
<html>
<head>
    <title>Long Parameter Lists Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Methods with too many parameters (more than 5)
        Sub BadLongParameterMethod(param1 As String, param2 As Integer, param3 As Boolean, param4 As Double, param5 As Date, param6 As Object)
            Response.Write("Too many parameters")
        End Sub
        
        Function BadLongParameterFunction(name As String, age As Integer, email As String, phone As String, address As String, city As String, state As String) As String
            Return name & age.ToString() & email
        End Function
        
        Sub AnotherBadMethod(userId As Integer, userName As String, userEmail As String, userPhone As String, userAddress As String, userCity As String, userState As String, userZip As String)
            ' Process user data
            Response.Write("Processing user: " & userName)
        End Sub
        
        Function ProcessOrder(orderId As Integer, customerId As Integer, productId As Integer, quantity As Integer, price As Double, discount As Double, tax As Double, shipping As Double, total As Double) As Boolean
            ' Process order with too many parameters
            Return True
        End Function
        
        ' GOOD: Methods with reasonable parameter counts (4 or fewer)
        Sub GoodShortParameterMethod(param1 As String, param2 As Integer)
            Response.Write("Good parameter count")
        End Sub
        
        Function GoodShortParameterFunction(name As String, age As Integer, email As String) As String
            Return name & " - " & age.ToString()
        End Function
        
        Sub ProcessUser(userId As Integer, userData As Object)
            ' Good: Using object to group related parameters
            Response.Write("Processing user ID: " & userId)
        End Sub
        
        Function CalculateTotal(price As Double, tax As Double, shipping As Double) As Double
            Return price + tax + shipping
        End Function
        
        ' Edge case: exactly 5 parameters (borderline)
        Sub BorderlineMethod(param1 As String, param2 As Integer, param3 As Boolean, param4 As Double, param5 As Date)
            Response.Write("Borderline parameter count")
        End Sub
    </script>
</body>
</html>
