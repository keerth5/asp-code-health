<%@ Page Language="VB" %>
<html>
<head>
    <title>Inappropriate Collection Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inappropriate collection usage - wrong collection types for specific scenarios
        
        Sub BadArrayListUsage()
            ' BAD: Using ArrayList instead of generic List
            Dim users As New ArrayList() ' Should use List(Of User)
            Dim products As New ArrayList() ' Should use List(Of Product)
            Dim orders As New ArrayList() ' Should use List(Of Order)
            
            users.Add(New User())
            products.Add(New Product())
            orders.Add(New Order())
            
            ' Type casting required with ArrayList
            Dim firstUser = CType(users(0), User)
            ProcessUser(firstUser)
        End Sub
        
        Sub BadContainsInLoop()
            ' BAD: Using Contains() in loops on List instead of HashSet
            Dim userList As New List(Of String)()
            userList.AddRange({"user1", "user2", "user3", "user4", "user5"})
            
            For i = 1 To 1000
                If userList.Contains("user" & i.ToString()) Then ' Bad: O(n) operation in loop
                    ProcessUser("user" & i.ToString())
                End If
            Next
            
            While hasMoreData
                If userList.Contains(currentUser) Then ' Bad: linear search in loop
                    AddToProcessingQueue(currentUser)
                End If
            End While
            
            For Each item In itemsToCheck
                If productList.Contains(item) Then ' Bad: Contains on List in loop
                    ProcessItem(item)
                End If
            Next
        End Sub
        
        Sub BadListAsArray()
            ' BAD: Using List when array access pattern suggests array would be better
            Dim data As New List(Of Integer)(1000) ' Bad: frequent indexed access suggests array
            
            ' Fill with data
            For i = 0 To 999
                data.Add(i)
            Next
            
            ' Frequent random access - array would be better
            For i = 1 To 10000
                Dim randomIndex = random.Next(0, 1000)
                Dim value = data(randomIndex) ' Bad: List with frequent indexed access
                ProcessValue(value)
            Next
        End Sub
        
        Sub BadDictionaryForSequentialData()
            ' BAD: Using Dictionary for sequential data that should use List
            Dim sequentialData As New Dictionary(Of Integer, String)() ' Bad: sequential keys suggest List
            
            For i = 0 To 99
                sequentialData.Add(i, "Item " & i.ToString()) ' Sequential keys 0-99
            Next
            
            ' Sequential iteration - List would be better
            For i = 0 To 99
                ProcessSequentialItem(sequentialData(i))
            Next
        End Sub
        
        Sub BadHashtableUsage()
            ' BAD: Using Hashtable instead of generic Dictionary
            Dim userCache As New Hashtable() ' Should use Dictionary(Of String, User)
            Dim sessionData As New Hashtable() ' Should use Dictionary(Of String, Object)
            
            userCache.Add("user1", New User())
            sessionData.Add("session1", "data")
            
            ' Type casting required with Hashtable
            Dim cachedUser = CType(userCache("user1"), User)
        End Sub
        
        Sub BadLinearSearchPatterns()
            ' BAD: Linear search patterns that should use Dictionary/HashSet
            Dim userIds As New List(Of Integer)()
            userIds.AddRange({1, 2, 3, 4, 5, 100, 200, 300})
            
            ' Bad: Linear search for existence check
            If userIds.Contains(targetUserId) Then ' O(n) operation
                ProcessTargetUser(targetUserId)
            End If
            
            ' Bad: Multiple Contains calls
            For Each id In idsToCheck
                If userIds.Contains(id) Then ' O(n) for each check
                    ProcessFoundUser(id)
                End If
            Next
        End Sub
        
        ' GOOD: Appropriate collection usage
        
        Sub GoodGenericCollections()
            ' GOOD: Using generic collections
            Dim users As New List(Of User)() ' Type-safe generic List
            Dim products As New List(Of Product)() ' Type-safe generic List
            Dim orders As New List(Of Order)() ' Type-safe generic List
            
            users.Add(New User())
            products.Add(New Product())
            orders.Add(New Order())
            
            ' No type casting needed
            Dim firstUser = users(0)
            ProcessUser(firstUser)
        End Sub
        
        Sub GoodHashSetForMembership()
            ' GOOD: Using HashSet for membership testing
            Dim userSet As New HashSet(Of String)()
            userSet.UnionWith({"user1", "user2", "user3", "user4", "user5"})
            
            For i = 1 To 1000
                If userSet.Contains("user" & i.ToString()) Then ' Good: O(1) operation
                    ProcessUser("user" & i.ToString())
                End If
            Next
            
            ' GOOD: HashSet for fast lookups
            Dim validProductCodes As New HashSet(Of String)(productCodes)
            For Each item In itemsToCheck
                If validProductCodes.Contains(item) Then ' Good: O(1) lookup
                    ProcessItem(item)
                End If
            Next
        End Sub
        
        Sub GoodArrayForFrequentIndexing()
            ' GOOD: Using array for frequent indexed access
            Dim data(999) As Integer ' Good: array for frequent random access
            
            ' Fill with data
            For i = 0 To 999
                data(i) = i
            Next
            
            ' Frequent random access - array is optimal
            For i = 1 To 10000
                Dim randomIndex = random.Next(0, 1000)
                Dim value = data(randomIndex) ' Good: array access is O(1)
                ProcessValue(value)
            Next
        End Sub
        
        Sub GoodListForSequentialData()
            ' GOOD: Using List for sequential data
            Dim sequentialData As New List(Of String)(100) ' Good: List for sequential data
            
            For i = 0 To 99
                sequentialData.Add("Item " & i.ToString())
            Next
            
            ' Sequential iteration - List is perfect
            For Each item In sequentialData
                ProcessSequentialItem(item)
            Next
            
            ' Or indexed access when needed
            For i = 0 To sequentialData.Count - 1
                ProcessSequentialItem(sequentialData(i))
            Next
        End Sub
        
        Sub GoodDictionaryForKeyValue()
            ' GOOD: Using Dictionary for key-value lookups
            Dim userCache As New Dictionary(Of String, User)() ' Type-safe Dictionary
            Dim sessionData As New Dictionary(Of String, Object)() ' Type-safe Dictionary
            
            userCache.Add("user1", New User())
            sessionData.Add("session1", "data")
            
            ' No type casting needed
            Dim cachedUser = userCache("user1")
            ProcessUser(cachedUser)
            
            ' GOOD: Fast lookups
            If userCache.ContainsKey("user1") Then ' O(1) operation
                ProcessUser(userCache("user1"))
            End If
        End Sub
        
        Sub GoodDictionaryForFastLookups()
            ' GOOD: Using Dictionary for fast lookups by key
            Dim userLookup As New Dictionary(Of Integer, User)()
            
            ' Build lookup dictionary
            For Each user In users
                userLookup.Add(user.Id, user)
            Next
            
            ' Fast lookups instead of linear search
            For Each id In idsToCheck
                If userLookup.ContainsKey(id) Then ' Good: O(1) lookup
                    ProcessFoundUser(userLookup(id))
                End If
            Next
        End Sub
        
        Sub GoodCollectionInitialization()
            ' GOOD: Pre-allocating collections with known size
            Dim users As New List(Of User)(expectedUserCount) ' Pre-allocate capacity
            Dim productDict As New Dictionary(Of String, Product)(expectedProductCount) ' Pre-allocate
            
            ' GOOD: Collection initializers
            Dim validStatuses As New HashSet(Of String) From {"Active", "Pending", "Approved"}
            Dim defaultSettings As New Dictionary(Of String, String) From {
                {"timeout", "30"},
                {"retries", "3"},
                {"buffer", "1024"}
            }
        End Sub
        
        Sub GoodConcurrentCollections()
            ' GOOD: Using concurrent collections for thread-safe operations
            Dim concurrentUsers As New ConcurrentDictionary(Of String, User)()
            Dim concurrentQueue As New ConcurrentQueue(Of String)()
            Dim concurrentBag As New ConcurrentBag(Of Integer)()
            
            ' Thread-safe operations
            concurrentUsers.TryAdd("user1", New User())
            concurrentQueue.Enqueue("item")
            concurrentBag.Add(42)
        End Sub
        
        Sub GoodSpecializedCollections()
            ' GOOD: Using specialized collections for specific scenarios
            Dim stack As New Stack(Of String)() ' LIFO operations
            Dim queue As New Queue(Of String)() ' FIFO operations
            Dim sortedDict As New SortedDictionary(Of String, Integer)() ' Sorted key-value pairs
            Dim sortedList As New SortedList(Of String, Integer)() ' Sorted by key with indexed access
            
            stack.Push("item")
            queue.Enqueue("item")
            sortedDict.Add("key", 1)
            sortedList.Add("key", 1)
        End Sub
        
        Function GoodLinqWithAppropriateCollections() As List(Of User)
            ' GOOD: Using appropriate collections with LINQ
            Dim activeUserIds As New HashSet(Of Integer)(users.Where(Function(u) u.IsActive).Select(Function(u) u.Id))
            
            ' Fast filtering using HashSet
            Dim filteredOrders = orders.Where(Function(o) activeUserIds.Contains(o.UserId)).ToList()
            
            Return users.Where(Function(u) activeUserIds.Contains(u.Id)).ToList()
        End Function
        
        ' Helper methods and fields
        Private hasMoreData As Boolean = True
        Private currentUser As String = "user1"
        Private itemsToCheck As New List(Of String)()
        Private productList As New List(Of String)()
        Private random As New Random()
        Private targetUserId As Integer = 1
        Private idsToCheck As New List(Of Integer)()
        Private productCodes As New List(Of String)()
        Private users As New List(Of User)()
        Private orders As New List(Of Order)()
        Private expectedUserCount As Integer = 100
        Private expectedProductCount As Integer = 50
        
        Sub ProcessUser(user As User)
        End Sub
        
        Sub ProcessUser(userName As String)
        End Sub
        
        Sub AddToProcessingQueue(user As String)
        End Sub
        
        Sub ProcessItem(item As String)
        End Sub
        
        Sub ProcessValue(value As Integer)
        End Sub
        
        Sub ProcessSequentialItem(item As String)
        End Sub
        
        Sub ProcessTargetUser(userId As Integer)
        End Sub
        
        Sub ProcessFoundUser(userId As Integer)
        End Sub
        
        Sub ProcessFoundUser(user As User)
        End Sub
        
        ' Helper classes
        Public Class User
            Public Property Id As Integer
            Public Property Name As String
            Public Property IsActive As Boolean
        End Class
        
        Public Class Product
            Public Property Id As Integer
            Public Property Name As String
            Public Property Code As String
        End Class
        
        Public Class Order
            Public Property Id As Integer
            Public Property UserId As Integer
            Public Property Amount As Decimal
        End Class
    </script>
</body>
</html>
