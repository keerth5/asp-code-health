<%@ Page Language="VB" %>
<html>
<head>
    <title>Task Cancellation Not Supported Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Task cancellation not supported - long-running async operations without cancellation token support
        
        ' BAD: Async methods without cancellation token
        Async Function BadProcessLargeDataSet() As Task(Of String)
            ' BAD: No cancellation token parameter
            Dim data As New List(Of String)()
            
            For i As Integer = 0 To 10000
                Await Task.Delay(10) ' BAD: No cancellation token
                data.Add($"Item {i}")
            Next
            
            Return String.Join(",", data)
        End Function
        
        ' BAD: Long-running loop without cancellation support
        Async Function BadProcessFiles() As Task
            ' BAD: No cancellation token
            Dim files = Directory.GetFiles("C:\Data")
            
            For Each file In files
                ' BAD: Long operation without cancellation check
                Await ProcessFile(file)
                Await Task.Delay(1000) ' BAD: No cancellation token
            Next
        End Function
        
        ' BAD: Task.Run without cancellation token
        Function BadStartBackgroundTask() As Task(Of Integer)
            ' BAD: Task.Run without cancellation token
            Return Task.Run(Function()
                Dim result As Integer = 0
                For i As Integer = 0 To 1000000
                    result += i
                    Thread.Sleep(1) ' Simulate work
                Next
                Return result
            End Function)
        End Function
        
        ' BAD: Task.Factory.StartNew without cancellation
        Function BadStartFactoryTask() As Task
            ' BAD: Task.Factory.StartNew without cancellation token
            Return Task.Factory.StartNew(Sub()
                For i As Integer = 0 To 100000
                    ' Simulate heavy work
                    PerformCalculation(i)
                Next
            End Sub)
        End Function
        
        ' BAD: Foreach loop with async operations without cancellation
        Async Function BadProcessItemsInLoop() As Task
            Dim items = GetItems()
            
            ' BAD: Long-running foreach without cancellation support
            For Each item In items
                Await ProcessItemAsync(item) ' BAD: No cancellation token
                Await Task.Delay(500) ' BAD: No cancellation token
            Next
        End Function
        
        ' BAD: While loop with async operations without cancellation
        Async Function BadProcessWhileCondition() As Task
            ' BAD: While loop without cancellation check
            While HasMoreWork()
                Await DoWorkAsync() ' BAD: No cancellation token
                Await Task.Delay(1000) ' BAD: No cancellation token
            End While
        End Function
        
        ' BAD: HTTP client operations without cancellation
        Async Function BadMakeHttpRequests() As Task(Of String)
            Dim client As New HttpClient()
            Dim urls = GetUrls()
            Dim results As New StringBuilder()
            
            ' BAD: HTTP requests without cancellation token
            For Each url In urls
                Dim response = Await client.GetStringAsync(url) ' BAD: No cancellation token
                results.AppendLine(response)
                Await Task.Delay(2000) ' BAD: No cancellation token
            Next
            
            Return results.ToString()
        End Function
        
        ' BAD: Database operations without cancellation
        Async Function BadProcessDatabaseRecords() As Task
            Using connection As New SqlConnection(connectionString)
                Await connection.OpenAsync() ' BAD: No cancellation token
                
                Dim command As New SqlCommand("SELECT * FROM LargeTable", connection)
                Using reader = Await command.ExecuteReaderAsync() ' BAD: No cancellation token
                    ' BAD: Long-running read without cancellation
                    While Await reader.ReadAsync() ' BAD: No cancellation token
                        ProcessRecord(reader)
                        Await Task.Delay(100) ' BAD: No cancellation token
                    End While
                End Using
            End Using
        End Function
        
        ' BAD: File operations without cancellation
        Async Function BadProcessLargeFile() As Task(Of String)
            ' BAD: File operations without cancellation token
            Using stream As New FileStream("largefile.txt", FileMode.Open)
                Using reader As New StreamReader(stream)
                    Dim content As New StringBuilder()
                    Dim line As String
                    
                    ' BAD: Reading large file without cancellation support
                    line = Await reader.ReadLineAsync() ' BAD: No cancellation token
                    While line IsNot Nothing
                        content.AppendLine(line.ToUpper())
                        Await Task.Delay(10) ' BAD: No cancellation token
                        line = Await reader.ReadLineAsync() ' BAD: No cancellation token
                    End While
                    
                    Return content.ToString()
                End Using
            End Using
        End Function
        
        ' GOOD: Async methods with proper cancellation token support
        
        ' GOOD: Async method with cancellation token parameter
        Async Function GoodProcessLargeDataSet(cancellationToken As CancellationToken) As Task(Of String)
            ' GOOD: Cancellation token parameter provided
            Dim data As New List(Of String)()
            
            For i As Integer = 0 To 10000
                ' GOOD: Check for cancellation
                cancellationToken.ThrowIfCancellationRequested()
                
                ' GOOD: Pass cancellation token to Task.Delay
                Await Task.Delay(10, cancellationToken)
                data.Add($"Item {i}")
            Next
            
            Return String.Join(",", data)
        End Function
        
        ' GOOD: Long-running loop with cancellation support
        Async Function GoodProcessFiles(cancellationToken As CancellationToken) As Task
            Dim files = Directory.GetFiles("C:\Data")
            
            For Each file In files
                ' GOOD: Check for cancellation before processing each file
                cancellationToken.ThrowIfCancellationRequested()
                
                Await ProcessFileAsync(file, cancellationToken)
                
                ' GOOD: Pass cancellation token to delay
                Await Task.Delay(1000, cancellationToken)
            Next
        End Function
        
        ' GOOD: Task.Run with cancellation token
        Function GoodStartBackgroundTask(cancellationToken As CancellationToken) As Task(Of Integer)
            ' GOOD: Task.Run with cancellation token
            Return Task.Run(Function()
                Dim result As Integer = 0
                For i As Integer = 0 To 1000000
                    ' GOOD: Check for cancellation in loop
                    If cancellationToken.IsCancellationRequested Then
                        cancellationToken.ThrowIfCancellationRequested()
                    End If
                    
                    result += i
                    Thread.Sleep(1) ' Simulate work
                Next
                Return result
            End Function, cancellationToken)
        End Function
        
        ' GOOD: Task.Factory.StartNew with cancellation
        Function GoodStartFactoryTask(cancellationToken As CancellationToken) As Task
            ' GOOD: Task.Factory.StartNew with cancellation token
            Return Task.Factory.StartNew(Sub()
                For i As Integer = 0 To 100000
                    ' GOOD: Check for cancellation
                    cancellationToken.ThrowIfCancellationRequested()
                    PerformCalculation(i)
                Next
            End Sub, cancellationToken)
        End Function
        
        ' GOOD: Foreach loop with cancellation support
        Async Function GoodProcessItemsInLoop(cancellationToken As CancellationToken) As Task
            Dim items = GetItems()
            
            For Each item In items
                ' GOOD: Check for cancellation
                cancellationToken.ThrowIfCancellationRequested()
                
                Await ProcessItemAsync(item, cancellationToken)
                
                ' GOOD: Pass cancellation token to delay
                Await Task.Delay(500, cancellationToken)
            Next
        End Function
        
        ' GOOD: While loop with cancellation support
        Async Function GoodProcessWhileCondition(cancellationToken As CancellationToken) As Task
            While HasMoreWork() AndAlso Not cancellationToken.IsCancellationRequested
                Await DoWorkAsync(cancellationToken)
                
                ' GOOD: Pass cancellation token to delay
                Await Task.Delay(1000, cancellationToken)
            End While
        End Function
        
        ' GOOD: HTTP client operations with cancellation
        Async Function GoodMakeHttpRequests(cancellationToken As CancellationToken) As Task(Of String)
            Using client As New HttpClient()
                Dim urls = GetUrls()
                Dim results As New StringBuilder()
                
                For Each url In urls
                    ' GOOD: Check for cancellation
                    cancellationToken.ThrowIfCancellationRequested()
                    
                    ' GOOD: Pass cancellation token to HTTP request
                    Dim response = Await client.GetStringAsync(url, cancellationToken)
                    results.AppendLine(response)
                    
                    ' GOOD: Pass cancellation token to delay
                    Await Task.Delay(2000, cancellationToken)
                Next
                
                Return results.ToString()
            End Using
        End Function
        
        ' GOOD: Database operations with cancellation
        Async Function GoodProcessDatabaseRecords(cancellationToken As CancellationToken) As Task
            Using connection As New SqlConnection(connectionString)
                ' GOOD: Pass cancellation token to database operations
                Await connection.OpenAsync(cancellationToken)
                
                Dim command As New SqlCommand("SELECT * FROM LargeTable", connection)
                Using reader = Await command.ExecuteReaderAsync(cancellationToken)
                    While Await reader.ReadAsync(cancellationToken)
                        ' GOOD: Check for cancellation
                        cancellationToken.ThrowIfCancellationRequested()
                        
                        ProcessRecord(reader)
                        
                        ' GOOD: Pass cancellation token to delay
                        Await Task.Delay(100, cancellationToken)
                    End While
                End Using
            End Using
        End Function
        
        ' GOOD: File operations with cancellation
        Async Function GoodProcessLargeFile(cancellationToken As CancellationToken) As Task(Of String)
            Using stream As New FileStream("largefile.txt", FileMode.Open)
                Using reader As New StreamReader(stream)
                    Dim content As New StringBuilder()
                    Dim line As String
                    
                    line = Await reader.ReadLineAsync()
                    While line IsNot Nothing AndAlso Not cancellationToken.IsCancellationRequested
                        content.AppendLine(line.ToUpper())
                        
                        ' GOOD: Pass cancellation token to delay
                        Await Task.Delay(10, cancellationToken)
                        
                        line = Await reader.ReadLineAsync()
                    End While
                    
                    ' GOOD: Final cancellation check
                    cancellationToken.ThrowIfCancellationRequested()
                    
                    Return content.ToString()
                End Using
            End Using
        End Function
        
        ' GOOD: Cancellation token source management
        Class GoodTaskManager
            Private cancellationTokenSource As CancellationTokenSource
            
            Public Sub New()
                cancellationTokenSource = New CancellationTokenSource()
            End Sub
            
            Public Async Function StartLongRunningTask() As Task(Of String)
                Try
                    Return Await GoodProcessLargeDataSet(cancellationTokenSource.Token)
                Catch ex As OperationCanceledException
                    Return "Task was cancelled"
                End Try
            End Function
            
            Public Sub CancelTask()
                cancellationTokenSource?.Cancel()
            End Sub
            
            Public Sub Dispose()
                cancellationTokenSource?.Dispose()
            End Sub
        End Class
        
        ' GOOD: Timeout with cancellation token
        Class GoodTimeoutManager
            Public Shared Async Function RunWithTimeout(Of T)(task As Func(Of CancellationToken, Task(Of T)), timeoutMs As Integer) As Task(Of T)
                Using cts As New CancellationTokenSource(TimeSpan.FromMilliseconds(timeoutMs))
                    Try
                        Return Await task(cts.Token)
                    Catch ex As OperationCanceledException When cts.Token.IsCancellationRequested
                        Throw New TimeoutException($"Operation timed out after {timeoutMs}ms")
                    End Try
                End Using
            End Function
        End Class
        
        ' GOOD: Cooperative cancellation in compute-intensive tasks
        Function GoodComputeIntensiveTask(cancellationToken As CancellationToken) As Task(Of Long)
            Return Task.Run(Function()
                Dim result As Long = 0
                
                For i As Long = 0 To 10000000
                    ' GOOD: Check for cancellation periodically in compute-intensive loop
                    If i Mod 10000 = 0 Then
                        cancellationToken.ThrowIfCancellationRequested()
                    End If
                    
                    result += i
                Next
                
                Return result
            End Function, cancellationToken)
        End Function
        
        ' GOOD: Cancellation with cleanup
        Async Function GoodProcessWithCleanup(cancellationToken As CancellationToken) As Task
            Dim resources As New List(Of IDisposable)()
            
            Try
                ' Acquire resources
                resources.Add(New FileStream("temp1.txt", FileMode.Create))
                resources.Add(New FileStream("temp2.txt", FileMode.Create))
                
                ' GOOD: Process with cancellation support
                For i As Integer = 0 To 1000
                    cancellationToken.ThrowIfCancellationRequested()
                    
                    ' Do work with resources
                    Await Task.Delay(100, cancellationToken)
                Next
                
            Finally
                ' GOOD: Clean up resources even if cancelled
                For Each resource In resources
                    resource?.Dispose()
                Next
            End Try
        End Function
        
        ' Supporting classes and methods
        Class HttpClient
            Implements IDisposable
            
            Public Async Function GetStringAsync(url As String) As Task(Of String)
                Return "Response"
            End Function
            
            Public Async Function GetStringAsync(url As String, cancellationToken As CancellationToken) As Task(Of String)
                Return "Response"
            End Function
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlConnection
            Implements IDisposable
            
            Public Sub New(connectionString As String)
            End Sub
            
            Public Async Function OpenAsync() As Task
            End Function
            
            Public Async Function OpenAsync(cancellationToken As CancellationToken) As Task
            End Function
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlCommand
            Public Sub New(sql As String, connection As SqlConnection)
            End Sub
            
            Public Async Function ExecuteReaderAsync() As Task(Of SqlDataReader)
                Return New SqlDataReader()
            End Function
            
            Public Async Function ExecuteReaderAsync(cancellationToken As CancellationToken) As Task(Of SqlDataReader)
                Return New SqlDataReader()
            End Function
        End Class
        
        Class SqlDataReader
            Implements IDisposable
            
            Public Async Function ReadAsync() As Task(Of Boolean)
                Return False
            End Function
            
            Public Async Function ReadAsync(cancellationToken As CancellationToken) As Task(Of Boolean)
                Return False
            End Function
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class Directory
            Public Shared Function GetFiles(path As String) As String()
                Return New String() {"file1.txt", "file2.txt"}
            End Function
        End Class
        
        Class Thread
            Public Shared Sub Sleep(milliseconds As Integer)
            End Sub
        End Class
        
        Class CancellationTokenSource
            Implements IDisposable
            
            Public Sub New()
            End Sub
            
            Public Sub New(timeout As TimeSpan)
            End Sub
            
            Public Property Token As CancellationToken
            
            Public Sub Cancel()
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Structure CancellationToken
            Public Property IsCancellationRequested As Boolean
            
            Public Sub ThrowIfCancellationRequested()
                If IsCancellationRequested Then
                    Throw New OperationCanceledException()
                End If
            End Sub
        End Structure
        
        Class OperationCanceledException
            Inherits Exception
        End Class
        
        Class TimeoutException
            Inherits Exception
            
            Public Sub New(message As String)
                MyBase.New(message)
            End Sub
        End Class
        
        ' Helper methods
        Private connectionString As String = "Server=localhost;Database=TestDB;"
        
        Async Function ProcessFile(filePath As String) As Task
        End Function
        
        Async Function ProcessFileAsync(filePath As String, cancellationToken As CancellationToken) As Task
        End Function
        
        Sub PerformCalculation(value As Integer)
        End Sub
        
        Function GetItems() As List(Of String)
            Return New List(Of String) From {"item1", "item2", "item3"}
        End Function
        
        Async Function ProcessItemAsync(item As String) As Task
        End Function
        
        Async Function ProcessItemAsync(item As String, cancellationToken As CancellationToken) As Task
        End Function
        
        Function HasMoreWork() As Boolean
            Return False
        End Function
        
        Async Function DoWorkAsync() As Task
        End Function
        
        Async Function DoWorkAsync(cancellationToken As CancellationToken) As Task
        End Function
        
        Function GetUrls() As List(Of String)
            Return New List(Of String) From {"http://example1.com", "http://example2.com"}
        End Function
        
        Sub ProcessRecord(reader As SqlDataReader)
        End Sub
    </script>
</body>
</html>
