<%@ Page Language="VB" %>
<html>
<head>
    <title>Unsafe Thread Operations Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Unsafe thread operations on shared collections
        Private Shared userList As New List(Of String)()
        Private Shared userDict As New Dictionary(Of String, Integer)()
        Private Shared itemArrayList As New ArrayList()
        Private Shared cacheHashtable As New Hashtable()
        
        Sub BadUnsafeCollectionOperations()
            ' BAD: Unsafe operations on shared collections
            userList.Add("newuser") ' Not thread-safe
            userList.Remove("olduser") ' Not thread-safe
            userList.Clear() ' Not thread-safe
            userList.Insert(0, "firstuser") ' Not thread-safe
            
            userDict.Add("key1", 100) ' Not thread-safe
            userDict.Remove("key2") ' Not thread-safe
            userDict.Clear() ' Not thread-safe
            
            itemArrayList.Add("item") ' Not thread-safe
            itemArrayList.Remove("olditem") ' Not thread-safe
            itemArrayList.Clear() ' Not thread-safe
            
            cacheHashtable.Add("cachekey", "value") ' Not thread-safe
            cacheHashtable.Remove("oldkey") ' Not thread-safe
            cacheHashtable.Clear() ' Not thread-safe
        End Sub
        
        Function BadUnsafeAccess() As Integer
            ' BAD: Unsafe access to shared collections
            Return userList.Count + userDict.Count ' Reading without synchronization
        End Function
        
        Sub BadStaticCollectionModification()
            ' BAD: Modifying static collections without synchronization
            Shared productList As New List(Of String)()
            Shared orderDict As New Dictionary(Of Integer, String)()
            
            productList.Add("product1") ' Unsafe on static collection
            productList.Remove("product2") ' Unsafe on static collection
            orderDict.Add(1, "order1") ' Unsafe on static dictionary
            orderDict.Remove(2) ' Unsafe on static dictionary
        End Sub
        
        Sub BadIterationWithModification()
            ' BAD: Modifying collection during iteration
            For Each user In userList
                If user.StartsWith("temp") Then
                    userList.Remove(user) ' Unsafe modification during iteration
                End If
            Next
            
            For Each kvp In userDict
                If kvp.Value < 0 Then
                    userDict.Remove(kvp.Key) ' Unsafe modification during iteration
                End If
            Next
        End Sub
        
        Sub BadConcurrentModification()
            ' BAD: Multiple operations without synchronization
            If userList.Count > 0 Then
                userList.RemoveAt(0) ' Race condition: count might change between check and remove
            End If
            
            If userDict.ContainsKey("test") Then
                userDict.Remove("test") ' Race condition: key might be removed by another thread
            End If
        End Sub
        
        Async Sub BadAsyncUnsafeOperations()
            ' BAD: Unsafe operations in async context
            Await Task.Run(Sub()
                               userList.Add("asyncuser") ' Unsafe in parallel task
                               userDict.Add("asynckey", 1) ' Unsafe in parallel task
                           End Sub)
        End Sub
        
        ' GOOD: Thread-safe alternatives
        Private Shared ReadOnly safeUserList As New ConcurrentBag(Of String)()
        Private Shared ReadOnly safeUserDict As New ConcurrentDictionary(Of String, Integer)()
        Private Shared ReadOnly safeQueue As New ConcurrentQueue(Of String)()
        Private Shared ReadOnly safeStack As New ConcurrentStack(Of String)()
        
        Sub GoodThreadSafeOperations()
            ' GOOD: Using thread-safe collections
            safeUserList.Add("newuser") ' Thread-safe
            safeUserDict.TryAdd("key1", 100) ' Thread-safe
            safeUserDict.TryRemove("key2", Nothing) ' Thread-safe
            
            safeQueue.Enqueue("item") ' Thread-safe
            Dim item As String
            safeQueue.TryDequeue(item) ' Thread-safe
            
            safeStack.Push("stackitem") ' Thread-safe
            safeStack.TryPop(item) ' Thread-safe
        End Sub
        
        ' GOOD: Proper synchronization for non-thread-safe collections
        Private Shared ReadOnly listLock As New Object()
        Private Shared ReadOnly dictLock As New Object()
        
        Sub GoodSynchronizedOperations()
            ' GOOD: Synchronized access to non-thread-safe collections
            SyncLock listLock
                userList.Add("newuser") ' Safe with lock
                userList.Remove("olduser") ' Safe with lock
            End SyncLock
            
            SyncLock dictLock
                userDict.Add("key1", 100) ' Safe with lock
                userDict.Remove("key2") ' Safe with lock
            End SyncLock
        End Sub
        
        Function GoodSynchronizedRead() As Integer
            ' GOOD: Synchronized reading
            Dim count As Integer
            SyncLock listLock
                count = userList.Count ' Safe read with lock
            End SyncLock
            Return count
        End Function
        
        Sub GoodSafeIteration()
            ' GOOD: Safe iteration with copy
            Dim usersCopy As New List(Of String)()
            
            SyncLock listLock
                usersCopy.AddRange(userList) ' Create safe copy
            End SyncLock
            
            ' Iterate over copy (safe)
            For Each user In usersCopy
                ProcessUser(user)
            Next
        End Sub
        
        Sub GoodSafeModificationDuringIteration()
            ' GOOD: Safe modification pattern
            Dim usersToRemove As New List(Of String)()
            
            ' First pass: identify items to remove
            SyncLock listLock
                For Each user In userList
                    If user.StartsWith("temp") Then
                        usersToRemove.Add(user)
                    End If
                Next
            End SyncLock
            
            ' Second pass: remove items safely
            SyncLock listLock
                For Each user In usersToRemove
                    userList.Remove(user)
                Next
            End SyncLock
        End Sub
        
        Sub GoodAtomicOperations()
            ' GOOD: Using atomic operations where appropriate
            Dim counter As Integer = 0
            Interlocked.Increment(counter) ' Atomic increment
            Interlocked.Decrement(counter) ' Atomic decrement
            Interlocked.Exchange(counter, 10) ' Atomic exchange
            Interlocked.CompareExchange(counter, 20, 10) ' Atomic compare-and-swap
        End Sub
        
        Sub GoodReaderWriterLock()
            ' GOOD: Using ReaderWriterLockSlim for read-heavy scenarios
            Dim readerWriterLock As New ReaderWriterLockSlim()
            
            ' Reading (multiple readers allowed)
            readerWriterLock.EnterReadLock()
            Try
                Dim count = userList.Count ' Safe read
            Finally
                readerWriterLock.ExitReadLock()
            End Try
            
            ' Writing (exclusive access)
            readerWriterLock.EnterWriteLock()
            Try
                userList.Add("newuser") ' Safe write
            Finally
                readerWriterLock.ExitWriteLock()
            End Try
        End Sub
        
        Async Function GoodAsyncSafeOperations() As Task
            ' GOOD: Using thread-safe collections in async context
            Await Task.Run(Sub()
                               safeUserList.Add("asyncuser") ' Safe in parallel task
                               safeUserDict.TryAdd("asynckey", 1) ' Safe in parallel task
                           End Sub)
        End Function
        
        Sub GoodImmutableCollections()
            ' GOOD: Using immutable collections
            Dim immutableList = ImmutableList.Create("item1", "item2", "item3")
            Dim immutableDict = ImmutableDictionary.Create(Of String, Integer)()
            
            ' These operations return new instances (thread-safe)
            Dim newList = immutableList.Add("item4")
            Dim newDict = immutableDict.Add("key", 1)
        End Sub
        
        ' Helper methods
        Sub ProcessUser(user As String)
        End Sub
    </script>
</body>
</html>
