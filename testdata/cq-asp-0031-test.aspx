<%@ Page Language="VB" %>
<html>
<head>
    <title>Race Condition Risk Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Race condition risks - shared resources without synchronization
        Public Shared counter As Integer = 0 ' Shared field without synchronization
        Private Shared userCount As Integer = 0 ' Another shared field
        Public Shared connectionString As String = "" ' Shared string field
        
        Sub BadRaceConditionMethod()
            ' BAD: Accessing shared fields without locks
            counter = counter + 1 ' Race condition risk
            userCount += 1 ' Race condition risk
            
            ' BAD: Application/Session state modifications without locks
            Application("TotalVisits") = Application("TotalVisits") + 1 ' Race condition
            Session("UserScore") = Session("UserScore") + 10 ' Race condition
            Application("ActiveUsers") += 1 ' Race condition with increment operator
            Session("LoginCount") += 1 ' Race condition with increment operator
            
            ' BAD: More shared resource access
            Shared totalProcessed As Integer = 0
            totalProcessed = totalProcessed + 1 ' Race condition
        End Sub
        
        Function BadSharedAccessFunction() As Integer
            ' BAD: Multiple operations on shared data
            counter = counter * 2 ' Race condition
            Return counter + userCount ' Reading shared data unsafely
        End Function
        
        ' GOOD: Proper synchronization with locks
        Private Shared lockObject As New Object()
        Private Shared syncLockObject As New Object()
        
        Sub GoodSynchronizedMethod()
            ' GOOD: Using lock for synchronization
            SyncLock lockObject
                counter = counter + 1 ' Safe with lock
                userCount += 1 ' Safe with lock
            End SyncLock
            
            ' GOOD: Using lock for Application state
            SyncLock syncLockObject
                Application("TotalVisits") = Application("TotalVisits") + 1 ' Safe
                Session("UserScore") = Session("UserScore") + 10 ' Safe
            End SyncLock
        End Sub
        
        ' GOOD: Using volatile for simple flags
        Private Shared Volatile isRunning As Boolean = False
        Private Shared Volatile stopRequested As Boolean = False
        
        Sub GoodVolatileUsage()
            If Not stopRequested Then
                isRunning = True
                ' Process work
                isRunning = False
            End If
        End Sub
        
        ' GOOD: Thread-safe collections
        Private Shared ReadOnly safeCounter As New Object()
        Private Shared ReadOnly users As New ConcurrentDictionary(Of String, Integer)()
        
        Sub GoodThreadSafeCollections()
            users.TryAdd("user1", 1) ' Thread-safe operation
            
            SyncLock safeCounter
                counter = counter + 1 ' Properly synchronized
            End SyncLock
        End Sub
        
        ' GOOD: Immutable/readonly fields
        Private Shared ReadOnly maxConnections As Integer = 100
        Private Shared ReadOnly appName As String = "MyApp"
        
        ' GOOD: Const fields (inherently thread-safe)
        Private Const defaultTimeout As Integer = 30000
        Private Const version As String = "1.0.0"
    </script>
</body>
</html>
