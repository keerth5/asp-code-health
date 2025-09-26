<%@ Page Language="VB" %>
<html>
<head>
    <title>Inefficient Database Queries Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inefficient database queries - N+1 problems and inefficient patterns
        
        Sub BadN1QueryPattern()
            Dim users As List(Of User) = GetUsers()
            
            ' BAD: N+1 query pattern - executing query inside loop
            For Each user In users
                Dim connection As New SqlConnection(connectionString)
                Dim command As New SqlCommand("SELECT * FROM Orders WHERE UserId = " & user.Id, connection)
                connection.Open()
                Dim reader = command.ExecuteReader() ' N+1 query problem
                ProcessUserOrders(reader)
                connection.Close()
            Next
            
            ' BAD: Another N+1 pattern with foreach
            For Each customer In customers
                Dim sqlQuery = "SELECT COUNT(*) FROM Orders WHERE CustomerId = " & customer.Id
                Dim orderCount = ExecuteScalar(sqlQuery) ' N+1 query problem
                customer.OrderCount = CInt(orderCount)
            Next
        End Sub
        
        Sub BadQueryInLoop()
            ' BAD: Creating and executing commands in loops
            While hasMoreData
                Dim cmd As New SqlCommand("SELECT * FROM Products WHERE CategoryId = " & categoryId, connection)
                Dim result = cmd.ExecuteScalar() ' Bad: query execution in loop
                ProcessResult(result)
            End While
            
            For i = 1 To 100
                Dim oleDbCmd As New OleDbCommand("SELECT Name FROM Users WHERE Id = " & i, oleDbConnection)
                Dim userName = oleDbCmd.ExecuteScalar() ' Bad: query execution in loop
                ProcessUserName(CStr(userName))
            Next
        End Sub
        
        Function BadSelectStarQueries() As DataTable
            ' BAD: SELECT * without WHERE clause
            Dim query1 = "SELECT * FROM Users" ' Bad: no filtering
            Dim query2 = "SELECT * FROM Orders" ' Bad: no filtering
            Dim query3 = "SELECT * FROM Products" ' Bad: no filtering
            
            Return ExecuteQuery(query1)
        End Function
        
        Sub BadUnfilteredQueries()
            ' BAD: More SELECT * patterns without proper filtering
            Dim allUsers = "SELECT * FROM Users" ' Should have WHERE clause
            Dim allOrders = "SELECT * FROM Orders" ' Should have WHERE clause
            Dim allProducts = "SELECT * FROM Products" ' Should have WHERE clause
            
            ExecuteNonQuery(allUsers)
        End Sub
        
        ' GOOD: Efficient database query patterns
        
        Sub GoodEfficientQueryPattern()
            ' GOOD: Single query to get all data
            Dim query = "SELECT u.Id, u.Name, o.OrderId, o.Total " &
                       "FROM Users u LEFT JOIN Orders o ON u.Id = o.UserId " &
                       "WHERE u.IsActive = 1"
            
            Dim result = ExecuteQuery(query)
            ProcessUsersWithOrders(result)
        End Sub
        
        Sub GoodBatchQueries()
            ' GOOD: Batch queries instead of individual queries
            Dim userIds = String.Join(",", users.Select(Function(u) u.Id.ToString()))
            Dim batchQuery = $"SELECT * FROM Orders WHERE UserId IN ({userIds})"
            
            Dim orders = ExecuteQuery(batchQuery)
            ProcessOrdersBatch(orders)
        End Sub
        
        Function GoodFilteredQueries() As DataTable
            ' GOOD: Proper filtering and limiting
            Dim query1 = "SELECT Id, Name, Email FROM Users WHERE IsActive = 1 AND CreatedDate > @date"
            Dim query2 = "SELECT TOP 100 * FROM Orders WHERE OrderDate >= @startDate"
            Dim query3 = "SELECT ProductId, Name, Price FROM Products WHERE CategoryId = @categoryId LIMIT 50"
            
            Return ExecuteQuery(query1)
        End Function
        
        Sub GoodParameterizedQueries()
            ' GOOD: Using parameterized queries
            Dim cmd As New SqlCommand("SELECT * FROM Users WHERE Id = @userId AND Status = @status", connection)
            cmd.Parameters.AddWithValue("@userId", userId)
            cmd.Parameters.AddWithValue("@status", "Active")
            
            Dim reader = cmd.ExecuteReader()
            ProcessResults(reader)
        End Sub
        
        Sub GoodStoredProcedures()
            ' GOOD: Using stored procedures for complex operations
            Dim cmd As New SqlCommand("sp_GetUserOrderSummary", connection)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UserId", userId)
            
            Dim result = cmd.ExecuteScalar()
            ProcessSummary(result)
        End Sub
        
        Sub GoodCachedQueries()
            ' GOOD: Caching frequently accessed data
            Dim cacheKey = $"user_orders_{userId}"
            Dim cachedOrders = Cache(cacheKey)
            
            If cachedOrders Is Nothing Then
                cachedOrders = ExecuteQuery("SELECT * FROM Orders WHERE UserId = @userId")
                Cache.Insert(cacheKey, cachedOrders, Nothing, DateTime.Now.AddMinutes(30), TimeSpan.Zero)
            End If
            
            ProcessOrders(cachedOrders)
        End Sub
        
        Async Function GoodAsyncQueries() As Task
            ' GOOD: Using async operations for database calls
            Dim query = "SELECT COUNT(*) FROM Orders WHERE CustomerId = @customerId"
            Using cmd As New SqlCommand(query, connection)
                cmd.Parameters.AddWithValue("@customerId", customerId)
                Await connection.OpenAsync()
                Dim count = Await cmd.ExecuteScalarAsync()
                ProcessCount(CInt(count))
            End Using
        End Function
        
        ' Helper methods and fields
        Private connectionString As String = "Data Source=server;Initial Catalog=db;"
        Private connection As New SqlConnection(connectionString)
        Private oleDbConnection As New OleDbConnection()
        Private users As New List(Of User)()
        Private customers As New List(Of Customer)()
        Private hasMoreData As Boolean = True
        Private categoryId As Integer = 1
        Private userId As Integer = 1
        Private customerId As Integer = 1
        
        Function GetUsers() As List(Of User)
            Return New List(Of User)()
        End Function
        
        Sub ProcessUserOrders(reader As SqlDataReader)
        End Sub
        
        Function ExecuteScalar(query As String) As Object
            Return Nothing
        End Function
        
        Sub ProcessResult(result As Object)
        End Sub
        
        Sub ProcessUserName(userName As String)
        End Sub
        
        Function ExecuteQuery(query As String) As DataTable
            Return New DataTable()
        End Function
        
        Sub ExecuteNonQuery(query As String)
        End Sub
        
        Sub ProcessUsersWithOrders(result As DataTable)
        End Sub
        
        Sub ProcessOrdersBatch(orders As DataTable)
        End Sub
        
        Sub ProcessResults(reader As SqlDataReader)
        End Sub
        
        Sub ProcessSummary(result As Object)
        End Sub
        
        Sub ProcessOrders(orders As Object)
        End Sub
        
        Sub ProcessCount(count As Integer)
        End Sub
        
        ' Helper classes
        Public Class User
            Public Property Id As Integer
            Public Property Name As String
            Public Property OrderCount As Integer
        End Class
        
        Public Class Customer
            Public Property Id As Integer
            Public Property Name As String
            Public Property OrderCount As Integer
        End Class
    </script>
</body>
</html>
