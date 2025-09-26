<%@ Page Language="VB" %>
<html>
<head>
    <title>Concurrency Issues Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Concurrency issues - operations on shared data without proper synchronization
        
        ' BAD: Static/Shared fields modified without synchronization
        Private Shared sharedCounter As Integer = 0
        Private Shared sharedList As New List(Of String)()
        Private Shared sharedDictionary As New Dictionary(Of String, String)()
        
        Sub BadConcurrencyExamples()
            ' BAD: Static field operations without synchronization
            sharedCounter += 1 ' Bad: increment without lock
            sharedCounter -= 1 ' Bad: decrement without lock
            sharedCounter *= 2 ' Bad: multiplication without lock
            
            ' BAD: Collection operations without synchronization
            sharedList.Add("item") ' Bad: list modification without lock
            sharedList.Remove("item") ' Bad: list modification without lock
            sharedList.Clear() ' Bad: list clearing without lock
            
            sharedDictionary.Add("key", "value") ' Bad: dictionary modification without lock
            sharedDictionary.Remove("key") ' Bad: dictionary modification without lock
            sharedDictionary.Clear() ' Bad: dictionary clearing without lock
            
            ' BAD: ArrayList operations without synchronization
            Dim sharedArrayList As New ArrayList()
            sharedArrayList.Add("item") ' Bad: ArrayList modification without lock
            sharedArrayList.Remove("item") ' Bad: ArrayList modification without lock
            sharedArrayList.Clear() ' Bad: ArrayList clearing without lock
        End Sub
        
        Sub BadApplicationAndSessionState()
            ' BAD: Application state operations without synchronization
            Application("Counter") = CInt(Application("Counter")) + 1 ' Bad: application state increment without lock
            Application("Total") = CInt(Application("Total")) - 10 ' Bad: application state decrement without lock
            Application("Value") = CInt(Application("Value")) * 2 ' Bad: application state multiplication without lock
            
            ' BAD: Session state operations without synchronization (in shared scenarios)
            Session("UserCount") = CInt(Session("UserCount")) + 1 ' Bad: session increment without lock
            Session("Points") = CInt(Session("Points")) - 5 ' Bad: session decrement without lock
            Session("Score") = CInt(Session("Score")) * 1.5 ' Bad: session multiplication without lock
        End Sub
        
        Sub MoreBadConcurrencyExamples()
            ' BAD: Multiple operations on shared data
            Dim oldValue = sharedCounter ' Bad: read without lock
            sharedCounter = oldValue + 1 ' Bad: write without lock (race condition)
            
            ' BAD: Complex operations without synchronization
            If sharedList.Count > 0 Then ' Bad: check without lock
                sharedList.RemoveAt(0) ' Bad: modification without lock
            End If
            
            ' BAD: Shared resource access without protection
            Dim sharedResource As New SharedResource()
            sharedResource.ProcessData() ' Bad: shared resource access without synchronization
        End Sub
        
        ' GOOD: Proper synchronization for concurrent operations
        
        Private Shared ReadOnly lockObject As New Object()
        Private Shared ReadOnly listLock As New Object()
        Private Shared ReadOnly dictionaryLock As New Object()
        
        Sub GoodConcurrencyWithLocks()
            ' GOOD: Static field operations with synchronization
            SyncLock lockObject
                sharedCounter += 1 ' Good: increment with lock
                sharedCounter -= 1 ' Good: decrement with lock
                sharedCounter *= 2 ' Good: multiplication with lock
            End SyncLock
        End Sub
        
        Sub GoodCollectionOperationsWithLocks()
            ' GOOD: Collection operations with synchronization
            SyncLock listLock
                sharedList.Add("item") ' Good: list modification with lock
                sharedList.Remove("item") ' Good: list modification with lock
                sharedList.Clear() ' Good: list clearing with lock
            End SyncLock
            
            SyncLock dictionaryLock
                sharedDictionary.Add("key", "value") ' Good: dictionary modification with lock
                sharedDictionary.Remove("key") ' Good: dictionary modification with lock
                sharedDictionary.Clear() ' Good: dictionary clearing with lock
            End SyncLock
        End Sub
        
        Sub GoodApplicationStateWithLocks()
            ' GOOD: Application state operations with synchronization
            SyncLock Application.SyncRoot
                Application("Counter") = CInt(Application("Counter")) + 1 ' Good: application state with lock
                Application("Total") = CInt(Application("Total")) - 10 ' Good: application state with lock
                Application("Value") = CInt(Application("Value")) * 2 ' Good: application state with lock
            End SyncLock
        End Sub
        
        Sub GoodInterlockedOperations()
            ' GOOD: Using Interlocked for atomic operations
            Interlocked.Increment(sharedCounter) ' Good: atomic increment
            Interlocked.Decrement(sharedCounter) ' Good: atomic decrement
            Interlocked.Add(sharedCounter, 5) ' Good: atomic addition
            Interlocked.Exchange(sharedCounter, 10) ' Good: atomic exchange
            Interlocked.CompareExchange(sharedCounter, 20, 10) ' Good: atomic compare and exchange
        End Sub
        
        Sub GoodConcurrentCollections()
            ' GOOD: Using thread-safe concurrent collections
            Dim concurrentList As New ConcurrentBag(Of String)()
            concurrentList.Add("item") ' Good: thread-safe collection
            
            Dim concurrentDict As New ConcurrentDictionary(Of String, String)()
            concurrentDict.TryAdd("key", "value") ' Good: thread-safe dictionary
            concurrentDict.TryRemove("key", Nothing) ' Good: thread-safe removal
            
            Dim concurrentQueue As New ConcurrentQueue(Of String)()
            concurrentQueue.Enqueue("item") ' Good: thread-safe queue
            Dim result As String = Nothing
            concurrentQueue.TryDequeue(result) ' Good: thread-safe dequeue
        End Sub
        
        Sub GoodReaderWriterLock()
            ' GOOD: Using ReaderWriterLockSlim for read/write scenarios
            Dim rwLock As New ReaderWriterLockSlim()
            
            ' Read operation
            rwLock.EnterReadLock()
            Try
                Dim count = sharedList.Count ' Good: read with read lock
                ProcessCount(count)
            Finally
                rwLock.ExitReadLock()
            End Try
            
            ' Write operation
            rwLock.EnterWriteLock()
            Try
                sharedList.Add("new item") ' Good: write with write lock
            Finally
                rwLock.ExitWriteLock()
            End Try
        End Sub
        
        Sub GoodMonitorPattern()
            ' GOOD: Using Monitor class for synchronization
            Monitor.Enter(lockObject)
            Try
                sharedCounter += 1 ' Good: Monitor synchronization
                If sharedCounter > 100 Then
                    sharedCounter = 0
                End If
            Finally
                Monitor.Exit(lockObject)
            End Try
        End Sub
        
        Sub GoodVolatileFields()
            ' GOOD: Using volatile fields for simple flags
            ' Note: VB.NET doesn't have volatile keyword, but we can simulate the pattern
            Dim isRunning As Boolean = GetVolatileFlag()
            If isRunning Then
                PerformWork() ' Good: volatile-like access pattern
            End If
        End Sub
        
        Sub GoodThreadSafePatterns()
            ' GOOD: Thread-safe singleton pattern
            Dim instance = ThreadSafeSingleton.Instance ' Good: thread-safe singleton
            instance.DoWork()
            
            ' GOOD: Thread-safe lazy initialization
            Dim lazyResource = New Lazy(Of ExpensiveResource)(Function() New ExpensiveResource()) ' Good: lazy thread-safe
            Dim resource = lazyResource.Value
            resource.Process()
        End Sub
        
        Sub GoodAsyncSynchronization()
            ' GOOD: Using SemaphoreSlim for async synchronization
            Dim semaphore As New SemaphoreSlim(1, 1)
            
            semaphore.Wait() ' Good: semaphore synchronization
            Try
                ProcessSharedResource() ' Good: protected by semaphore
            Finally
                semaphore.Release()
            End Try
        End Sub
        
        Sub GoodThreadLocalStorage()
            ' GOOD: Using ThreadLocal for thread-specific data
            Dim threadLocalData As New ThreadLocal(Of Integer)(Function() 0) ' Good: thread-local storage
            threadLocalData.Value += 1 ' Good: thread-local modification
            ProcessThreadLocalValue(threadLocalData.Value)
        End Sub
        
        Sub GoodImmutableDataStructures()
            ' GOOD: Using immutable data structures
            Dim immutableList = ImmutableList.Create("item1", "item2") ' Good: immutable list
            Dim newList = immutableList.Add("item3") ' Good: returns new immutable list
            ProcessImmutableList(newList)
            
            Dim immutableDict = ImmutableDictionary.Create(Of String, String)() ' Good: immutable dictionary
            Dim newDict = immutableDict.Add("key", "value") ' Good: returns new immutable dictionary
            ProcessImmutableDictionary(newDict)
        End Sub
        
        Sub GoodAtomicOperations()
            ' GOOD: Custom atomic operations
            Dim success As Boolean = False
            Do
                Dim currentValue = sharedCounter
                Dim newValue = currentValue + 1
                success = (Interlocked.CompareExchange(sharedCounter, newValue, currentValue) = currentValue) ' Good: atomic compare-exchange
            Loop While Not success
        End Sub
        
        Sub GoodLockFreeAlgorithms()
            ' GOOD: Lock-free algorithm example
            Dim lockFreeStack As New LockFreeStack(Of String)() ' Good: lock-free data structure
            lockFreeStack.Push("item") ' Good: lock-free operation
            Dim item As String = Nothing
            lockFreeStack.TryPop(item) ' Good: lock-free operation
        End Sub
        
        ' Helper methods and classes
        Sub ProcessCount(count As Integer)
        End Sub
        
        Sub PerformWork()
        End Sub
        
        Sub ProcessSharedResource()
        End Sub
        
        Sub ProcessThreadLocalValue(value As Integer)
        End Sub
        
        Sub ProcessImmutableList(list As ImmutableList(Of String))
        End Sub
        
        Sub ProcessImmutableDictionary(dict As ImmutableDictionary(Of String, String))
        End Sub
        
        Function GetVolatileFlag() As Boolean
            Return True
        End Function
        
        ' Thread-safe singleton example
        Public Class ThreadSafeSingleton
            Private Shared ReadOnly _instance As New Lazy(Of ThreadSafeSingleton)(Function() New ThreadSafeSingleton())
            
            Public Shared ReadOnly Property Instance As ThreadSafeSingleton
                Get
                    Return _instance.Value ' Good: thread-safe lazy initialization
                End Get
            End Property
            
            Private Sub New()
            End Sub
            
            Public Sub DoWork()
            End Sub
        End Class
        
        Public Class ExpensiveResource
            Public Sub Process()
            End Sub
        End Class
        
        Public Class SharedResource
            Public Sub ProcessData()
            End Sub
        End Class
        
        ' Lock-free stack example
        Public Class LockFreeStack(Of T)
            Private head As Node(Of T)
            
            Public Sub Push(item As T)
                Dim newNode As New Node(Of T)(item)
                Do
                    newNode.Next = head
                Loop While Interlocked.CompareExchange(head, newNode, newNode.Next) IsNot newNode.Next ' Good: lock-free push
            End Sub
            
            Public Function TryPop(ByRef result As T) As Boolean
                Dim currentHead As Node(Of T)
                Do
                    currentHead = head
                    If currentHead Is Nothing Then
                        result = Nothing
                        Return False
                    End If
                Loop While Interlocked.CompareExchange(head, currentHead.Next, currentHead) IsNot currentHead ' Good: lock-free pop
                
                result = currentHead.Value
                Return True
            End Function
            
            Private Class Node(Of TNode)
                Public Property Value As TNode
                Public Property [Next] As Node(Of TNode)
                
                Public Sub New(value As TNode)
                    Me.Value = value
                End Sub
            End Class
        End Class
    </script>
</body>
</html>
