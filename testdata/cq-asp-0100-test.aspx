<%@ Page Language="VB" %>
<html>
<head>
    <title>Database Connection Leaks Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Database connection leaks - database connections not properly closed or disposed
        
        ' BAD: Connection created but not disposed
        Sub BadConnectionWithoutDispose()
            ' BAD: New connection without using statement or dispose
            Dim connection As New SqlConnection(connectionString)
            connection.Open()
            
            Dim command As New SqlCommand("SELECT * FROM Users", connection)
            Dim reader = command.ExecuteReader()
            
            While reader.Read()
                ProcessUser(reader("Name").ToString())
            End While
            
            ' BAD: Connection not closed or disposed
        End Sub
        
        ' BAD: Connection opened but not closed in finally block
        Sub BadConnectionWithoutFinally()
            Dim connection As New SqlConnection(connectionString)
            
            Try
                ' BAD: Connection opened without proper cleanup
                connection.Open()
                
                Dim command As New SqlCommand("UPDATE Users SET LastLogin = GETDATE()", connection)
                command.ExecuteNonQuery()
                
            Catch ex As Exception
                ' Handle exception but connection not closed
                LogError(ex.Message)
            End Try
            
            ' BAD: Connection not disposed
        End Sub
        
        ' BAD: Multiple connections in loop without disposal
        Sub BadMultipleConnectionsInLoop()
            Dim userIds = GetUserIds()
            
            For Each userId In userIds
                ' BAD: New connection in loop without disposal
                Dim connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim command As New SqlCommand($"SELECT * FROM Users WHERE Id = {userId}", connection)
                Dim reader = command.ExecuteReader()
                
                If reader.Read() Then
                    ProcessUser(reader("Name").ToString())
                End If
                
                ' BAD: Connection not closed or disposed
            Next
        End Sub
        
        ' BAD: OleDbConnection without proper disposal
        Sub BadOleDbConnectionLeak()
            ' BAD: OleDbConnection without using statement
            Dim connection As New OleDbConnection(oleDbConnectionString)
            connection.Open()
            
            Dim command As New OleDbCommand("SELECT * FROM Products", connection)
            Dim adapter As New OleDbDataAdapter(command)
            Dim dataSet As New DataSet()
            
            adapter.Fill(dataSet)
            ProcessDataSet(dataSet)
            
            ' BAD: Connection not closed
        End Sub
        
        ' BAD: OdbcConnection without disposal
        Sub BadOdbcConnectionLeak()
            ' BAD: OdbcConnection created without using statement
            Dim connection As New OdbcConnection(odbcConnectionString)
            connection.Open()
            
            Dim command As New OdbcCommand("SELECT COUNT(*) FROM Orders", connection)
            Dim count = CInt(command.ExecuteScalar())
            
            ProcessOrderCount(count)
            
            ' BAD: Connection not disposed
        End Sub
        
        ' BAD: Connection in while loop without disposal
        Sub BadConnectionInWhileLoop()
            Dim hasMoreData As Boolean = True
            Dim offset As Integer = 0
            
            While hasMoreData
                ' BAD: New connection in each iteration
                Dim connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim command As New SqlCommand($"SELECT * FROM LargeTable ORDER BY Id OFFSET {offset} ROWS FETCH NEXT 100 ROWS ONLY", connection)
                Dim reader = command.ExecuteReader()
                
                Dim rowCount As Integer = 0
                While reader.Read()
                    ProcessLargeTableRow(reader)
                    rowCount += 1
                End While
                
                hasMoreData = rowCount = 100
                offset += 100
                
                ' BAD: Connection not disposed
            End While
        End Sub
        
        ' BAD: Connection created in foreach without disposal
        Sub BadConnectionInForeach()
            Dim queries = GetQueries()
            
            ' BAD: Connection created for each query without disposal
            For Each query In queries
                Dim connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim command As New SqlCommand(query, connection)
                command.ExecuteNonQuery()
                
                ' BAD: Connection not closed
            Next
        End Sub
        
        ' BAD: Connection with transaction but no proper cleanup
        Sub BadConnectionWithTransaction()
            Dim connection As New SqlConnection(connectionString)
            Dim transaction As SqlTransaction = Nothing
            
            Try
                ' BAD: Connection and transaction without using statement
                connection.Open()
                transaction = connection.BeginTransaction()
                
                Dim command1 As New SqlCommand("INSERT INTO Users (Name) VALUES ('User1')", connection, transaction)
                command1.ExecuteNonQuery()
                
                Dim command2 As New SqlCommand("INSERT INTO UserRoles (UserId, Role) VALUES (SCOPE_IDENTITY(), 'User')", connection, transaction)
                command2.ExecuteNonQuery()
                
                transaction.Commit()
                
            Catch ex As Exception
                transaction?.Rollback()
                Throw
            End Try
            
            ' BAD: Connection and transaction not disposed
        End Sub
        
        ' GOOD: Proper connection disposal using Using statements
        
        ' GOOD: Connection with using statement
        Sub GoodConnectionWithUsing()
            ' GOOD: Using statement ensures disposal
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Using command As New SqlCommand("SELECT * FROM Users", connection)
                    Using reader = command.ExecuteReader()
                        While reader.Read()
                            ProcessUser(reader("Name").ToString())
                        End While
                    End Using
                End Using
            End Using
        End Sub
        
        ' GOOD: Connection with try-finally for manual cleanup
        Sub GoodConnectionWithFinally()
            Dim connection As SqlConnection = Nothing
            
            Try
                connection = New SqlConnection(connectionString)
                connection.Open()
                
                Using command As New SqlCommand("UPDATE Users SET LastLogin = GETDATE()", connection)
                    command.ExecuteNonQuery()
                End Using
                
            Catch ex As Exception
                LogError(ex.Message)
                Throw
            Finally
                ' GOOD: Ensure connection is disposed
                connection?.Dispose()
            End Try
        End Sub
        
        ' GOOD: Reusing connection for multiple operations
        Sub GoodConnectionReuse()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' GOOD: Reuse same connection for multiple operations
                Dim userIds = GetUserIds()
                
                For Each userId In userIds
                    Using command As New SqlCommand($"SELECT * FROM Users WHERE Id = @userId", connection)
                        command.Parameters.AddWithValue("@userId", userId)
                        
                        Using reader = command.ExecuteReader()
                            If reader.Read() Then
                                ProcessUser(reader("Name").ToString())
                            End If
                        End Using
                    End Using
                Next
            End Using
        End Sub
        
        ' GOOD: OleDbConnection with proper disposal
        Sub GoodOleDbConnection()
            ' GOOD: Using statement for OleDbConnection
            Using connection As New OleDbConnection(oleDbConnectionString)
                connection.Open()
                
                Using command As New OleDbCommand("SELECT * FROM Products", connection)
                    Using adapter As New OleDbDataAdapter(command)
                        Dim dataSet As New DataSet()
                        adapter.Fill(dataSet)
                        ProcessDataSet(dataSet)
                    End Using
                End Using
            End Using
        End Sub
        
        ' GOOD: OdbcConnection with proper disposal
        Sub GoodOdbcConnection()
            ' GOOD: Using statement for OdbcConnection
            Using connection As New OdbcConnection(odbcConnectionString)
                connection.Open()
                
                Using command As New OdbcCommand("SELECT COUNT(*) FROM Orders", connection)
                    Dim count = CInt(command.ExecuteScalar())
                    ProcessOrderCount(count)
                End Using
            End Using
        End Sub
        
        ' GOOD: Connection pooling with proper disposal
        Sub GoodConnectionPooling()
            ' GOOD: Connection pooling with using statements
            Dim queries = GetQueries()
            
            For Each query In queries
                Using connection As New SqlConnection(connectionString)
                    connection.Open()
                    
                    Using command As New SqlCommand(query, connection)
                        command.ExecuteNonQuery()
                    End Using
                End Using ' Connection returned to pool
            Next
        End Sub
        
        ' GOOD: Async operations with proper disposal
        Async Function GoodAsyncConnectionUsage() As Task
            ' GOOD: Using statement with async operations
            Using connection As New SqlConnection(connectionString)
                Await connection.OpenAsync()
                
                Using command As New SqlCommand("SELECT * FROM Users", connection)
                    Using reader = Await command.ExecuteReaderAsync()
                        While Await reader.ReadAsync()
                            ProcessUser(reader("Name").ToString())
                        End While
                    End Using
                End Using
            End Using
        End Function
        
        ' GOOD: Transaction with proper disposal
        Sub GoodTransactionUsage()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' GOOD: Using statement for transaction
                Using transaction = connection.BeginTransaction()
                    Try
                        Using command1 As New SqlCommand("INSERT INTO Users (Name) VALUES (@name)", connection, transaction)
                            command1.Parameters.AddWithValue("@name", "User1")
                            command1.ExecuteNonQuery()
                        End Using
                        
                        Using command2 As New SqlCommand("INSERT INTO UserRoles (UserId, Role) VALUES (SCOPE_IDENTITY(), @role)", connection, transaction)
                            command2.Parameters.AddWithValue("@role", "User")
                            command2.ExecuteNonQuery()
                        End Using
                        
                        transaction.Commit()
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub
        
        ' GOOD: Connection factory pattern
        Class GoodConnectionFactory
            Private ReadOnly connectionString As String
            
            Public Sub New(connString As String)
                connectionString = connString
            End Sub
            
            Public Function CreateConnection() As SqlConnection
                Return New SqlConnection(connectionString)
            End Function
            
            Public Sub ExecuteNonQuery(sql As String, ParamArray parameters() As SqlParameter)
                Using connection = CreateConnection()
                    connection.Open()
                    
                    Using command As New SqlCommand(sql, connection)
                        If parameters IsNot Nothing Then
                            command.Parameters.AddRange(parameters)
                        End If
                        command.ExecuteNonQuery()
                    End Using
                End Using
            End Sub
            
            Public Function ExecuteScalar(sql As String, ParamArray parameters() As SqlParameter) As Object
                Using connection = CreateConnection()
                    connection.Open()
                    
                    Using command As New SqlCommand(sql, connection)
                        If parameters IsNot Nothing Then
                            command.Parameters.AddRange(parameters)
                        End If
                        Return command.ExecuteScalar()
                    End Using
                End Using
            End Function
        End Class
        
        ' GOOD: Data access layer with proper connection management
        Class GoodDataAccessLayer
            Private ReadOnly connectionString As String
            
            Public Sub New(connString As String)
                connectionString = connString
            End Sub
            
            Public Function GetUsers() As List(Of User)
                Dim users As New List(Of User)()
                
                Using connection As New SqlConnection(connectionString)
                    connection.Open()
                    
                    Using command As New SqlCommand("SELECT Id, Name, Email FROM Users", connection)
                        Using reader = command.ExecuteReader()
                            While reader.Read()
                                users.Add(New User() With {
                                    .Id = CInt(reader("Id")),
                                    .Name = reader("Name").ToString(),
                                    .Email = reader("Email").ToString()
                                })
                            End While
                        End Using
                    End Using
                End Using
                
                Return users
            End Function
            
            Public Sub UpdateUser(user As User)
                Using connection As New SqlConnection(connectionString)
                    connection.Open()
                    
                    Using command As New SqlCommand("UPDATE Users SET Name = @name, Email = @email WHERE Id = @id", connection)
                        command.Parameters.AddWithValue("@name", user.Name)
                        command.Parameters.AddWithValue("@email", user.Email)
                        command.Parameters.AddWithValue("@id", user.Id)
                        command.ExecuteNonQuery()
                    End Using
                End Using
            End Sub
        End Class
        
        ' GOOD: Repository pattern with connection management
        Class GoodUserRepository
            Private ReadOnly connectionFactory As GoodConnectionFactory
            
            Public Sub New(factory As GoodConnectionFactory)
                connectionFactory = factory
            End Sub
            
            Public Function GetById(userId As Integer) As User
                Using connection = connectionFactory.CreateConnection()
                    connection.Open()
                    
                    Using command As New SqlCommand("SELECT Id, Name, Email FROM Users WHERE Id = @id", connection)
                        command.Parameters.AddWithValue("@id", userId)
                        
                        Using reader = command.ExecuteReader()
                            If reader.Read() Then
                                Return New User() With {
                                    .Id = CInt(reader("Id")),
                                    .Name = reader("Name").ToString(),
                                    .Email = reader("Email").ToString()
                                }
                            End If
                        End Using
                    End Using
                End Using
                
                Return Nothing
            End Function
            
            Public Sub Save(user As User)
                If user.Id = 0 Then
                    InsertUser(user)
                Else
                    UpdateUser(user)
                End If
            End Sub
            
            Private Sub InsertUser(user As User)
                connectionFactory.ExecuteNonQuery(
                    "INSERT INTO Users (Name, Email) VALUES (@name, @email)",
                    New SqlParameter("@name", user.Name),
                    New SqlParameter("@email", user.Email)
                )
            End Sub
            
            Private Sub UpdateUser(user As User)
                connectionFactory.ExecuteNonQuery(
                    "UPDATE Users SET Name = @name, Email = @email WHERE Id = @id",
                    New SqlParameter("@name", user.Name),
                    New SqlParameter("@email", user.Email),
                    New SqlParameter("@id", user.Id)
                )
            End Sub
        End Class
        
        ' Supporting classes
        Class SqlConnection
            Implements IDisposable
            
            Public Sub New(connectionString As String)
            End Sub
            
            Public Sub Open()
            End Sub
            
            Public Async Function OpenAsync() As Task
            End Function
            
            Public Function BeginTransaction() As SqlTransaction
                Return New SqlTransaction()
            End Function
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlCommand
            Implements IDisposable
            
            Public Property Parameters As SqlParameterCollection
            
            Public Sub New()
                Parameters = New SqlParameterCollection()
            End Sub
            
            Public Sub New(sql As String, connection As SqlConnection)
                Me.New()
            End Sub
            
            Public Sub New(sql As String, connection As SqlConnection, transaction As SqlTransaction)
                Me.New()
            End Sub
            
            Public Function ExecuteReader() As SqlDataReader
                Return New SqlDataReader()
            End Function
            
            Public Async Function ExecuteReaderAsync() As Task(Of SqlDataReader)
                Return New SqlDataReader()
            End Function
            
            Public Function ExecuteNonQuery() As Integer
                Return 1
            End Function
            
            Public Function ExecuteScalar() As Object
                Return 42
            End Function
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlDataReader
            Implements IDisposable
            
            Public Function Read() As Boolean
                Return False
            End Function
            
            Public Async Function ReadAsync() As Task(Of Boolean)
                Return False
            End Function
            
            Default Public ReadOnly Property Item(columnName As String) As Object
                Get
                    Return "Value"
                End Get
            End Property
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlTransaction
            Implements IDisposable
            
            Public Sub Commit()
            End Sub
            
            Public Sub Rollback()
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlParameter
            Public Sub New(parameterName As String, value As Object)
            End Sub
        End Class
        
        Class SqlParameterCollection
            Public Sub AddWithValue(parameterName As String, value As Object)
            End Sub
            
            Public Sub AddRange(parameters() As SqlParameter)
            End Sub
        End Class
        
        Class OleDbConnection
            Implements IDisposable
            
            Public Sub New(connectionString As String)
            End Sub
            
            Public Sub Open()
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class OleDbCommand
            Implements IDisposable
            
            Public Sub New(sql As String, connection As OleDbConnection)
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class OleDbDataAdapter
            Implements IDisposable
            
            Public Sub New(command As OleDbCommand)
            End Sub
            
            Public Sub Fill(dataSet As DataSet)
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class OdbcConnection
            Implements IDisposable
            
            Public Sub New(connectionString As String)
            End Sub
            
            Public Sub Open()
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class OdbcCommand
            Implements IDisposable
            
            Public Sub New(sql As String, connection As OdbcConnection)
            End Sub
            
            Public Function ExecuteScalar() As Object
                Return 10
            End Function
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class DataSet
        End Class
        
        Class User
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
        End Class
        
        ' Helper methods and properties
        Private ReadOnly connectionString As String = "Server=localhost;Database=TestDB;Integrated Security=true;"
        Private ReadOnly oleDbConnectionString As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=test.mdb;"
        Private ReadOnly odbcConnectionString As String = "DSN=TestDSN;UID=user;PWD=password;"
        
        Sub ProcessUser(userName As String)
        End Sub
        
        Sub LogError(message As String)
        End Sub
        
        Function GetUserIds() As List(Of Integer)
            Return New List(Of Integer) From {1, 2, 3, 4, 5}
        End Function
        
        Sub ProcessDataSet(dataSet As DataSet)
        End Sub
        
        Sub ProcessOrderCount(count As Integer)
        End Sub
        
        Sub ProcessLargeTableRow(reader As SqlDataReader)
        End Sub
        
        Function GetQueries() As List(Of String)
            Return New List(Of String) From {
                "UPDATE Table1 SET Status = 'Processed'",
                "UPDATE Table2 SET LastUpdate = GETDATE()",
                "DELETE FROM TempTable WHERE Created < DATEADD(day, -1, GETDATE())"
            }
        End Function
    </script>
</body>
</html>
