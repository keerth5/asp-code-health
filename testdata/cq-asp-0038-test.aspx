<%@ Page Language="VB" %>
<html>
<head>
    <title>Async Void Methods Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Async void methods (should be async Task instead)
        
        Public Async Sub BadAsyncVoidMethod() ' Should be Async Function returning Task
            Await ProcessDataAsync()
            Await SaveResultsAsync()
        End Sub
        
        Private Async Sub BadPrivateAsyncVoid() ' Should be Async Function returning Task
            Await LoadConfigurationAsync()
            Await InitializeServicesAsync()
        End Sub
        
        Protected Async Sub BadProtectedAsyncVoid() ' Should be Async Function returning Task
            Await ValidateDataAsync()
            Await LogOperationAsync()
        End Sub
        
        Public Async Sub BadBusinessLogicAsyncVoid() ' Should be Async Function returning Task
            Dim data = Await FetchDataAsync()
            Await ProcessBusinessRulesAsync(data)
            Await UpdateDatabaseAsync(data)
        End Sub
        
        Private Async Sub BadUtilityAsyncVoid() ' Should be Async Function returning Task
            Await CleanupTempFilesAsync()
            Await SendNotificationAsync()
        End Sub
        
        Async Sub BadAsyncVoidWithoutModifier() ' Should be Async Function returning Task
            Await PerformMaintenanceAsync()
            Await GenerateReportsAsync()
        End Sub
        
        Public Async Sub BadAsyncVoidWithParameters(data As String) ' Should be Async Function returning Task
            Await ProcessParameterAsync(data)
            Await SaveParameterAsync(data)
        End Sub
        
        Private Async Sub BadAsyncVoidInClass() ' Should be Async Function returning Task
            Await InitializeClassAsync()
            Await SetupResourcesAsync()
        End Sub
        
        ' GOOD: Proper async Task methods
        
        Public Async Function GoodAsyncTaskMethod() As Task
            Await ProcessDataAsync()
            Await SaveResultsAsync()
        End Function
        
        Private Async Function GoodPrivateAsyncTask() As Task
            Await LoadConfigurationAsync()
            Await InitializeServicesAsync()
        End Function
        
        Protected Async Function GoodProtectedAsyncTask() As Task
            Await ValidateDataAsync()
            Await LogOperationAsync()
        End Function
        
        Public Async Function GoodBusinessLogicAsyncTask() As Task
            Dim data = Await FetchDataAsync()
            Await ProcessBusinessRulesAsync(data)
            Await UpdateDatabaseAsync(data)
        End Function
        
        Private Async Function GoodUtilityAsyncTask() As Task
            Await CleanupTempFilesAsync()
            Await SendNotificationAsync()
        End Function
        
        Public Async Function GoodAsyncTaskWithParameters(data As String) As Task
            Await ProcessParameterAsync(data)
            Await SaveParameterAsync(data)
        End Function
        
        Private Async Function GoodAsyncTaskInClass() As Task
            Await InitializeClassAsync()
            Await SetupResourcesAsync()
        End Function
        
        ' GOOD: Async Task(Of T) for methods that return values
        
        Public Async Function GoodAsyncTaskWithReturn() As Task(Of String)
            Dim data = Await FetchDataAsync()
            Dim processed = Await ProcessDataForReturnAsync(data)
            Return processed
        End Function
        
        Private Async Function GoodAsyncTaskWithIntReturn() As Task(Of Integer)
            Dim count = Await GetRecordCountAsync()
            Await LogCountAsync(count)
            Return count
        End Function
        
        ' GOOD: Async void is acceptable for event handlers
        
        Public Async Sub Button_Click(sender As Object, e As EventArgs) ' OK - Event handler
            Await HandleButtonClickAsync()
            UpdateUI()
        End Sub
        
        Private Async Sub Timer_Elapsed(sender As Object, e As EventArgs) ' OK - Event handler
            Await PerformTimerTaskAsync()
        End Sub
        
        Async Sub Page_Load(sender As Object, e As EventArgs) ' OK - Event handler
            Await InitializePageAsync()
        End Sub
        
        Public Async Sub DataGrid_RowUpdating(sender As Object, e As EventArgs) ' OK - Event handler
            Await ValidateRowDataAsync()
            Await UpdateRowAsync()
        End Sub
        
        Private Async Sub WebSocket_MessageReceived(sender As Object, e As EventArgs) ' OK - Event handler
            Await ProcessWebSocketMessageAsync()
        End Sub
        
        ' GOOD: Methods with "Handles" keyword (event handlers)
        
        Public Async Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click ' OK - Event handler
            Await ProcessButtonActionAsync()
        End Sub
        
        Private Async Sub Form_Load(sender As Object, e As EventArgs) Handles MyBase.Load ' OK - Event handler
            Await InitializeFormAsync()
        End Sub
        
        ' GOOD: Event handlers with EventArgs parameter
        
        Public Async Sub CustomEventHandler(sender As Object, e As CustomEventArgs) ' OK - Has EventArgs
            Await HandleCustomEventAsync(e)
        End Sub
        
        Private Async Sub AnotherEventHandler(sender As Object, e As MyEventArgs) ' OK - Has EventArgs
            Await ProcessEventAsync(e)
        End Sub
        
        ' GOOD: Methods with underscore (often event handlers by convention)
        
        Public Async Sub Control_SomeEvent() ' OK - Underscore suggests event handler
            Await HandleControlEventAsync()
        End Sub
        
        Private Async Sub Service_DataReceived() ' OK - Underscore suggests event handler
            Await ProcessReceivedDataAsync()
        End Sub
        
        ' GOOD: Top-level async methods that don't need to be awaited
        
        Public Async Function StartBackgroundProcessAsync() As Task
            ' Fire and forget pattern (but still returns Task)
            Await Task.Run(Async Function()
                               Await DoBackgroundWorkAsync()
                           End Function)
        End Function
        
        ' GOOD: Using async void appropriately with proper error handling
        
        Public Async Sub GoodAsyncVoidWithErrorHandling() ' Event handler with error handling
            Try
                Await RiskyOperationAsync()
            Catch ex As Exception
                LogError(ex)
                ' Handle error appropriately in event handler
            End Try
        End Sub
        
        ' Helper methods
        
        Async Function ProcessDataAsync() As Task
            Await Task.Delay(100)
        End Function
        
        Async Function SaveResultsAsync() As Task
            Await Task.Delay(50)
        End Function
        
        Async Function LoadConfigurationAsync() As Task
            Await Task.Delay(25)
        End Function
        
        Async Function InitializeServicesAsync() As Task
            Await Task.Delay(75)
        End Function
        
        Async Function ValidateDataAsync() As Task
            Await Task.Delay(30)
        End Function
        
        Async Function LogOperationAsync() As Task
            Await Task.Delay(10)
        End Function
        
        Async Function FetchDataAsync() As Task(Of String)
            Await Task.Delay(200)
            Return "data"
        End Function
        
        Async Function ProcessBusinessRulesAsync(data As String) As Task
            Await Task.Delay(150)
        End Function
        
        Async Function UpdateDatabaseAsync(data As String) As Task
            Await Task.Delay(300)
        End Function
        
        Async Function CleanupTempFilesAsync() As Task
            Await Task.Delay(100)
        End Function
        
        Async Function SendNotificationAsync() As Task
            Await Task.Delay(50)
        End Function
        
        Async Function PerformMaintenanceAsync() As Task
            Await Task.Delay(500)
        End Function
        
        Async Function GenerateReportsAsync() As Task
            Await Task.Delay(1000)
        End Function
        
        Async Function ProcessParameterAsync(data As String) As Task
            Await Task.Delay(100)
        End Function
        
        Async Function SaveParameterAsync(data As String) As Task
            Await Task.Delay(75)
        End Function
        
        Async Function InitializeClassAsync() As Task
            Await Task.Delay(50)
        End Function
        
        Async Function SetupResourcesAsync() As Task
            Await Task.Delay(25)
        End Function
        
        Async Function ProcessDataForReturnAsync(data As String) As Task(Of String)
            Await Task.Delay(100)
            Return data.ToUpper()
        End Function
        
        Async Function GetRecordCountAsync() As Task(Of Integer)
            Await Task.Delay(200)
            Return 42
        End Function
        
        Async Function LogCountAsync(count As Integer) As Task
            Await Task.Delay(10)
        End Function
        
        Async Function HandleButtonClickAsync() As Task
            Await Task.Delay(50)
        End Function
        
        Sub UpdateUI()
        End Sub
        
        Async Function PerformTimerTaskAsync() As Task
            Await Task.Delay(100)
        End Function
        
        Async Function InitializePageAsync() As Task
            Await Task.Delay(200)
        End Function
        
        Async Function ValidateRowDataAsync() As Task
            Await Task.Delay(75)
        End Function
        
        Async Function UpdateRowAsync() As Task
            Await Task.Delay(125)
        End Function
        
        Async Function ProcessWebSocketMessageAsync() As Task
            Await Task.Delay(25)
        End Function
        
        Async Function ProcessButtonActionAsync() As Task
            Await Task.Delay(150)
        End Function
        
        Async Function InitializeFormAsync() As Task
            Await Task.Delay(300)
        End Function
        
        Async Function HandleCustomEventAsync(e As CustomEventArgs) As Task
            Await Task.Delay(50)
        End Function
        
        Async Function ProcessEventAsync(e As MyEventArgs) As Task
            Await Task.Delay(75)
        End Function
        
        Async Function HandleControlEventAsync() As Task
            Await Task.Delay(25)
        End Function
        
        Async Function ProcessReceivedDataAsync() As Task
            Await Task.Delay(100)
        End Function
        
        Async Function DoBackgroundWorkAsync() As Task
            Await Task.Delay(1000)
        End Function
        
        Async Function RiskyOperationAsync() As Task
            Await Task.Delay(100)
            ' Might throw exception
        End Function
        
        Sub LogError(ex As Exception)
        End Sub
        
        ' Helper classes
        Public Class CustomEventArgs
            Inherits EventArgs
        End Class
        
        Public Class MyEventArgs
            Inherits EventArgs
        End Class
    </script>
</body>
</html>
