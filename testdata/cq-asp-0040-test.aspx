<%@ Page Language="VB" %>
<html>
<head>
    <title>Improper Task Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Improper Task.Run usage for I/O-bound operations
        
        Sub BadTaskRunForIO()
            ' BAD: Using Task.Run for I/O operations (should use async I/O directly)
            Task.Run(Sub()
                         Dim content = File.ReadAllText("data.txt") ' I/O should be async
                         ProcessFileContent(content)
                     End Sub)
            
            Task.Run(Sub()
                         Using stream As New FileStream("output.dat", FileMode.Create)
                             Dim data As Byte() = GetDataBytes()
                             stream.Write(data, 0, data.Length) ' I/O should be async
                         End Using
                     End Sub)
            
            Task.Run(Sub()
                         Using connection As New SqlConnection(connectionString)
                             connection.Open() ' Database I/O should be async
                             Dim command As New SqlCommand("SELECT * FROM Users", connection)
                             Dim reader = command.ExecuteReader() ' Database I/O should be async
                             ProcessDatabaseResults(reader)
                         End Using
                     End Sub)
        End Sub
        
        Sub BadTaskRunForWebRequests()
            ' BAD: Using Task.Run for web requests (should use async HTTP directly)
            Task.Run(Sub()
                         Dim client As New HttpClient()
                         Dim response = client.GetStringAsync("https://api.example.com").Result ' Bad: blocking async
                         ProcessWebResponse(response)
                     End Sub)
            
            Task.Run(Sub()
                         Dim webClient As New WebClient()
                         Dim data = webClient.DownloadString("https://service.com/data") ' Should be async
                         ProcessDownloadedData(data)
                     End Sub)
        End Sub
        
        Async Function BadAsyncLoopWithCpuWork() As Task
            ' BAD: Using async/await for CPU-bound work in tight loops
            For i = 1 To 1000000
                Await Task.Run(Function()
                                   Return Math.Sqrt(i) ' CPU-bound work shouldn't be in Task.Run per iteration
                               End Function)
                
                Await Task.Run(Function()
                                   Return CalculateComplexMath(i) ' Inefficient for CPU work
                               End Function)
            Next
            
            While hasMoreWork
                Await Task.Run(Sub()
                                   ComputeHeavyCalculation() ' Should not wrap each calculation
                               End Sub)
            End While
        End Function
        
        Sub BadTaskRunWithAwaitInside()
            ' BAD: Using Task.Run with await inside (defeats the purpose)
            Task.Run(Async Function()
                         Await File.ReadAllTextAsync("config.xml") ' Should not wrap async I/O in Task.Run
                         Await ProcessConfigAsync()
                         Return "completed"
                     End Function)
            
            Task.Run(Async Sub()
                         Await DatabaseOperationAsync() ' Should not wrap async operations
                         Await AnotherAsyncOperationAsync()
                     End Sub)
        End Sub
        
        Function BadTaskRunWithoutConfigureAwait() As Task
            ' BAD: Task.Run with await but missing ConfigureAwait(false)
            Return Task.Run(Async Function()
                                Dim data = Await LoadDataAsync() ' Missing ConfigureAwait(false)
                                Await ProcessDataAsync(data) ' Missing ConfigureAwait(false)
                                Return "result"
                            End Function)
        End Function
        
        Sub BadMixedPatterns()
            ' BAD: Mixing sync and async patterns incorrectly
            Task.Run(Sub()
                         Dim result = SomeAsyncMethod().Result ' Bad: blocking on async
                         ProcessResult(result)
                     End Sub)
            
            Task.Run(Sub()
                         SomeAsyncMethod().Wait() ' Bad: blocking on async
                     End Sub)
        End Sub
        
        ' GOOD: Proper Task and async usage
        
        Async Function GoodAsyncIOOperations() As Task
            ' GOOD: Direct async I/O without Task.Run
            Dim content = Await File.ReadAllTextAsync("data.txt")
            ProcessFileContent(content)
            
            Using stream As New FileStream("output.dat", FileMode.Create)
                Dim data As Byte() = GetDataBytes()
                Await stream.WriteAsync(data, 0, data.Length)
            End Using
        End Function
        
        Async Function GoodAsyncDatabaseOperations() As Task
            ' GOOD: Direct async database operations
            Using connection As New SqlConnection(connectionString)
                Await connection.OpenAsync()
                Using command As New SqlCommand("SELECT * FROM Users", connection)
                    Using reader = Await command.ExecuteReaderAsync()
                        Await ProcessDatabaseResultsAsync(reader)
                    End Using
                End Using
            End Using
        End Function
        
        Async Function GoodAsyncWebRequests() As Task
            ' GOOD: Direct async web requests
            Using client As New HttpClient()
                Dim response = Await client.GetStringAsync("https://api.example.com")
                ProcessWebResponse(response)
            End Using
        End Function
        
        Function GoodTaskRunForCpuBound() As Task
            ' GOOD: Using Task.Run only for CPU-bound work
            Return Task.Run(Function()
                                Dim result = 0
                                For i = 1 To 1000000
                                    result += CalculateComplexMath(i) ' Pure CPU work
                                Next
                                Return result
                            End Function)
        End Function
        
        Async Function GoodCpuBoundBatchProcessing() As Task
            ' GOOD: Processing CPU-bound work in batches
            Dim items = Await GetItemsAsync()
            Dim batches = items.Batch(1000)
            
            For Each batch In batches
                Await Task.Run(Sub()
                                   ' Process batch of CPU-intensive items
                                   Parallel.ForEach(batch, Sub(item) ProcessCpuIntensiveItem(item))
                               End Sub)
            Next
        End Function
        
        Function GoodTaskRunWithConfigureAwait() As Task
            ' GOOD: Task.Run with proper ConfigureAwait when needed
            Return Task.Run(Async Function()
                                Dim data = Await LoadDataAsync().ConfigureAwait(False)
                                Await ProcessDataAsync(data).ConfigureAwait(False)
                                Return "result"
                            End Function)
        End Function
        
        Async Function GoodProperAsyncPattern() As Task
            ' GOOD: Proper async pattern without unnecessary Task.Run
            Dim data = Await LoadDataAsync()
            Dim processed = ProcessDataSync(data) ' Sync CPU work directly
            Await SaveDataAsync(processed)
        End Function
        
        Function GoodLongRunningCpuWork() As Task
            ' GOOD: Using LongRunning option for truly long-running CPU work
            Return Task.Factory.StartNew(Sub()
                                             For i = 1 To Integer.MaxValue
                                                 If cancellationToken.IsCancellationRequested Then
                                                     Exit For
                                                 End If
                                                 ProcessLongRunningCpuWork(i)
                                             Next
                                         End Sub, TaskCreationOptions.LongRunning)
        End Function
        
        Async Function GoodParallelAsyncProcessing() As Task
            ' GOOD: Parallel processing of async operations
            Dim urls = GetUrlsToProcess()
            Dim tasks = urls.Select(Function(url) ProcessUrlAsync(url))
            Await Task.WhenAll(tasks)
        End Function
        
        Function GoodCpuBoundWithCancellation() As Task
            ' GOOD: CPU-bound work with cancellation support
            Return Task.Run(Sub()
                                For i = 1 To 1000000
                                    If cancellationToken.IsCancellationRequested Then
                                        Exit For
                                    End If
                                    
                                    ProcessCpuIntensiveItem(i)
                                    
                                    ' Yield occasionally for cooperative cancellation
                                    If i Mod 1000 = 0 Then
                                        Thread.Yield()
                                    End If
                                Next
                            End Sub)
        End Function
        
        Async Function GoodStreamProcessing() As Task
            ' GOOD: Async stream processing without Task.Run
            Using fileStream As New FileStream("largefile.dat", FileMode.Open)
                Dim buffer(8192) As Byte
                Dim bytesRead As Integer
                
                Do
                    bytesRead = Await fileStream.ReadAsync(buffer, 0, buffer.Length)
                    If bytesRead > 0 Then
                        ProcessBufferSync(buffer, bytesRead) ' Sync processing of buffer
                    End If
                Loop While bytesRead > 0
            End Using
        End Function
        
        Function GoodBackgroundProcessing() As Task
            ' GOOD: Background processing with proper patterns
            Return Task.Run(Async Function()
                                While Not cancellationToken.IsCancellationRequested
                                    ' CPU-bound work
                                    ProcessBackgroundWork()
                                    
                                    ' Async delay (not blocking)
                                    Await Task.Delay(1000, cancellationToken)
                                End While
                            End Function)
        End Function
        
        ' Helper methods and fields
        Private connectionString As String = "Data Source=server;Initial Catalog=db;"
        Private hasMoreWork As Boolean = True
        Private cancellationToken As CancellationToken
        
        Sub ProcessFileContent(content As String)
        End Sub
        
        Function GetDataBytes() As Byte()
            Return New Byte() {}
        End Function
        
        Sub ProcessDatabaseResults(reader As SqlDataReader)
        End Sub
        
        Async Function ProcessDatabaseResultsAsync(reader As SqlDataReader) As Task
            Await Task.Delay(10)
        End Sub
        
        Sub ProcessWebResponse(response As String)
        End Sub
        
        Sub ProcessDownloadedData(data As String)
        End Sub
        
        Function CalculateComplexMath(i As Integer) As Integer
            Return i * i * i
        End Function
        
        Sub ComputeHeavyCalculation()
        End Sub
        
        Async Function ProcessConfigAsync() As Task
            Await Task.Delay(50)
        End Function
        
        Async Function DatabaseOperationAsync() As Task
            Await Task.Delay(100)
        End Function
        
        Async Function AnotherAsyncOperationAsync() As Task
            Await Task.Delay(75)
        End Function
        
        Async Function LoadDataAsync() As Task(Of String)
            Await Task.Delay(200)
            Return "data"
        End Function
        
        Async Function ProcessDataAsync(data As String) As Task
            Await Task.Delay(150)
        End Function
        
        Async Function SomeAsyncMethod() As Task(Of String)
            Await Task.Delay(100)
            Return "result"
        End Function
        
        Sub ProcessResult(result As String)
        End Sub
        
        Async Function GetItemsAsync() As Task(Of List(Of Integer))
            Await Task.Delay(50)
            Return Enumerable.Range(1, 10000).ToList()
        End Function
        
        Sub ProcessCpuIntensiveItem(item As Integer)
            ' CPU-intensive work
        End Sub
        
        Function ProcessDataSync(data As String) As String
            Return data.ToUpper()
        End Function
        
        Async Function SaveDataAsync(data As String) As Task
            Await Task.Delay(100)
        End Function
        
        Sub ProcessLongRunningCpuWork(i As Integer)
            ' Long-running CPU work
        End Sub
        
        Function GetUrlsToProcess() As List(Of String)
            Return New List(Of String) From {"https://api1.com", "https://api2.com", "https://api3.com"}
        End Function
        
        Async Function ProcessUrlAsync(url As String) As Task
            Using client As New HttpClient()
                Dim response = Await client.GetStringAsync(url)
                ProcessWebResponse(response)
            End Using
        End Function
        
        Sub ProcessBufferSync(buffer As Byte(), length As Integer)
            ' Synchronous buffer processing
        End Sub
        
        Sub ProcessBackgroundWork()
            ' Background CPU work
        End Sub
    </script>
</body>
</html>
