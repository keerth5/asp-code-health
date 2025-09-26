<%@ Page Language="VB" %>
<html>
<head>
    <title>Memory Leaks Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Memory leaks - objects not properly disposed or references not cleared
        
        Public Class BadMemoryLeakClass
            ' BAD: Event handlers without removal
            Private WithEvents timer As New Timer()
            Private WithEvents button As New Button()
            
            Sub BadEventHandlerLeak()
                ' BAD: Adding event handlers without removing them
                AddHandler timer.Tick, AddressOf Timer_Tick ' Memory leak risk
                AddHandler button.Click, AddressOf Button_Click ' Memory leak risk
                
                ' BAD: Using += without -= 
                timer.Elapsed += Timer_Elapsed ' Memory leak risk
                button.MouseEnter += Button_MouseEnter ' Memory leak risk
            End Sub
            
            ' BAD: Static collections that grow without clearing
            Private Shared userCache As New List(Of User)() ' Memory leak: never cleared
            Private Shared sessionData As New Dictionary(Of String, Object)() ' Memory leak: never cleared
            Private Shared logEntries As New ArrayList() ' Memory leak: never cleared
            
            Sub BadStaticCollectionLeak()
                ' BAD: Adding to static collections without cleanup
                userCache.Add(New User())
                sessionData.Add("key", New Object())
                logEntries.Add("log entry")
                ' These collections will grow indefinitely
            End Sub
            
            ' BAD: Timers, threads, and background workers without disposal
            Private backgroundTimer As Timer = New Timer() ' Memory leak: not disposed
            Private workerThread As Thread = New Thread(AddressOf DoWork) ' Memory leak: not stopped
            Private bgWorker As BackgroundWorker = New BackgroundWorker() ' Memory leak: not disposed
            
            Sub BadResourceLeak()
                ' BAD: Starting resources without proper cleanup
                backgroundTimer.Start()
                workerThread.Start()
                bgWorker.RunWorkerAsync()
                ' No disposal or cleanup code
            End Sub
        End Class
        
        Sub BadFileHandleLeak()
            ' BAD: File handles not properly disposed
            Dim fileStream As New FileStream("data.txt", FileMode.Open) ' Not disposed
            Dim reader As New StreamReader("config.xml") ' Not disposed
            Dim writer As New StreamWriter("output.log") ' Not disposed
            
            ' Use resources without disposal
            Dim data = reader.ReadToEnd()
            writer.WriteLine("data")
        End Sub
        
        Sub BadDatabaseConnectionLeak()
            ' BAD: Database connections not disposed
            Dim connection As New SqlConnection(connectionString) ' Not disposed
            Dim command As New SqlCommand("SELECT * FROM Users", connection) ' Not disposed
            Dim adapter As New SqlDataAdapter(command) ' Not disposed
            
            connection.Open()
            Dim reader = command.ExecuteReader() ' Not disposed
            ProcessData(reader)
        End Sub
        
        ' GOOD: Proper resource management
        
        Public Class GoodResourceManagementClass
            Private WithEvents timer As New Timer()
            Private WithEvents button As New Button()
            
            Sub GoodEventHandlerManagement()
                ' GOOD: Properly managing event handlers
                AddHandler timer.Tick, AddressOf Timer_Tick
                AddHandler button.Click, AddressOf Button_Click
                
                ' Later in cleanup:
                RemoveHandler timer.Tick, AddressOf Timer_Tick
                RemoveHandler button.Click, AddressOf Button_Click
                
                ' GOOD: Using -= to remove handlers
                timer.Elapsed += Timer_Elapsed
                timer.Elapsed -= Timer_Elapsed ' Proper cleanup
            End Sub
            
            ' GOOD: Managed static collections with cleanup
            Private Shared userCache As New List(Of User)()
            Private Shared sessionData As New Dictionary(Of String, Object)()
            
            Sub GoodStaticCollectionManagement()
                userCache.Add(New User())
                sessionData.Add("key", New Object())
                
                ' GOOD: Periodic cleanup
                If userCache.Count > 1000 Then
                    userCache.Clear()
                End If
                
                If sessionData.Count > 500 Then
                    sessionData.Clear()
                End If
            End Sub
            
            ' GOOD: Proper disposal of resources
            Private backgroundTimer As Timer
            Private workerThread As Thread
            Private bgWorker As BackgroundWorker
            
            Sub GoodResourceManagement()
                backgroundTimer = New Timer()
                workerThread = New Thread(AddressOf DoWork)
                bgWorker = New BackgroundWorker()
                
                backgroundTimer.Start()
                workerThread.Start()
                bgWorker.RunWorkerAsync()
            End Sub
            
            Sub Dispose()
                ' GOOD: Proper cleanup
                If backgroundTimer IsNot Nothing Then
                    backgroundTimer.Stop()
                    backgroundTimer.Dispose()
                End If
                
                If workerThread IsNot Nothing AndAlso workerThread.IsAlive Then
                    workerThread.Abort()
                End If
                
                If bgWorker IsNot Nothing Then
                    bgWorker.Dispose()
                End If
            End Sub
        End Class
        
        Sub GoodFileHandleManagement()
            ' GOOD: Using Using statements for automatic disposal
            Using fileStream As New FileStream("data.txt", FileMode.Open)
                Using reader As New StreamReader(fileStream)
                    Dim data = reader.ReadToEnd()
                    ProcessFileData(data)
                End Using
            End Using
            
            Using writer As New StreamWriter("output.log")
                writer.WriteLine("data")
            End Using
        End Sub
        
        Sub GoodDatabaseConnectionManagement()
            ' GOOD: Proper disposal of database resources
            Using connection As New SqlConnection(connectionString)
                Using command As New SqlCommand("SELECT * FROM Users", connection)
                    connection.Open()
                    Using reader = command.ExecuteReader()
                        ProcessDatabaseData(reader)
                    End Using
                End Using
            End Using
        End Sub
        
        Sub GoodWeakReferences()
            ' GOOD: Using weak references to prevent memory leaks
            Dim weakRef As New WeakReference(New LargeObject())
            
            If weakRef.IsAlive Then
                Dim obj = CType(weakRef.Target, LargeObject)
                If obj IsNot Nothing Then
                    ProcessLargeObject(obj)
                End If
            End If
        End Sub
        
        Sub GoodCacheWithExpiration()
            ' GOOD: Cache with expiration to prevent memory leaks
            Dim cache As New MemoryCache("AppCache")
            Dim policy As New CacheItemPolicy()
            policy.AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(30)
            
            cache.Set("key", New Object(), policy)
        End Sub
        
        ' Helper methods and fields
        Private connectionString As String = "Data Source=server;Initial Catalog=db;"
        
        Sub Timer_Tick(sender As Object, e As EventArgs)
        End Sub
        
        Sub Button_Click(sender As Object, e As EventArgs)
        End Sub
        
        Sub Timer_Elapsed(sender As Object, e As EventArgs)
        End Sub
        
        Sub Button_MouseEnter(sender As Object, e As EventArgs)
        End Sub
        
        Sub DoWork()
        End Sub
        
        Sub ProcessData(reader As SqlDataReader)
        End Sub
        
        Sub ProcessFileData(data As String)
        End Sub
        
        Sub ProcessDatabaseData(reader As SqlDataReader)
        End Sub
        
        Sub ProcessLargeObject(obj As LargeObject)
        End Sub
        
        ' Helper classes
        Public Class User
            Public Property Id As Integer
            Public Property Name As String
        End Class
        
        Public Class LargeObject
            Private data(10000) As Byte
        End Class
    </script>
</body>
</html>
