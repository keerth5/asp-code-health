<%@ Page Language="VB" %>
<html>
<head>
    <title>Thread Safety Violations Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Thread safety violations - non-thread-safe static collections
        Public Shared users As New List(Of String)() ' Not thread-safe
        Private Shared products As New Dictionary(Of String, Integer)() ' Not thread-safe
        Public Shared items As New ArrayList() ' Not thread-safe
        Private Shared cache As New Hashtable() ' Not thread-safe
        
        Public Shared orders As List(Of Order) ' Generic list - not thread-safe
        Private Shared sessions As Dictionary(Of String, Session) ' Generic dictionary - not thread-safe
        
        ' BAD: Non-thread-safe static fields without proper modifiers
        Public Shared currentUser As String ' Mutable shared field
        Private Shared connectionCount As Integer ' Mutable shared field
        Protected Shared lastAccessTime As DateTime ' Mutable shared field
        Public Shared isProcessing As Boolean ' Boolean flag without volatile
        
        ' BAD: More thread-unsafe collections
        Shared customerList As New List(Of Customer)() ' Not thread-safe
        Shared settingsDict As New Dictionary(Of String, String)() ' Not thread-safe
        
        Sub BadThreadUnsafeOperations()
            ' BAD: Operations on non-thread-safe collections
            users.Add("newuser") ' Unsafe on shared collection
            products.Add("item1", 100) ' Unsafe on shared dictionary
            items.Add("data") ' Unsafe on shared ArrayList
            cache.Add("key", "value") ' Unsafe on shared Hashtable
            
            ' BAD: Modifying shared fields
            currentUser = "admin" ' Unsafe modification
            connectionCount += 1 ' Unsafe increment
            isProcessing = True ' Unsafe boolean assignment
        End Sub
        
        Function BadSharedFieldAccess() As String
            ' BAD: Reading/writing shared fields without synchronization
            If isProcessing Then
                Return currentUser
            End If
            Return String.Empty
        End Function
        
        ' GOOD: Thread-safe alternatives
        Private Shared ReadOnly safeUsers As New ConcurrentBag(Of String)()
        Private Shared ReadOnly safeProducts As New ConcurrentDictionary(Of String, Integer)()
        Private Shared ReadOnly threadSafeCache As New ConcurrentDictionary(Of String, Object)()
        
        ' GOOD: Properly protected shared fields
        Private Shared ReadOnly userLock As New Object()
        Private Shared _currentUser As String ' Backing field
        
        Public Shared Property CurrentUser As String
            Get
                SyncLock userLock
                    Return _currentUser
                End SyncLock
            End Get
            Set(value As String)
                SyncLock userLock
                    _currentUser = value
                End SyncLock
            End Set
        End Property
        
        ' GOOD: Volatile fields for simple flags
        Private Shared Volatile isRunning As Boolean
        Private Shared Volatile stopRequested As Boolean
        
        ' GOOD: ReadOnly and Const fields (inherently thread-safe)
        Private Shared ReadOnly maxUsers As Integer = 1000
        Private Shared ReadOnly appVersion As String = "2.0.0"
        Private Const defaultTimeout As Integer = 30000
        Private Const configFile As String = "app.config"
        
        ' GOOD: Thread-safe operations
        Sub GoodThreadSafeOperations()
            ' GOOD: Using thread-safe collections
            safeUsers.Add("newuser") ' Thread-safe
            safeProducts.TryAdd("item1", 100) ' Thread-safe
            threadSafeCache.TryAdd("key", "value") ' Thread-safe
            
            ' GOOD: Using properties with synchronization
            CurrentUser = "admin" ' Thread-safe through property
            
            ' GOOD: Volatile field access
            If Not stopRequested Then
                isRunning = True
            End If
        End Sub
        
        Sub GoodSynchronizedAccess()
            ' GOOD: Explicit synchronization for non-thread-safe collections
            Dim tempUsers As New List(Of String)()
            
            SyncLock userLock
                ' Safe operations within lock
                For Each user In users
                    tempUsers.Add(user)
                Next
            End SyncLock
            
            ' Process outside of lock
            ProcessUsers(tempUsers)
        End Sub
        
        ' GOOD: Immutable collections
        Private Shared ReadOnly defaultSettings As New ReadOnlyDictionary(Of String, String)(
            New Dictionary(Of String, String) From {
                {"timeout", "30"},
                {"retries", "3"}
            })
        
        Sub GoodImmutableAccess()
            ' GOOD: Reading from immutable collections is thread-safe
            Dim timeout = defaultSettings("timeout")
            Dim retries = defaultSettings("retries")
        End Sub
        
        ' Helper classes and methods
        Public Class Order
            Public Property Id As Integer
            Public Property Amount As Decimal
        End Class
        
        Public Class Customer
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Public Class Session
            Public Property Id As String
            Public Property UserId As String
        End Class
        
        Sub ProcessUsers(users As List(Of String))
            ' Process users
        End Sub
    </script>
</body>
</html>
