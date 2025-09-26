<%@ Page Language="VB" %>
<html>
<head>
    <title>Inappropriate Var Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inappropriate var usage where type is not obvious
        Sub BadVarUsageMethod()
            var connection = New SqlConnection() ' Type not obvious from context
            var command = New SqlCommand() ' Type not obvious from context
            var userData = Request.Form("user") ' Type not obvious from context
            var sessionData = Session("data") ' Type not obvious from context
            var serverInfo = Server.MapPath("~/") ' Type not obvious from context
            
            var userName = "admin" ' Type obvious but var still inappropriate for simple types
            var userId = 12345 ' Type obvious but var still inappropriate for simple types
            var isActive = True ' Type obvious but var still inappropriate for simple types
            
            var config = GetConfiguration() ' Return type not obvious
            var result = ProcessData() ' Return type not obvious
            var items = GetItemList() ' Return type not obvious
        End Sub
        
        Function BadVarFunction() As Object
            var query = "SELECT * FROM users" ' Type obvious but var inappropriate
            var timeout = 30000 ' Type obvious but var inappropriate
            var retryCount = 3 ' Type obvious but var inappropriate
            
            var dbConnection = CreateConnection() ' Return type not clear
            var queryResult = ExecuteQuery(query) ' Return type not clear
            
            Return queryResult
        End Function
        
        Sub BadVarInLoop()
            For Each var item In GetItems() ' Type not obvious
                var itemName = item.Name ' Type not obvious from context
                var itemValue = item.GetValue() ' Return type not clear
                ProcessItem(item)
            Next
            
            For var i = 0 To 10 ' Type obvious but var inappropriate
                var currentValue = i * 2 ' Type obvious but var inappropriate
            Next
        End Sub
        
        ' GOOD: Explicit type usage
        Sub GoodExplicitTypeMethod()
            Dim connection As SqlConnection = New SqlConnection()
            Dim command As SqlCommand = New SqlCommand()
            Dim userData As String = Request.Form("user")
            Dim sessionData As Object = Session("data")
            Dim serverInfo As String = Server.MapPath("~/")
            
            Dim userName As String = "admin"
            Dim userId As Integer = 12345
            Dim isActive As Boolean = True
            
            Dim config As Configuration = GetConfiguration()
            Dim result As ProcessingResult = ProcessData()
            Dim items As List(Of Item) = GetItemList()
        End Sub
        
        Function GoodExplicitTypeFunction() As Object
            Dim query As String = "SELECT * FROM users"
            Dim timeout As Integer = 30000
            Dim retryCount As Integer = 3
            
            Dim dbConnection As IDbConnection = CreateConnection()
            Dim queryResult As DataSet = ExecuteQuery(query)
            
            Return queryResult
        End Function
        
        Sub GoodExplicitTypeInLoop()
            For Each item As Item In GetItems()
                Dim itemName As String = item.Name
                Dim itemValue As Object = item.GetValue()
                ProcessItem(item)
            Next
            
            For i As Integer = 0 To 10
                Dim currentValue As Integer = i * 2
            Next
        End Sub
        
        ' GOOD: Appropriate var usage (when type is obvious from context)
        Sub GoodVarUsageMethod()
            ' These would be acceptable var usage in C# where type is obvious
            ' But in VB.NET, explicit typing is preferred
            
            ' VB.NET equivalent with type inference (still explicit)
            Dim users = New List(Of User)() ' Type is obvious from constructor
            Dim dictionary = New Dictionary(Of String, Integer)() ' Type is obvious
            
            ' Complex generic types where var might be appropriate in C#
            Dim complexQuery = From u In users 
                              Where u.IsActive 
                              Select New With {u.Name, u.Email} ' Anonymous type - type inference acceptable
        End Sub
        
        ' Edge cases and borderline scenarios
        Sub EdgeCaseVarUsage()
            ' These are borderline cases where explicit typing is still preferred
            var httpContext = HttpContext.Current ' Type somewhat obvious but explicit is better
            var requestUrl = Request.Url ' Type somewhat obvious but explicit is better
            var responseOutput = Response.Output ' Type not immediately obvious
            
            ' Better explicit versions
            Dim httpContextExplicit As HttpContext = HttpContext.Current
            Dim requestUrlExplicit As Uri = Request.Url
            Dim responseOutputExplicit As TextWriter = Response.Output
        End Sub
        
        ' Helper methods and classes
        Function GetConfiguration() As Configuration
            Return New Configuration()
        End Function
        
        Function ProcessData() As ProcessingResult
            Return New ProcessingResult()
        End Function
        
        Function GetItemList() As List(Of Item)
            Return New List(Of Item)()
        End Function
        
        Function CreateConnection() As IDbConnection
            Return New SqlConnection()
        End Function
        
        Function ExecuteQuery(query As String) As DataSet
            Return New DataSet()
        End Function
        
        Function GetItems() As List(Of Item)
            Return New List(Of Item)()
        End Function
        
        Sub ProcessItem(item As Item)
        End Sub
        
        ' Sample classes
        Public Class Configuration
            Public Property ConnectionString As String
        End Class
        
        Public Class ProcessingResult
            Public Property Success As Boolean
            Public Property Message As String
        End Class
        
        Public Class Item
            Public Property Name As String
            
            Public Function GetValue() As Object
                Return Nothing
            End Function
        End Class
        
        Public Class User
            Public Property Name As String
            Public Property Email As String
            Public Property IsActive As Boolean
        End Class
    </script>
</body>
</html>
