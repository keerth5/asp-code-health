<%@ Page Language="VB" %>
<html>
<head>
    <title>Thread Pool Starvation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Thread pool starvation - blocking thread pool with long operations
        
        Sub BadLongRunningTaskRun()
            ' BAD: Using Task.Run for long-running operations that block
            Task.Run(Sub()
                         Thread.Sleep(10000) ' 10 seconds - starves thread pool
                     End Sub)
            
            Task.Run(Sub()
                         Thread.Sleep(60000) ' 1 minute - very bad for thread pool
                     End Sub)
            
            Task.Run(Function()
                         Thread.Sleep(30000) ' 30 seconds - blocks thread
                         Return 42
                     End Function)
        End Sub
        
        Async Function BadAsyncWithLongSleep() As Task
            ' BAD: Long sleep in async method
            Await Task.Run(Sub()
                               For i = 1 To 100
                                   Thread.Sleep(1000) ' 100 seconds total
                               Next
                           End Sub)
        End Function
        
        Sub BadTaskRunWithBlockingIO()
            ' BAD: Using Task.Run for I/O operations (should use async I/O)
            Task.Run(Sub()
                         Dim content = File.ReadAllText("largefile.txt") ' Blocking I/O
                         ProcessContent(content)
                     End Sub)
            
            Task.Run(Sub()
                         Using stream As New FileStream("data.dat", FileMode.Open)
                             Dim buffer(1024) As Byte
                             stream.Read(buffer, 0, buffer.Length) ' Blocking I/O
                         End Using
                     End Sub)
            
            Task.Run(Sub()
                         Using connection As New SqlConnection(connectionString)
                             connection.Open() ' Blocking database operation
                             Dim command As New SqlCommand("SELECT * FROM LargeTable", connection)
                             Dim reader = command.ExecuteReader() ' Blocking query
                             ProcessResults(reader)
                         End Using
                     End Sub)
        End Sub
        
        Async Function BadAsyncLoopWithSleep() As Task
            ' BAD: Long-running loop with sleep in async method
            While isRunning
                Await Task.Delay(5000) ' Long delays in loop
                ProcessBatch()
            End While
            
            For i = 1 To 1000
                Thread.Sleep(100) ' Blocking sleep in loop
                ProcessItem(i)
            Next
        End Function
        
        Sub BadTaskRunWithDatabaseOperations()
            ' BAD: Database operations in Task.Run
            Task.Run(Sub()
                         Dim connection As New SqlConnection(connectionString)
                         connection.Open() ' Should be async
                         Dim command As New SqlCommand("EXEC LongRunningProcedure", connection)
                         command.ExecuteNonQuery() ' Should be async
                         connection.Close()
                     End Sub)
        End Sub
        
        Sub BadTaskRunWithWebRequests()
            ' BAD: Web requests in Task.Run
            Task.Run(Sub()
                         Dim client As New WebClient()
                         Dim result = client.DownloadString("https://api.slow-service.com") ' Should be async
                         ProcessWebResult(result)
                     End Sub)
        End Sub
        
        Async Function BadMixedAsyncAndBlocking() As Task
            ' BAD: Mixing async and blocking operations
            Await Task.Run(Sub()
                               ' This blocks a thread pool thread unnecessarily
                               Thread.Sleep(5000)
                               
                               ' I/O that should be async
                               Dim data = File.ReadAllText("config.xml")
                               ProcessConfig(data)
                           End Sub)
        End Function
        
        ' GOOD: Proper async patterns that don't starve thread pool
        
        Async Function GoodAsyncIOOperations() As Task
            ' GOOD: Using async I/O operations
            Dim content = Await File.ReadAllTextAsync("largefile.txt")
            ProcessContent(content)
            
            Using stream As New FileStream("data.dat", FileMode.Open)
                Dim buffer(1024) As Byte
                Await stream.ReadAsync(buffer, 0, buffer.Length)
                ProcessBuffer(buffer)
            End Using
        End Function
        
        Async Function GoodAsyncDatabaseOperations() As Task
            ' GOOD: Using async database operations
            Using connection As New SqlConnection(connectionString)
                Await connection.OpenAsync()
                Using command As New SqlCommand("SELECT * FROM LargeTable", connection)
                    Using reader = Await command.ExecuteReaderAsync()
                        Await ProcessResultsAsync(reader)
                    End Using
                End Using
            End Using
        End Function
        
        Async Function GoodAsyncWebRequests() As Task
            ' GOOD: Using async web requests
            Using client As New HttpClient()
                Dim result = Await client.GetStringAsync("https://api.slow-service.com")
                ProcessWebResult(result)
            End Using
        End Function
        
        Async Function GoodAsyncLoopWithDelay() As Task
            ' GOOD: Using Task.Delay instead of Thread.Sleep
            While isRunning
                Await Task.Delay(1000) ' Non-blocking delay
                ProcessBatch()
            End While
        End Function
        
        Function GoodTaskRunForCpuBound() As Task
            ' GOOD: Using Task.Run only for CPU-bound work
            Return Task.Run(Function()
                                ' CPU-intensive calculation
                                Dim result = 0
                                For i = 1 To 1000000
                                    result += CalculateComplexMath(i)
                                Next
                                Return result
                            End Function)
        End Function
        
        Async Function GoodProperAsyncPattern() As Task
            ' GOOD: Proper async pattern without blocking
            Dim data = Await LoadDataAsync()
            Dim processed = Await ProcessDataAsync(data)
            Await SaveDataAsync(processed)
        End Function
        
        Function GoodBackgroundTaskWithCancellation() As Task
            ' GOOD: Background task with cancellation support
            Dim cts As New CancellationTokenSource()
            
            Return Task.Run(Async Function()
                                While Not cts.Token.IsCancellationRequested
                                    ' CPU-bound work
                                    ProcessCpuIntensiveWork()
                                    
                                    ' Yield periodically
                                    Await Task.Yield()
                                End While
                            End Function, cts.Token)
        End Function
        
        Async Function GoodTimerBasedProcessing() As Task
            ' GOOD: Using Timer instead of long-running Task.Run
            Using timer As New Timer(Sub(state) ProcessPeriodicWork(), Nothing, TimeSpan.Zero, TimeSpan.FromMinutes(5))
                ' Let timer handle periodic work
                Await SomeOtherWorkAsync()
            End Using
        End Function
        
        Function GoodDedicatedThread() As Task
            ' GOOD: Using dedicated thread for truly long-running work
            Return Task.Factory.StartNew(Sub()
                                             While isRunning
                                                 ProcessLongRunningWork()
                                                 Thread.Sleep(1000) ' OK in dedicated thread
                                             End While
                                         End Sub, TaskCreationOptions.LongRunning)
        End Function
        
        Async Function GoodAsyncEnumerable() As IAsyncEnumerable(Of String)
            ' GOOD: Using async enumerable for streaming data
            For i = 1 To 1000
                Dim data = Await LoadItemAsync(i)
                Yield data
            Next
        End Function
        
        Async Function GoodBatchProcessing() As Task
            ' GOOD: Processing in batches to avoid long-running operations
            Dim items = Await GetItemsToProcessAsync()
            Dim batches = items.Batch(100) ' Process 100 items at a time
            
            For Each batch In batches
                Await ProcessBatchAsync(batch)
                Await Task.Yield() ' Yield control periodically
            Next
        End Function
        
        Function GoodParallelProcessing() As Task
            ' GOOD: Using Parallel.ForEach for CPU-bound parallel work
            Return Task.Run(Sub()
                                Dim items = GetCpuIntensiveItems()
                                Parallel.ForEach(items, Sub(item) ProcessCpuIntensiveItem(item))
                            End Sub)
        End Function
        
        ' Helper methods and fields
        Private isRunning As Boolean = True
        Private connectionString As String = "Data Source=server;Initial Catalog=db;"
        
        Sub ProcessContent(content As String)
        End Sub
        
        Sub ProcessBuffer(buffer As Byte())
        End Sub
        
        Async Function ProcessResultsAsync(reader As SqlDataReader) As Task
            Await Task.Delay(10)
        End Function
        
        Sub ProcessResults(reader As SqlDataReader)
        End Sub
        
        Sub ProcessWebResult(result As String)
        End Sub
        
        Sub ProcessBatch()
        End Sub
        
        Sub ProcessItem(i As Integer)
        End Sub
        
        Sub ProcessConfig(data As String)
        End Sub
        
        Async Function LoadDataAsync() As Task(Of String)
            Return Await Task.FromResult("data")
        End Function
        
        Async Function ProcessDataAsync(data As String) As Task(Of String)
            Await Task.Delay(100)
            Return data.ToUpper()
        End Function
        
        Async Function SaveDataAsync(data As String) As Task
            Await Task.Delay(50)
        End Function
        
        Function CalculateComplexMath(i As Integer) As Integer
            Return i * i
        End Function
        
        Sub ProcessCpuIntensiveWork()
        End Sub
        
        Sub ProcessPeriodicWork()
        End Sub
        
        Sub ProcessLongRunningWork()
        End Sub
        
        Async Function LoadItemAsync(i As Integer) As Task(Of String)
            Await Task.Delay(10)
            Return $"Item {i}"
        End Function
        
        Async Function GetItemsToProcessAsync() As Task(Of List(Of String))
            Await Task.Delay(100)
            Return New List(Of String)()
        End Function
        
        Async Function ProcessBatchAsync(batch As IEnumerable(Of String)) As Task
            Await Task.Delay(50)
        End Function
        
        Function GetCpuIntensiveItems() As List(Of Integer)
            Return Enumerable.Range(1, 1000).ToList()
        End Function
        
        Sub ProcessCpuIntensiveItem(item As Integer)
            ' CPU-intensive work
        End Sub
        
        Async Function SomeOtherWorkAsync() As Task
            Await Task.Delay(1000)
        End Function
    </script>
</body>
</html>
