<%@ Page Language="VB" %>
<html>
<head>
    <title>Inefficient Cache Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inefficient cache usage - caching implementations with poor hit ratios or excessive memory usage
        
        ' BAD: Cache operations without expiration or priority
        Sub BadCacheWithoutExpiration()
            ' BAD: Adding to cache without expiration settings
            Cache("user_1") = GetUser(1)
            Cache("user_2") = GetUser(2)
            Cache("user_3") = GetUser(3)
            Cache("product_100") = GetProduct(100)
            Cache("product_101") = GetProduct(101)
            Cache("order_500") = GetOrder(500)
        End Sub
        
        ' BAD: Session state used as cache without consideration
        Sub BadSessionAsCache()
            ' BAD: Using session for caching without size limits
            Session("cached_users") = GetAllUsers()
            Session("cached_products") = GetAllProducts()
            Session("cached_orders") = GetAllOrders()
            Session("cached_reports") = GenerateReports()
            Session("cached_analytics") = GetAnalytics()
        End Sub
        
        ' BAD: Application state used inefficiently
        Sub BadApplicationCache()
            ' BAD: Application cache without size management
            Application("global_users") = LoadAllUsers()
            Application("global_products") = LoadAllProducts()
            Application("global_categories") = LoadAllCategories()
            Application("global_settings") = LoadAllSettings()
            Application("global_permissions") = LoadAllPermissions()
        End Sub
        
        ' BAD: HttpCache.Insert without proper parameters
        Sub BadHttpCacheInsert()
            ' BAD: Cache insert without expiration, priority, or dependencies
            HttpContext.Current.Cache.Insert("key1", GetData1())
            HttpContext.Current.Cache.Insert("key2", GetData2())
            HttpContext.Current.Cache.Insert("key3", GetData3())
        End Sub
        
        ' BAD: Iterating through cache without checking existence
        Sub BadCacheIteration()
            Dim userIds = GetUserIds()
            
            ' BAD: Iterating and accessing cache without ContainsKey check
            For Each userId In userIds
                Dim cacheKey = $"user_{userId}"
                Dim user = Cache(cacheKey) ' BAD: No existence check
                If user IsNot Nothing Then
                    ProcessUser(user)
                End If
            Next
        End Sub
        
        ' BAD: Cache operations in loops without batching
        Sub BadCacheInLoop()
            Dim products = GetProductIds()
            
            ' BAD: Individual cache operations in loop
            For Each productId In products
                Cache($"product_{productId}") = GetProduct(productId)
                Cache($"inventory_{productId}") = GetInventory(productId)
                Cache($"pricing_{productId}") = GetPricing(productId)
            Next
        End Sub
        
        ' BAD: Large objects cached without size consideration
        Sub BadLargeObjectCaching()
            ' BAD: Caching large objects without size limits
            Cache("large_dataset_1") = LoadLargeDataSet1() ' Could be several MB
            Cache("large_dataset_2") = LoadLargeDataSet2() ' Could be several MB
            Cache("large_reports") = GenerateLargeReports() ' Could be several MB
            Cache("large_images") = LoadLargeImages() ' Could be several MB
        End Sub
        
        ' BAD: Cache keys without proper naming convention
        Sub BadCacheKeys()
            ' BAD: Poor cache key naming that could cause collisions
            Cache("data") = GetSomeData()
            Cache("info") = GetSomeInfo()
            Cache("result") = GetSomeResult()
            Cache("temp") = GetTempData()
        End Sub
        
        ' BAD: No cache invalidation strategy
        Sub BadCacheInvalidation()
            ' BAD: Updating data without invalidating related cache
            UpdateUser(userId:=1)
            UpdateUser(userId:=2)
            UpdateUser(userId:=3)
            ' Cache still contains old user data
        End Sub
        
        ' GOOD: Efficient cache usage with proper configuration
        
        ' GOOD: Cache with expiration and priority
        Sub GoodCacheWithExpiration()
            ' GOOD: Cache with expiration times
            Cache.Insert("user_1", GetUser(1), Nothing, DateTime.Now.AddMinutes(30), TimeSpan.Zero)
            Cache.Insert("user_2", GetUser(2), Nothing, DateTime.Now.AddMinutes(30), TimeSpan.Zero)
            
            ' GOOD: Cache with sliding expiration
            Cache.Insert("product_100", GetProduct(100), Nothing, DateTime.MaxValue, TimeSpan.FromMinutes(15))
            
            ' GOOD: Cache with priority
            Cache.Insert("critical_data", GetCriticalData(), Nothing, DateTime.Now.AddHours(1), TimeSpan.Zero, CacheItemPriority.High, Nothing)
        End Sub
        
        ' GOOD: Proper session cache management
        Sub GoodSessionCacheManagement()
            ' GOOD: Check session size and manage accordingly
            If Session("cached_user_data") Is Nothing OrElse SessionDataExpired() Then
                Dim userData = GetUserData(GetCurrentUserId())
                Session("cached_user_data") = userData
                Session("cache_timestamp") = DateTime.Now
            End If
            
            ' GOOD: Limited session caching
            If Session.Count > 10 Then
                ClearOldSessionData()
            End If
        End Sub
        
        ' GOOD: Application cache with size management
        Class GoodApplicationCacheManager
            Private Const MAX_CACHE_SIZE As Integer = 100
            Private Shared ReadOnly cacheKeys As New List(Of String)()
            
            Public Shared Sub AddToCache(key As String, value As Object, expiration As DateTime)
                ' GOOD: Manage cache size
                If cacheKeys.Count >= MAX_CACHE_SIZE Then
                    RemoveOldestCacheEntry()
                End If
                
                ' GOOD: Add with expiration and priority
                HttpContext.Current.Cache.Insert(key, value, Nothing, expiration, TimeSpan.Zero, CacheItemPriority.Normal, Nothing)
                cacheKeys.Add(key)
            End Sub
            
            Private Shared Sub RemoveOldestCacheEntry()
                If cacheKeys.Count > 0 Then
                    Dim oldestKey = cacheKeys(0)
                    HttpContext.Current.Cache.Remove(oldestKey)
                    cacheKeys.RemoveAt(0)
                End If
            End Sub
        End Class
        
        ' GOOD: HttpCache with proper configuration
        Sub GoodHttpCacheConfiguration()
            ' GOOD: Cache with dependency
            Dim dependency As New CacheDependency(Server.MapPath("~/App_Data/config.xml"))
            Cache.Insert("app_config", LoadAppConfig(), dependency, DateTime.Now.AddHours(1), TimeSpan.Zero)
            
            ' GOOD: Cache with callback for removal notification
            Cache.Insert("user_session_1", GetUserSession(1), Nothing, DateTime.Now.AddMinutes(20), TimeSpan.Zero, CacheItemPriority.Normal, AddressOf OnCacheItemRemoved)
            
            ' GOOD: Cache with sliding expiration for frequently accessed data
            Cache.Insert("popular_content", GetPopularContent(), Nothing, DateTime.MaxValue, TimeSpan.FromMinutes(30), CacheItemPriority.High, Nothing)
        End Sub
        
        ' GOOD: Efficient cache existence checking
        Function GoodCacheAccess(userId As Integer) As User
            Dim cacheKey = $"user_{userId}"
            
            ' GOOD: Check if key exists before accessing
            If Cache(cacheKey) IsNot Nothing Then
                Return CType(Cache(cacheKey), User)
            End If
            
            ' GOOD: Load data and cache with proper settings
            Dim user = GetUser(userId)
            If user IsNot Nothing Then
                Cache.Insert(cacheKey, user, Nothing, DateTime.Now.AddMinutes(15), TimeSpan.Zero, CacheItemPriority.Normal, Nothing)
            End If
            
            Return user
        End Function
        
        ' GOOD: Batch cache operations
        Sub GoodBatchCacheOperations()
            Dim products = GetProductIds()
            Dim productData As New Dictionary(Of Integer, Product)()
            
            ' GOOD: Check cache first for all items
            For Each productId In products
                Dim cacheKey = $"product_{productId}"
                Dim cachedProduct = TryCast(Cache(cacheKey), Product)
                If cachedProduct IsNot Nothing Then
                    productData(productId) = cachedProduct
                End If
            Next
            
            ' GOOD: Batch load missing items
            Dim missingIds = products.Where(Function(id) Not productData.ContainsKey(id)).ToList()
            If missingIds.Count > 0 Then
                Dim loadedProducts = GetProductsBatch(missingIds)
                
                ' GOOD: Cache loaded items
                For Each product In loadedProducts
                    Dim cacheKey = $"product_{product.Id}"
                    Cache.Insert(cacheKey, product, Nothing, DateTime.Now.AddMinutes(30), TimeSpan.Zero)
                    productData(product.Id) = product
                Next
            End If
        End Sub
        
        ' GOOD: Size-aware caching
        Class GoodSizeAwareCacheManager
            Private Const MAX_ITEM_SIZE As Integer = 1024 * 1024 ' 1MB
            Private Shared totalCacheSize As Long = 0
            Private Shared ReadOnly cacheSizes As New Dictionary(Of String, Long)()
            
            Public Shared Sub CacheItem(key As String, value As Object, estimatedSize As Long)
                ' GOOD: Check item size before caching
                If estimatedSize > MAX_ITEM_SIZE Then
                    ' Don't cache very large items
                    Return
                End If
                
                ' GOOD: Manage total cache size
                If totalCacheSize + estimatedSize > GetMaxCacheSize() Then
                    EvictLeastImportantItems(estimatedSize)
                End If
                
                ' GOOD: Cache with size tracking
                Cache.Insert(key, value, Nothing, DateTime.Now.AddMinutes(20), TimeSpan.Zero, CacheItemPriority.Normal, AddressOf OnItemRemoved)
                cacheSizes(key) = estimatedSize
                totalCacheSize += estimatedSize
            End Sub
            
            Private Shared Sub EvictLeastImportantItems(requiredSize As Long)
                Dim freedSize As Long = 0
                Dim keysToRemove As New List(Of String)()
                
                ' GOOD: Remove items until we have enough space
                For Each kvp In cacheSizes.OrderBy(Function(x) x.Value)
                    keysToRemove.Add(kvp.Key)
                    freedSize += kvp.Value
                    If freedSize >= requiredSize Then
                        Exit For
                    End If
                Next
                
                For Each key In keysToRemove
                    Cache.Remove(key)
                Next
            End Sub
            
            Private Shared Sub OnItemRemoved(key As String, value As Object, reason As CacheItemRemovedReason)
                ' GOOD: Update size tracking when items are removed
                If cacheSizes.ContainsKey(key) Then
                    totalCacheSize -= cacheSizes(key)
                    cacheSizes.Remove(key)
                End If
            End Sub
            
            Private Shared Function GetMaxCacheSize() As Long
                Return 50 * 1024 * 1024 ' 50MB
            End Function
        End Class
        
        ' GOOD: Proper cache key management
        Class GoodCacheKeyManager
            Private Const KEY_PREFIX As String = "MyApp_"
            Private Const KEY_VERSION As String = "v1_"
            
            Public Shared Function CreateUserKey(userId As Integer) As String
                Return $"{KEY_PREFIX}{KEY_VERSION}user_{userId}"
            End Function
            
            Public Shared Function CreateProductKey(productId As Integer) As String
                Return $"{KEY_PREFIX}{KEY_VERSION}product_{productId}"
            End Function
            
            Public Shared Function CreateSessionKey(sessionId As String) As String
                Return $"{KEY_PREFIX}{KEY_VERSION}session_{sessionId}"
            End Function
            
            ' GOOD: Key invalidation by pattern
            Public Shared Sub InvalidateUserCache(userId As Integer)
                Dim keyPattern = CreateUserKey(userId)
                Cache.Remove(keyPattern)
                
                ' Also remove related keys
                Cache.Remove(CreateUserKey(userId) & "_profile")
                Cache.Remove(CreateUserKey(userId) & "_preferences")
            End Sub
        End Class
        
        ' GOOD: Cache with proper invalidation strategy
        Class GoodCacheInvalidationManager
            Public Shared Sub UpdateUserAndInvalidateCache(userId As Integer, userData As User)
                ' GOOD: Update data first
                UpdateUserInDatabase(userId, userData)
                
                ' GOOD: Then invalidate related cache entries
                InvalidateUserRelatedCache(userId)
            End Sub
            
            Private Shared Sub InvalidateUserRelatedCache(userId As Integer)
                ' GOOD: Remove all user-related cache entries
                Dim userKey = GoodCacheKeyManager.CreateUserKey(userId)
                Cache.Remove(userKey)
                Cache.Remove($"{userKey}_profile")
                Cache.Remove($"{userKey}_orders")
                Cache.Remove($"{userKey}_preferences")
                
                ' GOOD: Also invalidate aggregate caches that might include this user
                Cache.Remove("all_active_users")
                Cache.Remove($"department_{GetUserDepartment(userId)}_users")
            End Sub
        End Sub
        
        ' Supporting classes and methods
        Class User
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Class Product
            Public Property Id As Integer
            Public Property Name As String
            Public Property Price As Decimal
        End Class
        
        Class CacheDependency
            Public Sub New(filePath As String)
            End Sub
        End Class
        
        Enum CacheItemPriority
            Low
            Normal
            High
        End Enum
        
        Enum CacheItemRemovedReason
            Removed
            Expired
            Underused
        End Enum
        
        Delegate Sub CacheItemRemovedCallback(key As String, value As Object, reason As CacheItemRemovedReason)
        
        ' Helper methods
        Function GetUser(userId As Integer) As User
            Return New User() With {.Id = userId, .Name = $"User{userId}"}
        End Function
        
        Function GetProduct(productId As Integer) As Product
            Return New Product() With {.Id = productId, .Name = $"Product{productId}"}
        End Function
        
        Function GetOrder(orderId As Integer) As Object
            Return New With {.Id = orderId}
        End Function
        
        Function GetAllUsers() As List(Of User)
            Return New List(Of User)()
        End Function
        
        Function GetAllProducts() As List(Of Product)
            Return New List(Of Product)()
        End Function
        
        Function GetAllOrders() As List(Of Object)
            Return New List(Of Object)()
        End Function
        
        Function GenerateReports() As Object
            Return New With {.Reports = "Data"}
        End Function
        
        Function GetAnalytics() As Object
            Return New With {.Analytics = "Data"}
        End Function
        
        Function LoadAllUsers() As Object
            Return New With {.Users = "All"}
        End Function
        
        Function LoadAllProducts() As Object
            Return New With {.Products = "All"}
        End Function
        
        Function LoadAllCategories() As Object
            Return New With {.Categories = "All"}
        End Function
        
        Function LoadAllSettings() As Object
            Return New With {.Settings = "All"}
        End Function
        
        Function LoadAllPermissions() As Object
            Return New With {.Permissions = "All"}
        End Function
        
        Function GetData1() As Object
            Return "Data1"
        End Function
        
        Function GetData2() As Object
            Return "Data2"
        End Function
        
        Function GetData3() As Object
            Return "Data3"
        End Function
        
        Function GetUserIds() As List(Of Integer)
            Return New List(Of Integer) From {1, 2, 3, 4, 5}
        End Function
        
        Function GetProductIds() As List(Of Integer)
            Return New List(Of Integer) From {100, 101, 102, 103}
        End Function
        
        Sub ProcessUser(user As Object)
        End Sub
        
        Function GetInventory(productId As Integer) As Object
            Return New With {.ProductId = productId, .Stock = 10}
        End Function
        
        Function GetPricing(productId As Integer) As Object
            Return New With {.ProductId = productId, .Price = 99.99}
        End Function
        
        Function LoadLargeDataSet1() As Object
            Return New With {.Data = "Large Dataset 1"}
        End Function
        
        Function LoadLargeDataSet2() As Object
            Return New With {.Data = "Large Dataset 2"}
        End Function
        
        Function GenerateLargeReports() As Object
            Return New With {.Reports = "Large Reports"}
        End Function
        
        Function LoadLargeImages() As Object
            Return New With {.Images = "Large Images"}
        End Function
        
        Function GetSomeData() As Object
            Return "Some Data"
        End Function
        
        Function GetSomeInfo() As Object
            Return "Some Info"
        End Function
        
        Function GetSomeResult() As Object
            Return "Some Result"
        End Function
        
        Function GetTempData() As Object
            Return "Temp Data"
        End Function
        
        Sub UpdateUser(userId As Integer)
        End Sub
        
        Function GetCriticalData() As Object
            Return "Critical Data"
        End Function
        
        Function GetCurrentUserId() As Integer
            Return 1
        End Function
        
        Function GetUserData(userId As Integer) As Object
            Return New With {.UserId = userId, .Data = "User Data"}
        End Function
        
        Function SessionDataExpired() As Boolean
            Return False
        End Function
        
        Sub ClearOldSessionData()
        End Sub
        
        Function LoadAppConfig() As Object
            Return New With {.Config = "App Configuration"}
        End Function
        
        Function GetUserSession(userId As Integer) As Object
            Return New With {.UserId = userId, .SessionData = "Session"}
        End Function
        
        Function GetPopularContent() As Object
            Return New With {.Content = "Popular Content"}
        End Function
        
        Sub OnCacheItemRemoved(key As String, value As Object, reason As CacheItemRemovedReason)
        End Sub
        
        Function GetProductsBatch(productIds As List(Of Integer)) As List(Of Product)
            Return productIds.Select(Function(id) New Product() With {.Id = id, .Name = $"Product{id}"}).ToList()
        End Function
        
        Sub UpdateUserInDatabase(userId As Integer, userData As User)
        End Sub
        
        Function GetUserDepartment(userId As Integer) As String
            Return "IT"
        End Function
    </script>
</body>
</html>
