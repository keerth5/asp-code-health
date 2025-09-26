<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Memory Barriers Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing memory barriers - shared memory access without appropriate memory barriers or locks
        
        ' BAD: Static boolean flags without volatile or synchronization
        Class BadFlagManager
            ' BAD: Static boolean without volatile keyword
            Private Shared isReady As Boolean = False
            Private Shared isDone As Boolean = False
            Private Shared processingFlag As Boolean = False
            
            Public Shared Sub SetReady()
                ' BAD: Setting flag without memory barrier
                isReady = True
            End Sub
            
            Public Shared Function IsReady() As Boolean
                ' BAD: Reading flag without memory barrier
                Return isReady
            End Function
            
            Public Shared Sub MarkDone()
                ' BAD: Setting flag without synchronization
                isDone = True
            End Sub
            
            Public Shared Sub WaitForCompletion()
                ' BAD: Busy wait without memory barrier
                While Not isDone
                    Thread.Sleep(10)
                End While
            End Sub
            
            Public Shared Sub StartProcessing()
                ' BAD: Flag manipulation without synchronization
                If Not processingFlag Then
                    processingFlag = True
                    DoProcessing()
                    processingFlag = False
                End If
            End Sub
        End Class
        
        ' BAD: Shared variables without proper synchronization
        Class BadSharedCounter
            ' BAD: Shared variables without volatile or Interlocked
            Private Shared counter As Integer = 0
            Private Shared maxValue As Integer = 100
            Private Shared isInitialized As Boolean = False
            
            Public Shared Sub Increment()
                ' BAD: Non-atomic increment
                counter = counter + 1
            End Sub
            
            Public Shared Sub Decrement()
                ' BAD: Non-atomic decrement
                counter = counter - 1
            End Sub
            
            Public Shared Function GetValue() As Integer
                ' BAD: Reading shared value without synchronization
                Return counter
            End Function
            
            Public Shared Sub Initialize()
                ' BAD: Initialization check without proper synchronization
                If Not isInitialized Then
                    maxValue = 1000
                    counter = 0
                    isInitialized = True
                End If
            End Sub
        End Class
        
        ' BAD: Double-checked locking without proper memory barriers
        Class BadSingleton
            Private Shared instance As BadSingleton
            Private Shared ReadOnly lockObject As New Object()
            
            Public Shared Function GetInstance() As BadSingleton
                ' BAD: First check without memory barrier
                If instance Is Nothing Then
                    SyncLock lockObject
                        ' BAD: Second check might see partially constructed object
                        If instance Is Nothing Then
                            instance = New BadSingleton()
                        End If
                    End SyncLock
                End If
                Return instance
            End Function
        End Class
        
        ' BAD: Producer-consumer without proper memory barriers
        Class BadProducerConsumer
            Private Shared data As String
            Private Shared dataReady As Boolean = False
            
            Public Shared Sub Producer()
                ' BAD: Setting data and flag without memory barrier
                data = "Important Data"
                dataReady = True
            End Sub
            
            Public Shared Function Consumer() As String
                ' BAD: Checking flag and reading data without memory barrier
                While Not dataReady
                    Thread.Sleep(1)
                End While
                Return data
            End Function
        End Class
        
        ' BAD: Cache invalidation without memory barriers
        Class BadCache
            Private Shared cache As Dictionary(Of String, Object)
            Private Shared cacheValid As Boolean = True
            
            Shared Sub New()
                cache = New Dictionary(Of String, Object)()
            End Sub
            
            Public Shared Sub InvalidateCache()
                ' BAD: Invalidating cache without memory barrier
                cache.Clear()
                cacheValid = False
            End Sub
            
            Public Shared Function GetValue(key As String) As Object
                ' BAD: Checking validity and accessing cache without synchronization
                If Not cacheValid Then
                    Return Nothing
                End If
                
                If cache.ContainsKey(key) Then
                    Return cache(key)
                End If
                
                Return Nothing
            End Function
        End Class
        
        ' GOOD: Proper memory barriers and synchronization
        
        ' GOOD: Using volatile fields for flags
        Class GoodFlagManager
            ' GOOD: Volatile fields for shared flags
            Private Shared Volatile isReady As Boolean = False
            Private Shared Volatile isDone As Boolean = False
            Private Shared Volatile processingFlag As Boolean = False
            
            Public Shared Sub SetReady()
                ' GOOD: Volatile write provides memory barrier
                isReady = True
            End Sub
            
            Public Shared Function IsReady() As Boolean
                ' GOOD: Volatile read provides memory barrier
                Return isReady
            End Function
            
            Public Shared Sub MarkDone()
                ' GOOD: Volatile write with memory barrier
                isDone = True
            End Sub
            
            Public Shared Sub WaitForCompletion()
                ' GOOD: Volatile read in loop
                While Not isDone
                    Thread.Sleep(10)
                End While
            End Sub
            
            Public Shared Sub StartProcessing()
                ' GOOD: Using Interlocked for atomic operations
                If Interlocked.CompareExchange(processingFlag, True, False) = False Then
                    Try
                        DoProcessing()
                    Finally
                        processingFlag = False
                    End Try
                End If
            End Sub
        End Class
        
        ' GOOD: Using Interlocked operations for shared counters
        Class GoodSharedCounter
            ' GOOD: Using Interlocked operations instead of simple assignment
            Private Shared counter As Integer = 0
            Private Shared Volatile maxValue As Integer = 100
            Private Shared Volatile isInitialized As Boolean = False
            
            Public Shared Sub Increment()
                ' GOOD: Atomic increment
                Interlocked.Increment(counter)
            End Sub
            
            Public Shared Sub Decrement()
                ' GOOD: Atomic decrement
                Interlocked.Decrement(counter)
            End Sub
            
            Public Shared Function GetValue() As Integer
                ' GOOD: Volatile read
                Return Interlocked.Read(counter)
            End Function
            
            Public Shared Sub Initialize()
                ' GOOD: Using Interlocked for initialization check
                If Interlocked.CompareExchange(isInitialized, True, False) = False Then
                    maxValue = 1000
                    Interlocked.Exchange(counter, 0)
                End If
            End Sub
        End Class
        
        ' GOOD: Proper double-checked locking with volatile
        Class GoodSingleton
            Private Shared Volatile instance As GoodSingleton
            Private Shared ReadOnly lockObject As New Object()
            
            Public Shared Function GetInstance() As GoodSingleton
                ' GOOD: First check with volatile read
                If instance Is Nothing Then
                    SyncLock lockObject
                        ' GOOD: Second check with volatile read
                        If instance Is Nothing Then
                            instance = New GoodSingleton()
                        End If
                    End SyncLock
                End If
                Return instance
            End Function
        End Class
        
        ' GOOD: Producer-consumer with proper memory barriers
        Class GoodProducerConsumer
            Private Shared Volatile data As String
            Private Shared Volatile dataReady As Boolean = False
            
            Public Shared Sub Producer()
                ' GOOD: Set data first, then flag with memory barrier
                data = "Important Data"
                Memory.MemoryBarrier() ' Ensure data is written before flag
                dataReady = True
            End Sub
            
            Public Shared Function Consumer() As String
                ' GOOD: Check flag first, then read data with memory barrier
                While Not dataReady
                    Thread.Sleep(1)
                End While
                Memory.MemoryBarrier() ' Ensure flag is read before data
                Return data
            End Function
        End Class
        
        ' GOOD: Thread-safe cache with proper synchronization
        Class GoodCache
            Private Shared ReadOnly cache As New ConcurrentDictionary(Of String, Object)()
            Private Shared Volatile cacheValid As Boolean = True
            
            Public Shared Sub InvalidateCache()
                ' GOOD: Clear cache and set flag atomically
                cache.Clear()
                cacheValid = False
            End Sub
            
            Public Shared Function GetValue(key As String) As Object
                ' GOOD: Check validity with volatile read
                If Not cacheValid Then
                    Return Nothing
                End If
                
                ' GOOD: Thread-safe dictionary access
                Dim value As Object = Nothing
                cache.TryGetValue(key, value)
                Return value
            End Function
            
            Public Shared Sub SetValue(key As String, value As Object)
                ' GOOD: Thread-safe dictionary operations
                If cacheValid Then
                    cache.TryAdd(key, value)
                End If
            End Sub
        End Class
        
        ' GOOD: Using Memory.MemoryBarrier() explicitly
        Class GoodMemoryBarrierExample
            Private Shared data1 As Integer
            Private Shared data2 As Integer
            Private Shared Volatile publishedFlag As Boolean = False
            
            Public Shared Sub Publisher()
                ' GOOD: Set data first
                data1 = 42
                data2 = 84
                
                ' GOOD: Memory barrier ensures data writes complete before flag
                Memory.MemoryBarrier()
                publishedFlag = True
            End Sub
            
            Public Shared Function Consumer() As (Integer, Integer)
                ' GOOD: Wait for flag
                While Not publishedFlag
                    Thread.Sleep(1)
                End While
                
                ' GOOD: Memory barrier ensures flag read completes before data reads
                Memory.MemoryBarrier()
                Return (data1, data2)
            End Function
        End Class
        
        ' GOOD: Using ReaderWriterLockSlim for complex synchronization
        Class GoodReaderWriterExample
            Private Shared ReadOnly rwLock As New ReaderWriterLockSlim()
            Private Shared data As Dictionary(Of String, String)
            
            Shared Sub New()
                data = New Dictionary(Of String, String)()
            End Sub
            
            Public Shared Function ReadValue(key As String) As String
                ' GOOD: Use read lock for concurrent reads
                rwLock.EnterReadLock()
                Try
                    If data.ContainsKey(key) Then
                        Return data(key)
                    End If
                    Return Nothing
                Finally
                    rwLock.ExitReadLock()
                End Try
            End Function
            
            Public Shared Sub WriteValue(key As String, value As String)
                ' GOOD: Use write lock for exclusive writes
                rwLock.EnterWriteLock()
                Try
                    data(key) = value
                Finally
                    rwLock.ExitWriteLock()
                End Try
            End Sub
        End Class
        
        ' GOOD: Using ManualResetEventSlim for signaling
        Class GoodSignalingExample
            Private Shared ReadOnly resetEvent As New ManualResetEventSlim(False)
            Private Shared Volatile result As String
            
            Public Shared Sub SignalCompletion(completionResult As String)
                ' GOOD: Set result then signal
                result = completionResult
                resetEvent.Set()
            End Sub
            
            Public Shared Function WaitForCompletion() As String
                ' GOOD: Wait for signal then read result
                resetEvent.Wait()
                Return result
            End Function
        End Class
        
        ' GOOD: Using Lazy(Of T) for thread-safe initialization
        Class GoodLazyInitialization
            Private Shared ReadOnly lazyValue As New Lazy(Of ExpensiveObject)(Function() New ExpensiveObject())
            
            Public Shared ReadOnly Property Value As ExpensiveObject
                Get
                    ' GOOD: Thread-safe lazy initialization
                    Return lazyValue.Value
                End Get
            End Property
        End Class
        
        ' Supporting classes and methods
        Class Thread
            Public Shared Sub Sleep(milliseconds As Integer)
            End Sub
        End Class
        
        Class Interlocked
            Public Shared Function CompareExchange(ByRef location As Boolean, value As Boolean, comparand As Boolean) As Boolean
                Return comparand
            End Function
            
            Public Shared Function CompareExchange(ByRef location As Integer, value As Integer, comparand As Integer) As Integer
                Return comparand
            End Function
            
            Public Shared Function Increment(ByRef location As Integer) As Integer
                Return location + 1
            End Function
            
            Public Shared Function Decrement(ByRef location As Integer) As Integer
                Return location - 1
            End Function
            
            Public Shared Function Exchange(ByRef location As Integer, value As Integer) As Integer
                Return location
            End Function
            
            Public Shared Function Read(ByRef location As Integer) As Integer
                Return location
            End Function
        End Class
        
        Class Memory
            Public Shared Sub MemoryBarrier()
                ' Memory barrier implementation
            End Sub
        End Class
        
        Class ConcurrentDictionary(Of TKey, TValue)
            Public Sub Clear()
            End Sub
            
            Public Function TryGetValue(key As TKey, ByRef value As TValue) As Boolean
                value = Nothing
                Return False
            End Function
            
            Public Function TryAdd(key As TKey, value As TValue) As Boolean
                Return True
            End Function
        End Class
        
        Class ReaderWriterLockSlim
            Implements IDisposable
            
            Public Sub EnterReadLock()
            End Sub
            
            Public Sub ExitReadLock()
            End Sub
            
            Public Sub EnterWriteLock()
            End Sub
            
            Public Sub ExitWriteLock()
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class ManualResetEventSlim
            Implements IDisposable
            
            Public Sub New(initialState As Boolean)
            End Sub
            
            Public Sub [Set]()
            End Sub
            
            Public Sub Wait()
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class Lazy(Of T)
            Private factory As Func(Of T)
            
            Public Sub New(valueFactory As Func(Of T))
                factory = valueFactory
            End Sub
            
            Public ReadOnly Property Value As T
                Get
                    Return factory()
                End Get
            End Property
        End Class
        
        Class ExpensiveObject
            Public Sub New()
                ' Simulate expensive initialization
            End Sub
        End Class
        
        ' Helper methods
        Shared Sub DoProcessing()
            ' Simulate processing work
        End Sub
    </script>
</body>
</html>
