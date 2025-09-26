<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing ConfigureAwait Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing ConfigureAwait in library/non-UI code
        
        Async Function BadAsyncWithoutConfigureAwait() As Task(Of String)
            ' BAD: Missing ConfigureAwait(false) in library code
            Dim result = Await httpClient.GetStringAsync("https://api.example.com") ' Should use ConfigureAwait(false)
            Dim data = Await File.ReadAllTextAsync("data.txt") ' Should use ConfigureAwait(false)
            Dim response = Await webClient.DownloadStringTaskAsync("https://service.com") ' Should use ConfigureAwait(false)
            
            Return result + data + response
        End Function
        
        Async Function BadDatabaseOperations() As Task(Of Integer)
            ' BAD: Database operations without ConfigureAwait
            Await connection.OpenAsync() ' Should use ConfigureAwait(false)
            Dim count = Await command.ExecuteScalarAsync() ' Should use ConfigureAwait(false)
            Await connection.CloseAsync() ' Should use ConfigureAwait(false)
            
            Return CInt(count)
        End Function
        
        Async Sub BadAsyncVoidWithoutConfigureAwait()
            ' BAD: Even async void should use ConfigureAwait in library code
            Await ProcessDataAsync() ' Should use ConfigureAwait(false)
            Await SaveResultsAsync() ' Should use ConfigureAwait(false)
        End Sub
        
        Async Function BadTaskOperations() As Task
            ' BAD: Task operations without ConfigureAwait
            Await Task.Delay(1000) ' Should use ConfigureAwait(false)
            Await Task.Run(Sub() ProcessCpuBoundWork()) ' Should use ConfigureAwait(false)
            Await Task.FromResult(42) ' Should use ConfigureAwait(false)
        End Function
        
        Async Function BadStreamOperations() As Task(Of String)
            ' BAD: Stream operations without ConfigureAwait
            Using stream As New FileStream("file.txt", FileMode.Open)
                Dim buffer(1024) As Byte
                Await stream.ReadAsync(buffer, 0, buffer.Length) ' Should use ConfigureAwait(false)
                Await stream.WriteAsync(buffer, 0, buffer.Length) ' Should use ConfigureAwait(false)
                Await stream.FlushAsync() ' Should use ConfigureAwait(false)
            End Using
            
            Return "completed"
        End Function
        
        Async Function BadNestedAsyncCalls() As Task(Of Boolean)
            ' BAD: Nested async calls without ConfigureAwait
            Dim user = Await GetUserAsync("123") ' Should use ConfigureAwait(false)
            Dim profile = Await GetUserProfileAsync(user.Id) ' Should use ConfigureAwait(false)
            Dim settings = Await GetUserSettingsAsync(profile.UserId) ' Should use ConfigureAwait(false)
            
            Return settings IsNot Nothing
        End Function
        
        Async Function BadLibraryMethod() As Task(Of String)
            ' BAD: Library method without ConfigureAwait
            Dim client As New HttpClient()
            Dim response = Await client.GetAsync("https://api.service.com/data") ' Should use ConfigureAwait(false)
            Dim content = Await response.Content.ReadAsStringAsync() ' Should use ConfigureAwait(false)
            
            Return content
        End Function
        
        ' GOOD: Proper ConfigureAwait usage in library/non-UI code
        
        Async Function GoodAsyncWithConfigureAwait() As Task(Of String)
            ' GOOD: Using ConfigureAwait(false) in library code
            Dim result = Await httpClient.GetStringAsync("https://api.example.com").ConfigureAwait(False)
            Dim data = Await File.ReadAllTextAsync("data.txt").ConfigureAwait(False)
            Dim response = Await webClient.DownloadStringTaskAsync("https://service.com").ConfigureAwait(False)
            
            Return result + data + response
        End Function
        
        Async Function GoodDatabaseOperations() As Task(Of Integer)
            ' GOOD: Database operations with ConfigureAwait(false)
            Await connection.OpenAsync().ConfigureAwait(False)
            Dim count = Await command.ExecuteScalarAsync().ConfigureAwait(False)
            Await connection.CloseAsync().ConfigureAwait(False)
            
            Return CInt(count)
        End Function
        
        Async Function GoodTaskOperations() As Task
            ' GOOD: Task operations with ConfigureAwait(false)
            Await Task.Delay(1000).ConfigureAwait(False)
            Await Task.Run(Sub() ProcessCpuBoundWork()).ConfigureAwait(False)
            Await Task.FromResult(42).ConfigureAwait(False)
        End Function
        
        Async Function GoodStreamOperations() As Task(Of String)
            ' GOOD: Stream operations with ConfigureAwait(false)
            Using stream As New FileStream("file.txt", FileMode.Open)
                Dim buffer(1024) As Byte
                Await stream.ReadAsync(buffer, 0, buffer.Length).ConfigureAwait(False)
                Await stream.WriteAsync(buffer, 0, buffer.Length).ConfigureAwait(False)
                Await stream.FlushAsync().ConfigureAwait(False)
            End Using
            
            Return "completed"
        End Function
        
        Async Function GoodNestedAsyncCalls() As Task(Of Boolean)
            ' GOOD: Nested async calls with ConfigureAwait(false)
            Dim user = Await GetUserAsync("123").ConfigureAwait(False)
            Dim profile = Await GetUserProfileAsync(user.Id).ConfigureAwait(False)
            Dim settings = Await GetUserSettingsAsync(profile.UserId).ConfigureAwait(False)
            
            Return settings IsNot Nothing
        End Function
        
        Async Function GoodLibraryMethod() As Task(Of String)
            ' GOOD: Library method with ConfigureAwait(false)
            Dim client As New HttpClient()
            Dim response = Await client.GetAsync("https://api.service.com/data").ConfigureAwait(False)
            Dim content = Await response.Content.ReadAsStringAsync().ConfigureAwait(False)
            
            Return content
        End Function
        
        ' GOOD: UI code where ConfigureAwait(true) or no ConfigureAwait is acceptable
        
        Async Sub GoodUIEventHandler() ' Event handler - ConfigureAwait not required
            ' GOOD: UI event handler - can use default context
            Dim data = Await LoadDataAsync() ' OK in UI context
            UpdateUI(data) ' Needs UI context
        End Sub
        
        Async Sub Button_Click(sender As Object, e As EventArgs) ' Event handler
            ' GOOD: UI event handler - default context is fine
            Dim result = Await ProcessUserActionAsync() ' OK in UI context
            MessageBox.Show(result) ' Needs UI context
        End Sub
        
        Async Function GoodUIMethod() As Task
            ' GOOD: UI method where context matters
            Dim data = Await GetDataAsync() ' Can use default context in UI
            DisplayResults(data) ' Needs UI thread
        End Function
        
        ' GOOD: Mixed scenarios
        
        Async Function GoodMixedLibraryAndUI() As Task
            ' Library part - use ConfigureAwait(false)
            Dim data = Await FetchDataFromApiAsync().ConfigureAwait(False)
            Dim processed = Await ProcessDataAsync(data).ConfigureAwait(False)
            
            ' UI part - can use default context
            Await Dispatcher.InvokeAsync(Sub() UpdateDisplay(processed))
        End Function
        
        ' Helper methods and fields
        Private httpClient As New HttpClient()
        Private webClient As New WebClient()
        Private connection As New SqlConnection()
        Private command As New SqlCommand()
        
        Async Function ProcessDataAsync() As Task
            Await Task.Delay(100)
        End Function
        
        Async Function SaveResultsAsync() As Task
            Await Task.Delay(50)
        End Function
        
        Sub ProcessCpuBoundWork()
        End Sub
        
        Async Function GetUserAsync(id As String) As Task(Of User)
            Await Task.Delay(10)
            Return New User() With {.Id = id}
        End Function
        
        Async Function GetUserProfileAsync(userId As String) As Task(Of UserProfile)
            Await Task.Delay(10)
            Return New UserProfile() With {.UserId = userId}
        End Function
        
        Async Function GetUserSettingsAsync(userId As String) As Task(Of UserSettings)
            Await Task.Delay(10)
            Return New UserSettings()
        End Function
        
        Async Function LoadDataAsync() As Task(Of String)
            Return Await Task.FromResult("data")
        End Function
        
        Sub UpdateUI(data As String)
        End Sub
        
        Async Function ProcessUserActionAsync() As Task(Of String)
            Return Await Task.FromResult("action completed")
        End Function
        
        Async Function FetchDataFromApiAsync() As Task(Of String)
            Return Await httpClient.GetStringAsync("https://api.com").ConfigureAwait(False)
        End Function
        
        Async Function ProcessDataAsync(data As String) As Task(Of String)
            Await Task.Delay(100).ConfigureAwait(False)
            Return data.ToUpper()
        End Function
        
        Sub DisplayResults(data As String)
        End Sub
        
        Sub UpdateDisplay(data As String)
        End Sub
        
        Async Function GetDataAsync() As Task(Of String)
            Return Await Task.FromResult("ui data")
        End Function
        
        ' Helper classes
        Public Class User
            Public Property Id As String
        End Class
        
        Public Class UserProfile
            Public Property UserId As String
        End Class
        
        Public Class UserSettings
        End Class
    </script>
</body>
</html>
