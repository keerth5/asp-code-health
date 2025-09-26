<%@ Page Language="VB" %>
<html>
<head>
    <title>Improper Exception Handling Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Catching general Exception type
        Sub BadExceptionHandlingMethod()
            Try
                Dim result = ProcessData()
            Catch ex As Exception ' Too general
                Response.Write("An error occurred")
            End Try
            
            Try
                Dim connection = New SqlConnection(connectionString)
                connection.Open()
            Catch ex As System.Exception ' Too general with System prefix
                LogError(ex.Message)
            End Try
        End Sub
        
        ' BAD: Using On Error Resume Next
        Sub BadVBErrorHandling()
            On Error Resume Next ' Suppresses all errors
            
            Dim file = System.IO.File.ReadAllText("nonexistent.txt")
            Dim number = CInt("invalid")
            Dim result = 10 / 0
        End Sub
        
        Function BadFunctionWithGeneralCatch() As String
            Try
                Return ProcessComplexOperation()
            Catch generalEx As Exception ' Bad practice
                Return "Error"
            End Try
        End Function
        
        ' GOOD: Catching specific exceptions
        Sub GoodExceptionHandlingMethod()
            Try
                Dim result = ProcessData()
            Catch ex As SqlException
                LogSqlError(ex)
            Catch ex As InvalidOperationException
                LogOperationError(ex)
            Catch ex As ArgumentException
                LogArgumentError(ex)
            End Try
            
            Try
                Dim connection = New SqlConnection(connectionString)
                connection.Open()
            Catch ex As SqlException
                HandleDatabaseError(ex)
            Catch ex As InvalidOperationException
                HandleConnectionError(ex)
            End Try
        End Sub
        
        Sub GoodSpecificErrorHandling()
            Try
                Dim file = System.IO.File.ReadAllText("data.txt")
            Catch ex As FileNotFoundException
                CreateDefaultFile()
            Catch ex As UnauthorizedAccessException
                RequestPermissions()
            Catch ex As IOException
                HandleIOError(ex)
            End Try
        End Sub
        
        Function GoodFunctionWithSpecificCatch() As String
            Try
                Return ProcessComplexOperation()
            Catch ex As TimeoutException
                Return HandleTimeout()
            Catch ex As NetworkException
                Return HandleNetworkError()
            End Try
        End Function
        
        ' Helper methods
        Sub LogSqlError(ex As SqlException)
        End Sub
        
        Sub LogOperationError(ex As InvalidOperationException)
        End Sub
        
        Sub LogArgumentError(ex As ArgumentException)
        End Sub
        
        Function ProcessData() As Object
            Return Nothing
        End Function
        
        Function ProcessComplexOperation() As String
            Return ""
        End Function
    </script>
</body>
</html>
