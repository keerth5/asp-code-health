<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Volatile Keyword Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing volatile keyword for fields accessed by multiple threads
        
        ' BAD: Boolean flags without volatile
        Private Shared stopFlag As Boolean = False ' Should be volatile
        Public Shared cancelFlag As Boolean = False ' Should be volatile
        Private Shared doneFlag As Boolean = False ' Should be volatile
        Protected Shared readyFlag As Boolean = False ' Should be volatile
        Private Shared isRunning As Boolean = False ' Should be volatile
        Public Shared isActive As Boolean = False ' Should be volatile
        Private Shared isEnabled As Boolean = False ' Should be volatile
        
        ' BAD: Status/counter fields that might be accessed by threads
        Private Shared statusCount As Integer = 0 ' Should be volatile if accessed by threads
        Public Shared indexCount As Integer = 0 ' Should be volatile if accessed by threads
        Private Shared threadStatus As Integer = 0 ' Should be volatile
        
        Sub BadNonVolatileUsage()
            ' BAD: Setting flags without volatile
            stopFlag = True ' Visibility not guaranteed across threads
            cancelFlag = True ' Visibility not guaranteed
            doneFlag = True ' Visibility not guaranteed
            
            ' BAD: Reading flags without volatile
            If Not readyFlag Then
                StartProcessing()
            End If
            
            If isRunning Then
                StopProcessing()
            End If
        End Sub
        
        Function BadStatusCheck() As Boolean
            ' BAD: Reading status without volatile
            Return isActive AndAlso isEnabled
        End Function
        
        Sub BadCounterAccess()
            ' BAD: Accessing counters without volatile (if used across threads)
            statusCount += 1 ' Should use volatile or proper synchronization
            indexCount = threadStatus + 1 ' Reading/writing without volatile
        End Sub
        
        ' More BAD examples
        Private Shared processingFlag As Boolean ' Should be volatile
        Public Shared completedFlag As Boolean ' Should be volatile
        Private Shared runningStatus As Integer ' Should be volatile
        
        Sub BadThreadCommunication()
            ' Thread 1 might set these
            processingFlag = True
            completedFlag = False
            runningStatus = 1
            
            ' Thread 2 might read these - visibility issues without volatile
            While processingFlag
                Thread.Sleep(100)
            End While
        End Sub
        
        ' GOOD: Proper volatile usage
        Private Shared Volatile goodStopFlag As Boolean = False
        Public Shared Volatile goodCancelFlag As Boolean = False
        Private Shared Volatile goodDoneFlag As Boolean = False
        Protected Shared Volatile goodReadyFlag As Boolean = False
        Private Shared Volatile goodIsRunning As Boolean = False
        Public Shared Volatile goodIsActive As Boolean = False
        Private Shared Volatile goodIsEnabled As Boolean = False
        
        ' GOOD: Volatile for simple status indicators
        Private Shared Volatile goodStatusCount As Integer = 0
        Public Shared Volatile goodIndexCount As Integer = 0
        Private Shared Volatile goodThreadStatus As Integer = 0
        
        Sub GoodVolatileUsage()
            ' GOOD: Setting volatile flags
            goodStopFlag = True ' Visibility guaranteed across threads
            goodCancelFlag = True ' Visibility guaranteed
            goodDoneFlag = True ' Visibility guaranteed
            
            ' GOOD: Reading volatile flags
            If Not goodReadyFlag Then
                StartProcessing()
            End If
            
            If goodIsRunning Then
                StopProcessing()
            End If
        End Sub
        
        Function GoodStatusCheck() As Boolean
            ' GOOD: Reading volatile status
            Return goodIsActive AndAlso goodIsEnabled
        End Function
        
        Sub GoodCounterAccess()
            ' GOOD: For simple increments, use Interlocked instead
            Interlocked.Increment(goodStatusCount)
            Interlocked.Exchange(goodThreadStatus, 1)
            
            ' GOOD: Reading volatile fields
            Dim currentStatus = goodThreadStatus
        End Sub
        
        ' GOOD: Using proper synchronization instead of volatile for complex operations
        Private Shared ReadOnly counterLock As New Object()
        Private Shared complexCounter As Integer = 0
        
        Sub GoodSynchronizedCounter()
            ' GOOD: Using locks for complex operations
            SyncLock counterLock
                complexCounter += 1
            End SyncLock
        End Sub
        
        ' GOOD: Constants don't need volatile (they're immutable)
        Private Const maxRetries As Integer = 3
        Private Const timeoutMs As Integer = 5000
        
        ' GOOD: ReadOnly fields set once don't need volatile
        Private Shared ReadOnly configPath As String = "config.xml"
        Private Shared ReadOnly maxConnections As Integer = 100
        
        ' GOOD: Thread-safe collections don't need volatile
        Private Shared ReadOnly threadSafeDict As New ConcurrentDictionary(Of String, Integer)()
        Private Shared ReadOnly threadSafeQueue As New ConcurrentQueue(Of String)()
        
        Sub GoodThreadSafeCollections()
            threadSafeDict.TryAdd("key", 1)
            Dim value As String
            threadSafeQueue.TryDequeue(value)
        End Sub
        
        ' GOOD: Using CancellationToken instead of volatile flags
        Sub GoodCancellationPattern(cancellationToken As CancellationToken)
            While Not cancellationToken.IsCancellationRequested
                ProcessWork()
                
                ' Check cancellation periodically
                cancellationToken.ThrowIfCancellationRequested()
            End While
        End Sub
        
        ' GOOD: Using ManualResetEvent for thread coordination
        Private Shared ReadOnly resetEvent As New ManualResetEventSlim(False)
        
        Sub GoodEventBasedCoordination()
            ' Signal other threads
            resetEvent.Set()
            
            ' Wait for signal
            resetEvent.Wait()
        End Sub
        
        ' Helper methods
        Sub StartProcessing()
        End Sub
        
        Sub StopProcessing()
        End Sub
        
        Sub ProcessWork()
        End Sub
    </script>
</body>
</html>
