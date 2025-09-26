<%@ Page Language="VB" %>
<html>
<head>
    <title>Inappropriate SynchronizationContext Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inappropriate SynchronizationContext - not considering SynchronizationContext in async operations
        
        ' BAD: Task.Run with await without ConfigureAwait
        Async Function BadTaskRunWithAwait() As Task(Of String)
            ' BAD: Task.Run followed by await without ConfigureAwait(false)
            Dim result = Await Task.Run(Function() "Background work")
            Return result.ToUpper()
        End Function
        
        ' BAD: Task.Factory.StartNew with await without ConfigureAwait
        Async Function BadFactoryStartNewWithAwait() As Task(Of Integer)
            ' BAD: Task.Factory.StartNew followed by await without ConfigureAwait(false)
            Dim result = Await Task.Factory.StartNew(Function() 42)
            Return result * 2
        End Function
        
        ' BAD: Task.Delay without ConfigureAwait in library code
        Async Function BadTaskDelay() As Task
            ' BAD: Task.Delay without ConfigureAwait(false)
            Await Task.Delay(1000)
            ' More work
        End Function
        
        ' BAD: HttpClient operations without ConfigureAwait
        Async Function BadHttpClientCall() As Task(Of String)
            Using client As New HttpClient()
                ' BAD: HTTP call without ConfigureAwait(false)
                Dim response = Await client.GetStringAsync("http://example.com")
                Return response.Substring(0, 100)
            End Using
        End Function
        
        ' BAD: Database operations without ConfigureAwait
        Async Function BadDatabaseCall() As Task(Of Integer)
            Using connection As New SqlConnection(connectionString)
                ' BAD: Database operations without ConfigureAwait(false)
                Await connection.OpenAsync()
                
                Dim command As New SqlCommand("SELECT COUNT(*) FROM Users", connection)
                Dim result = Await command.ExecuteScalarAsync()
                
                Return CInt(result)
            End Using
        End Function
        
        ' BAD: File operations without ConfigureAwait
        Async Function BadFileOperations() As Task(Of String)
            ' BAD: File operations without ConfigureAwait(false)
            Dim content = Await File.ReadAllTextAsync("data.txt")
            
            Dim processedContent = content.ToUpper()
            
            Await File.WriteAllTextAsync("output.txt", processedContent)
            
            Return processedContent
        End Function
        
        ' BAD: Multiple async operations without ConfigureAwait
        Async Function BadMultipleAsyncOps() As Task(Of String)
            ' BAD: Multiple async operations without ConfigureAwait(false)
            Dim task1 = Task.Run(Function() "Result1")
            Dim task2 = Task.Run(Function() "Result2")
            Dim task3 = Task.Run(Function() "Result3")
            
            Dim result1 = Await task1
            Dim result2 = Await task2
            Dim result3 = Await task3
            
            Return $"{result1}-{result2}-{result3}"
        End Function
        
        ' BAD: Async method in UI context without proper synchronization
        Async Sub BadUIAsyncOperation()
            ' BAD: UI operation with async without considering SynchronizationContext
            Dim data = Await LoadDataAsync()
            
            ' This would be problematic in actual UI context
            UpdateUIControls(data)
        End Sub
        
        ' BAD: Form control access in async method
        Async Function BadFormControlAccess() As Task
            ' BAD: Async operation that might access form controls
            Dim userData = Await GetUserDataAsync()
            
            ' These would be problematic in actual WinForms context
            ' userNameLabel.Text = userData.Name
            ' emailLabel.Text = userData.Email
        End Function
        
        ' GOOD: Proper SynchronizationContext handling
        
        ' GOOD: Task.Run with ConfigureAwait(false)
        Async Function GoodTaskRunWithConfigureAwait() As Task(Of String)
            ' GOOD: Task.Run with ConfigureAwait(false)
            Dim result = Await Task.Run(Function() "Background work").ConfigureAwait(False)
            Return result.ToUpper()
        End Function
        
        ' GOOD: Task.Factory.StartNew with ConfigureAwait(false)
        Async Function GoodFactoryStartNewWithConfigureAwait() As Task(Of Integer)
            ' GOOD: Task.Factory.StartNew with ConfigureAwait(false)
            Dim result = Await Task.Factory.StartNew(Function() 42).ConfigureAwait(False)
            Return result * 2
        End Function
        
        ' GOOD: Task.Delay with ConfigureAwait(false)
        Async Function GoodTaskDelay() As Task
            ' GOOD: Task.Delay with ConfigureAwait(false)
            Await Task.Delay(1000).ConfigureAwait(False)
            ' More work
        End Function
        
        ' GOOD: HttpClient operations with ConfigureAwait(false)
        Async Function GoodHttpClientCall() As Task(Of String)
            Using client As New HttpClient()
                ' GOOD: HTTP call with ConfigureAwait(false)
                Dim response = Await client.GetStringAsync("http://example.com").ConfigureAwait(False)
                Return response.Substring(0, 100)
            End Using
        End Function
        
        ' GOOD: Database operations with ConfigureAwait(false)
        Async Function GoodDatabaseCall() As Task(Of Integer)
            Using connection As New SqlConnection(connectionString)
                ' GOOD: Database operations with ConfigureAwait(false)
                Await connection.OpenAsync().ConfigureAwait(False)
                
                Dim command As New SqlCommand("SELECT COUNT(*) FROM Users", connection)
                Dim result = Await command.ExecuteScalarAsync().ConfigureAwait(False)
                
                Return CInt(result)
            End Using
        End Function
        
        ' GOOD: File operations with ConfigureAwait(false)
        Async Function GoodFileOperations() As Task(Of String)
            ' GOOD: File operations with ConfigureAwait(false)
            Dim content = Await File.ReadAllTextAsync("data.txt").ConfigureAwait(False)
            
            Dim processedContent = content.ToUpper()
            
            Await File.WriteAllTextAsync("output.txt", processedContent).ConfigureAwait(False)
            
            Return processedContent
        End Function
        
        ' GOOD: Multiple async operations with ConfigureAwait(false)
        Async Function GoodMultipleAsyncOps() As Task(Of String)
            ' GOOD: Multiple async operations with ConfigureAwait(false)
            Dim task1 = Task.Run(Function() "Result1")
            Dim task2 = Task.Run(Function() "Result2")
            Dim task3 = Task.Run(Function() "Result3")
            
            Dim result1 = Await task1.ConfigureAwait(False)
            Dim result2 = Await task2.ConfigureAwait(False)
            Dim result3 = Await task3.ConfigureAwait(False)
            
            Return $"{result1}-{result2}-{result3}"
        End Function
        
        ' GOOD: Proper UI synchronization using SynchronizationContext
        Async Sub GoodUIAsyncOperation()
            Dim originalContext = SynchronizationContext.Current
            
            Try
                ' GOOD: Background work with ConfigureAwait(false)
                Dim data = Await LoadDataAsync().ConfigureAwait(False)
                
                ' GOOD: Switch back to UI context for UI updates
                If originalContext IsNot Nothing Then
                    originalContext.Post(Sub(state) UpdateUIControls(CType(state, UserData)), data)
                End If
            Catch ex As Exception
                ' Handle exception
            End Try
        End Sub
        
        ' GOOD: Using Invoke for UI thread marshalling
        Async Function GoodFormControlAccess() As Task
            ' GOOD: Background work with ConfigureAwait(false)
            Dim userData = Await GetUserDataAsync().ConfigureAwait(False)
            
            ' GOOD: Use Invoke to marshal to UI thread (conceptual)
            ' If Me.InvokeRequired Then
            '     Me.Invoke(Sub() UpdateFormControls(userData))
            ' Else
            '     UpdateFormControls(userData)
            ' End If
        End Function
        
        ' GOOD: Async method that properly handles both library and UI scenarios
        Async Function GoodFlexibleAsyncMethod(continueOnCapturedContext As Boolean) As Task(Of String)
            ' GOOD: Allow caller to specify context behavior
            Dim data = Await LoadDataAsync().ConfigureAwait(continueOnCapturedContext)
            
            Dim processed = ProcessData(data)
            
            Await SaveDataAsync(processed).ConfigureAwait(continueOnCapturedContext)
            
            Return processed
        End Function
        
        ' GOOD: Library method that always uses ConfigureAwait(false)
        Async Function GoodLibraryMethod() As Task(Of String)
            ' GOOD: Library methods should use ConfigureAwait(false)
            Dim step1 = Await PerformStep1Async().ConfigureAwait(False)
            Dim step2 = Await PerformStep2Async(step1).ConfigureAwait(False)
            Dim step3 = Await PerformStep3Async(step2).ConfigureAwait(False)
            
            Return step3
        End Function
        
        ' GOOD: Proper async/await pattern for UI applications
        Async Sub GoodUIEventHandler()
            Try
                ' Disable UI controls
                SetControlsEnabled(False)
                
                ' GOOD: Background work
                Dim result = Await ProcessDataInBackground().ConfigureAwait(True)
                
                ' GOOD: UI update happens on UI thread
                UpdateUI(result)
                
            Catch ex As Exception
                ShowError(ex.Message)
            Finally
                ' Re-enable UI controls
                SetControlsEnabled(True)
            End Try
        End Sub
        
        ' GOOD: Using TaskScheduler for UI thread
        Async Function GoodTaskSchedulerApproach() As Task
            ' GOOD: Background work
            Dim data = Await LoadDataAsync().ConfigureAwait(False)
            
            ' GOOD: Schedule UI update on UI TaskScheduler
            Await Task.Factory.StartNew(
                Sub() UpdateUIControls(data),
                CancellationToken.None,
                TaskCreationOptions.None,
                TaskScheduler.FromCurrentSynchronizationContext())
        End Function
        
        ' GOOD: Async method with proper exception handling and context
        Async Function GoodAsyncWithExceptionHandling() As Task(Of String)
            Try
                Dim result1 = Await Step1Async().ConfigureAwait(False)
                Dim result2 = Await Step2Async(result1).ConfigureAwait(False)
                Dim result3 = Await Step3Async(result2).ConfigureAwait(False)
                
                Return result3
                
            Catch ex As HttpRequestException
                ' Handle specific exception with ConfigureAwait(false)
                Await LogErrorAsync($"HTTP error: {ex.Message}").ConfigureAwait(False)
                Throw
                
            Catch ex As Exception
                ' Handle general exception with ConfigureAwait(false)
                Await LogErrorAsync($"General error: {ex.Message}").ConfigureAwait(False)
                Throw
            End Try
        End Function
        
        ' GOOD: Custom awaitable with ConfigureAwait support
        Class GoodCustomAwaitable
            Private task As Task(Of String)
            
            Public Sub New(task As Task(Of String))
                Me.task = task
            End Sub
            
            Public Function ConfigureAwait(continueOnCapturedContext As Boolean) As ConfiguredTaskAwaitable(Of String)
                Return task.ConfigureAwait(continueOnCapturedContext)
            End Function
            
            Public Function GetAwaiter() As TaskAwaiter(Of String)
                Return task.GetAwaiter()
            End Function
        End Class
        
        ' Supporting classes and methods
        Class HttpClient
            Implements IDisposable
            
            Public Async Function GetStringAsync(url As String) As Task(Of String)
                Return "Response content"
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
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlCommand
            Public Sub New(sql As String, connection As SqlConnection)
            End Sub
            
            Public Async Function ExecuteScalarAsync() As Task(Of Object)
                Return 42
            End Function
        End Class
        
        Class File
            Public Shared Async Function ReadAllTextAsync(path As String) As Task(Of String)
                Return "File content"
            End Function
            
            Public Shared Async Function WriteAllTextAsync(path As String, content As String) As Task
            End Function
        End Class
        
        Class UserData
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Class SynchronizationContext
            Public Shared Property Current As SynchronizationContext
            
            Public Sub Post(callback As SendOrPostCallback, state As Object)
            End Sub
        End Class
        
        Delegate Sub SendOrPostCallback(state As Object)
        
        Class TaskScheduler
            Public Shared Function FromCurrentSynchronizationContext() As TaskScheduler
                Return Nothing
            End Function
        End Class
        
        Structure ConfiguredTaskAwaitable(Of T)
        End Structure
        
        Structure TaskAwaiter(Of T)
        End Structure
        
        ' Helper methods
        Private connectionString As String = "Server=localhost;Database=TestDB;"
        
        Async Function LoadDataAsync() As Task(Of UserData)
            Return New UserData() With {.Name = "Test User", .Email = "test@example.com"}
        End Function
        
        Async Function GetUserDataAsync() As Task(Of UserData)
            Return New UserData() With {.Name = "User", .Email = "user@example.com"}
        End Function
        
        Sub UpdateUIControls(data As UserData)
        End Sub
        
        Sub UpdateFormControls(data As UserData)
        End Sub
        
        Function ProcessData(data As UserData) As String
            Return $"{data.Name}: {data.Email}"
        End Function
        
        Async Function SaveDataAsync(data As String) As Task
        End Function
        
        Async Function PerformStep1Async() As Task(Of String)
            Return "Step1"
        End Function
        
        Async Function PerformStep2Async(input As String) As Task(Of String)
            Return $"Step2({input})"
        End Function
        
        Async Function PerformStep3Async(input As String) As Task(Of String)
            Return $"Step3({input})"
        End Function
        
        Async Function ProcessDataInBackground() As Task(Of String)
            Return "Processed"
        End Function
        
        Sub UpdateUI(result As String)
        End Sub
        
        Sub ShowError(message As String)
        End Sub
        
        Sub SetControlsEnabled(enabled As Boolean)
        End Sub
        
        Async Function Step1Async() As Task(Of String)
            Return "Step1"
        End Function
        
        Async Function Step2Async(input As String) As Task(Of String)
            Return $"Step2({input})"
        End Function
        
        Async Function Step3Async(input As String) As Task(Of String)
            Return $"Step3({input})"
        End Function
        
        Async Function LogErrorAsync(message As String) As Task
        End Function
        
        Class HttpRequestException
            Inherits Exception
            
            Public Sub New(message As String)
                MyBase.New(message)
            End Sub
        End Class
    </script>
</body>
</html>
