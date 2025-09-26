<%@ Page Language="VB" %>
<html>
<head>
    <title>Deadlock Potential Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Deadlock potential - nested locks and improper lock ordering
        Private Shared lockA As New Object()
        Private Shared lockB As New Object()
        Private Shared resource1 As New Object()
        Private Shared resource2 As New Object()
        
        Sub BadNestedLocks1()
            ' BAD: Nested locks - deadlock potential
            SyncLock lockA
                Thread.Sleep(100) ' Holding lock while sleeping
                SyncLock lockB ' Nested lock - deadlock risk
                    ProcessData()
                End SyncLock
            End SyncLock
        End Sub
        
        Sub BadNestedLocks2()
            ' BAD: Reverse lock order - deadlock potential
            SyncLock lockB
                SyncLock lockA ' Different order from above method
                    ProcessData()
                End SyncLock
            End SyncLock
        End Sub
        
        Sub BadMonitorUsage()
            ' BAD: Nested Monitor.Enter calls
            Monitor.Enter(resource1)
            Try
                Monitor.Enter(resource2) ' Nested monitor - deadlock risk
                Try
                    ProcessResource()
                Finally
                    Monitor.Exit(resource2)
                End Try
            Finally
                Monitor.Exit(resource1)
            End Try
        End Sub
        
        Sub BadMutexUsage()
            Dim mutex1 As New Mutex(False, "Mutex1")
            Dim mutex2 As New Mutex(False, "Mutex2")
            
            ' BAD: Nested mutex waits
            mutex1.WaitOne()
            Try
                mutex2.WaitOne() ' Nested mutex - deadlock risk
                Try
                    ProcessData()
                Finally
                    mutex2.ReleaseMutex()
                End Try
            Finally
                mutex1.ReleaseMutex()
            End Try
        End Sub
        
        Sub BadLockWithSleep()
            ' BAD: Holding lock while sleeping
            SyncLock lockA
                Thread.Sleep(5000) ' Bad: sleeping while holding lock
                ProcessData()
            End SyncLock
        End Sub
        
        Async Function BadLockWithDelay() As Task
            ' BAD: Holding lock with Task.Delay
            SyncLock lockA
                Await Task.Delay(1000) ' Bad: async delay while holding lock
                ProcessData()
            End SyncLock
        End Function
        
        ' GOOD: Proper lock usage without nesting
        Sub GoodSingleLockUsage()
            ' GOOD: Single lock, no nesting
            SyncLock lockA
                ProcessData()
            End SyncLock
        End Sub
        
        Sub GoodConsistentLockOrdering()
            ' GOOD: Always acquire locks in same order
            SyncLock lockA
                ' Process with lockA only
                ProcessDataA()
            End SyncLock
            
            ' Separate lock usage
            SyncLock lockB
                ProcessDataB()
            End SyncLock
        End Sub
        
        Sub GoodMonitorUsage()
            ' GOOD: Single Monitor usage
            Monitor.Enter(resource1)
            Try
                ProcessResource()
            Finally
                Monitor.Exit(resource1)
            End Try
        End Sub
        
        Sub GoodTimeoutLocks()
            ' GOOD: Using timeouts to avoid deadlocks
            If Monitor.TryEnter(resource1, TimeSpan.FromSeconds(1)) Then
                Try
                    ProcessResource()
                Finally
                    Monitor.Exit(resource1)
                End Try
            End If
        End Sub
        
        Async Function GoodAsyncWithoutLocks() As Task
            ' GOOD: No locks in async methods
            Await ProcessDataAsync()
        End Function
        
        Sub GoodShortLockScope()
            ' GOOD: Minimal lock scope
            Dim data As Object
            
            SyncLock lockA
                data = GetDataQuickly() ' Quick operation
            End SyncLock
            
            ' Process data outside of lock
            ProcessDataOutsideLock(data)
        End Sub
        
        ' Helper methods
        Sub ProcessData()
        End Sub
        
        Sub ProcessDataA()
        End Sub
        
        Sub ProcessDataB()
        End Sub
        
        Sub ProcessResource()
        End Sub
        
        Async Function ProcessDataAsync() As Task
            Await Task.Delay(100)
        End Function
        
        Function GetDataQuickly() As Object
            Return Nothing
        End Function
        
        Sub ProcessDataOutsideLock(data As Object)
        End Sub
    </script>
</body>
</html>
