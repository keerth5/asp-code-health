<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Async/Await Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Blocking I/O operations without async/await
        Sub BadSyncIOMethod()
            ' File operations without async
            Dim content = File.ReadAllText("data.txt")
            File.WriteAllText("output.txt", content)
            
            Dim fileStream = File.Open("large_file.dat", FileMode.Open)
            Dim buffer(1024) As Byte
            fileStream.Read(buffer, 0, buffer.Length)
            fileStream.Close()
            
            Dim streamReader = New StreamReader("input.txt")
            Dim line = streamReader.ReadLine()
            streamReader.Close()
            
            Dim streamWriter = New StreamWriter("results.txt")
            streamWriter.Write("Processing complete")
            streamWriter.Close()
        End Sub
        
        Function BadSyncDatabaseFunction() As DataSet
            ' Database operations without async
            Dim connection = New SqlConnection(connectionString)
            connection.Open()
            
            Dim command = New SqlCommand("SELECT * FROM large_table", connection)
            Dim reader = command.ExecuteReader()
            
            Dim dataset = New DataSet()
            ' Process large dataset synchronously
            
            connection.Close()
            Return dataset
        End Function
        
        Sub BadSyncWebRequestMethod()
            ' Web requests without async
            Dim webClient = New WebClient()
            Dim response = webClient.DownloadString("https://api.example.com/data")
            
            Dim httpClient = New HttpClient()
            Dim result = httpClient.GetStringAsync("https://api.example.com/users").Result ' Blocking on async
            
            Dim webRequest = WebRequest.Create("https://service.example.com/api")
            Dim webResponse = webRequest.GetResponse()
        End Sub
        
        Function BadSyncQueryFunction() As String
            Dim databaseConnection = New SqlConnection(connectionString)
            databaseConnection.Open()
            
            Dim sqlQuery = New SqlCommand("EXEC long_running_procedure", databaseConnection)
            Dim queryResult = sqlQuery.ExecuteScalar()
            
            databaseConnection.Close()
            Return queryResult.ToString()
        End Function
        
        ' GOOD: Proper async/await usage
        Async Function GoodAsyncIOMethod() As Task
            ' File operations with async
            Dim content = Await File.ReadAllTextAsync("data.txt")
            Await File.WriteAllTextAsync("output.txt", content)
            
            Using fileStream = File.Open("large_file.dat", FileMode.Open)
                Dim buffer(1024) As Byte
                Await fileStream.ReadAsync(buffer, 0, buffer.Length)
            End Using
            
            Using streamReader = New StreamReader("input.txt")
                Dim line = Await streamReader.ReadLineAsync()
            End Using
            
            Using streamWriter = New StreamWriter("results.txt")
                Await streamWriter.WriteAsync("Processing complete")
            End Using
        End Function
        
        Async Function GoodAsyncDatabaseFunction() As Task(Of DataSet)
            ' Database operations with async
            Using connection = New SqlConnection(connectionString)
                Await connection.OpenAsync()
                
                Using command = New SqlCommand("SELECT * FROM large_table", connection)
                    Using reader = Await command.ExecuteReaderAsync()
                        Dim dataset = New DataSet()
                        ' Process dataset asynchronously
                        Return dataset
                    End Using
                End Using
            End Using
        End Function
        
        Async Function GoodAsyncWebRequestMethod() As Task
            ' Web requests with async
            Using httpClient = New HttpClient()
                Dim response = Await httpClient.GetStringAsync("https://api.example.com/data")
                Dim users = Await httpClient.GetStringAsync("https://api.example.com/users")
                ProcessWebData(response, users)
            End Using
            
            ' Alternative with WebClient
            Using webClient = New WebClient()
                Dim data = Await webClient.DownloadStringTaskAsync("https://service.example.com/api")
                ProcessApiData(data)
            End Using
        End Function
        
        Async Function GoodAsyncQueryFunction() As Task(Of String)
            Using databaseConnection = New SqlConnection(connectionString)
                Await databaseConnection.OpenAsync()
                
                Using sqlQuery = New SqlCommand("EXEC long_running_procedure", databaseConnection)
                    Dim queryResult = Await sqlQuery.ExecuteScalarAsync()
                    Return queryResult.ToString()
                End Using
            End Using
        End Function
        
        ' Good: Mixed sync and async patterns where appropriate
        Async Function GoodMixedAsyncMethod() As Task
            ' CPU-bound operations can remain synchronous
            Dim calculation = PerformComplexCalculation()
            
            ' I/O-bound operations should be async
            Dim data = Await LoadDataFromFileAsync()
            Dim result = Await ProcessDataAsync(data)
            
            ' More CPU-bound work
            Dim finalResult = TransformResult(result)
            
            ' Save result asynchronously
            Await SaveResultAsync(finalResult)
        End Function
        
        ' Good: Proper async event handlers
        Async Sub Page_LoadAsync(sender As Object, e As EventArgs)
            Await LoadUserDataAsync()
            Await LoadConfigurationAsync()
        End Sub
        
        Async Sub Button_ClickAsync(sender As Object, e As EventArgs)
            Try
                Await ProcessFormDataAsync()
                ShowSuccessMessage()
            Catch ex As Exception
                ShowErrorMessage(ex.Message)
            End Try
        End Sub
        
        ' Helper methods
        Function PerformComplexCalculation() As Integer
            Return 42
        End Function
        
        Async Function LoadDataFromFileAsync() As Task(Of String)
            Return Await File.ReadAllTextAsync("data.txt")
        End Function
        
        Async Function ProcessDataAsync(data As String) As Task(Of String)
            ' Simulate async processing
            Await Task.Delay(100)
            Return data.ToUpper()
        End Function
        
        Function TransformResult(result As String) As String
            Return result.Trim()
        End Function
        
        Async Function SaveResultAsync(result As String) As Task
            Await File.WriteAllTextAsync("result.txt", result)
        End Function
        
        Async Function LoadUserDataAsync() As Task
            ' Simulate loading user data
            Await Task.Delay(50)
        End Function
        
        Async Function LoadConfigurationAsync() As Task
            ' Simulate loading configuration
            Await Task.Delay(25)
        End Function
        
        Async Function ProcessFormDataAsync() As Task
            ' Simulate form processing
            Await Task.Delay(100)
        End Function
        
        Sub ShowSuccessMessage()
            Response.Write("Success!")
        End Sub
        
        Sub ShowErrorMessage(message As String)
            Response.Write("Error: " & message)
        End Sub
        
        Sub ProcessWebData(response As String, users As String)
        End Sub
        
        Sub ProcessApiData(data As String)
        End Sub
        
        ' Connection string property
        Private ReadOnly Property connectionString As String
            Get
                Return "Data Source=server;Initial Catalog=database;"
            End Get
        End Property
    </script>
</body>
</html>
