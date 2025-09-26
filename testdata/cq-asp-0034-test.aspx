<%@ Page Language="VB" %>
<html>
<head>
    <title>Inappropriate Lock Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inappropriate lock usage
        Sub BadLockOnThis()
            ' BAD: Locking on 'this' - can cause external deadlocks
            SyncLock Me
                ProcessData()
            End SyncLock
        End Sub
        
        Sub BadLockOnType()
            ' BAD: Locking on type - can cause cross-application deadlocks
            SyncLock GetType(String)
                ProcessStringData()
            End SyncLock
            
            ' BAD: Another type lock
            SyncLock GetType(Integer)
                ProcessIntegerData()
            End SyncLock
        End Sub
        
        Sub BadLongLockScope()
            ' BAD: Very long lock scope - reduces concurrency
            SyncLock lockObject
                ' Start of long operation
                Dim data = LoadLargeDataSet()
                ProcessComplexCalculations(data)
                ValidateAllData(data)
                SaveToDatabase(data)
                GenerateReports(data)
                SendNotifications()
                CleanupTempFiles()
                UpdateStatistics()
                LogOperationComplete()
                ' This lock is held way too long - bad for performance
            End SyncLock
        End Sub
        
        Function BadFunctionWithLongLock() As String
            ' BAD: Long lock in function
            SyncLock lockObject
                Dim result = ""
                For i = 1 To 1000
                    result += ProcessItem(i).ToString()
                    Thread.Sleep(10) ' Simulating work while holding lock
                Next
                Return result ' Long operation under lock
            End SyncLock
        End Function
        
        Sub BadNestedLongLock()
            ' BAD: Nested operations with long lock
            SyncLock lockObject
                If CheckCondition1() Then
                    If CheckCondition2() Then
                        If CheckCondition3() Then
                            ProcessNestedOperation()
                            For Each item In GetLargeCollection()
                                ProcessItemWithDelay(item)
                            Next
                        End If
                    End If
                End If
            End SyncLock
        End Sub
        
        ' GOOD: Proper lock usage
        Private Shared ReadOnly lockObject As New Object()
        Private Shared ReadOnly dataLock As New Object()
        Private Shared ReadOnly fileLock As New Object()
        
        Sub GoodLockOnPrivateObject()
            ' GOOD: Locking on private object
            SyncLock lockObject
                ProcessData()
            End SyncLock
        End Sub
        
        Sub GoodShortLockScope()
            ' GOOD: Minimal lock scope
            Dim data As Object
            Dim processed As Object
            
            ' Prepare data outside lock
            data = PrepareData()
            
            ' Short critical section
            SyncLock dataLock
                processed = ProcessCriticalSection(data)
            End SyncLock
            
            ' Continue processing outside lock
            FinalizeData(processed)
        End Sub
        
        Function GoodFunctionWithMinimalLock() As String
            ' GOOD: Minimal lock scope in function
            Dim result As String
            
            ' Do most work outside lock
            Dim processedData = ProcessDataOutsideLock()
            
            ' Only critical section under lock
            SyncLock lockObject
                result = GetCriticalValue(processedData)
            End SyncLock
            
            Return result
        End Function
        
        Sub GoodSeparateLocks()
            ' GOOD: Using separate locks for different resources
            SyncLock dataLock
                ProcessDataResource()
            End SyncLock
            
            SyncLock fileLock
                ProcessFileResource()
            End SyncLock
        End Sub
        
        Sub GoodLockFreeAlternatives()
            ' GOOD: Using lock-free alternatives where possible
            Interlocked.Increment(counter)
            Interlocked.Exchange(status, 1)
            
            ' GOOD: Using concurrent collections
            concurrentDict.TryAdd("key", "value")
            concurrentQueue.TryDequeue(item)
        End Sub
        
        Sub GoodTryLockPattern()
            ' GOOD: Using try-lock pattern with timeout
            If Monitor.TryEnter(lockObject, TimeSpan.FromMilliseconds(100)) Then
                Try
                    ProcessData()
                Finally
                    Monitor.Exit(lockObject)
                End Try
            Else
                ' Handle timeout case
                HandleLockTimeout()
            End If
        End Sub
        
        ' GOOD: Reader-writer locks for read-heavy scenarios
        Private Shared ReadOnly readerWriterLock As New ReaderWriterLockSlim()
        
        Function GoodReaderLock() As String
            readerWriterLock.EnterReadLock()
            Try
                Return ReadSharedData()
            Finally
                readerWriterLock.ExitReadLock()
            End Try
        End Function
        
        Sub GoodWriterLock()
            readerWriterLock.EnterWriteLock()
            Try
                WriteSharedData()
            Finally
                readerWriterLock.ExitWriteLock()
            End Try
        End Sub
        
        ' Helper methods and fields
        Private Shared counter As Integer
        Private Shared status As Integer
        Private Shared concurrentDict As New ConcurrentDictionary(Of String, String)()
        Private Shared concurrentQueue As New ConcurrentQueue(Of Object)()
        Private item As Object
        
        Sub ProcessData()
        End Sub
        
        Sub ProcessStringData()
        End Sub
        
        Sub ProcessIntegerData()
        End Sub
        
        Function LoadLargeDataSet() As Object
            Return Nothing
        End Function
        
        Sub ProcessComplexCalculations(data As Object)
        End Sub
        
        Sub ValidateAllData(data As Object)
        End Sub
        
        Sub SaveToDatabase(data As Object)
        End Sub
        
        Sub GenerateReports(data As Object)
        End Sub
        
        Sub SendNotifications()
        End Sub
        
        Sub CleanupTempFiles()
        End Sub
        
        Sub UpdateStatistics()
        End Sub
        
        Sub LogOperationComplete()
        End Sub
        
        Function ProcessItem(i As Integer) As Integer
            Return i
        End Function
        
        Function CheckCondition1() As Boolean
            Return True
        End Function
        
        Function CheckCondition2() As Boolean
            Return True
        End Function
        
        Function CheckCondition3() As Boolean
            Return True
        End Function
        
        Sub ProcessNestedOperation()
        End Sub
        
        Function GetLargeCollection() As List(Of Object)
            Return New List(Of Object)()
        End Function
        
        Sub ProcessItemWithDelay(item As Object)
            Thread.Sleep(1)
        End Sub
        
        Function PrepareData() As Object
            Return Nothing
        End Function
        
        Function ProcessCriticalSection(data As Object) As Object
            Return data
        End Function
        
        Sub FinalizeData(data As Object)
        End Sub
        
        Function ProcessDataOutsideLock() As Object
            Return Nothing
        End Function
        
        Function GetCriticalValue(data As Object) As String
            Return ""
        End Function
        
        Sub ProcessDataResource()
        End Sub
        
        Sub ProcessFileResource()
        End Sub
        
        Sub HandleLockTimeout()
        End Sub
        
        Function ReadSharedData() As String
            Return ""
        End Function
        
        Sub WriteSharedData()
        End Sub
    </script>
</body>
</html>
