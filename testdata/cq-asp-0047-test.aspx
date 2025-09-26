<%@ Page Language="VB" %>
<html>
<head>
    <title>Caching Inefficiencies Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Caching inefficiencies - missing caching for frequently accessed data
        
        Sub BadDatabaseCallsWithoutCaching()
            ' BAD: Database calls without caching
            For i = 1 To 100
                Dim userData = database.ExecuteQuery("SELECT * FROM Users WHERE Id = " & i) ' Bad: no caching
                ProcessUserData(userData)
            Next
            
            While hasMoreRequests
                Dim productData = sql.Execute("SELECT * FROM Products WHERE CategoryId = 1") ' Bad: repeated query
                ProcessProductData(productData)
            End While
            
            ' BAD: File operations without caching
            For Each request In requests
                Dim config = file.ReadAllText("config.xml") ' Bad: reading file repeatedly
                ProcessConfig(config)
            Next
        End Sub
        
        Function BadExpensiveOperationsWithoutCache() As String
            ' BAD: Expensive operations without caching
            Dim result = expensiveCalculation() ' Bad: no caching
            Dim heavyData = slowDataProcessing() ' Bad: no caching
            Dim webData = web.GetData("https://api.slow-service.com") ' Bad: no caching
            
            Return result & heavyData & webData
        End Function
        
        Sub BadRepeatedFileAccess()
            ' BAD: Repeated file access without caching
            For Each user In users
                Dim template = file.Read("template.html") ' Bad: reading same file repeatedly
                Dim settings = file.Read("app.config") ' Bad: reading same config repeatedly
                ProcessUserWithTemplate(user, template, settings)
            Next
        End Sub
        
        Sub BadWebServiceCallsWithoutCache()
            ' BAD: Web service calls without caching
            For Each order In orders
                Dim shippingRate = http.Get("https://shipping-api.com/rate?zip=" & order.ZipCode) ' Bad: no caching
                Dim taxRate = web.GetTaxRate(order.State) ' Bad: no caching
                CalculateOrderTotal(order, shippingRate, taxRate)
            Next
        End Sub
        
        ' GOOD: Proper caching implementations
        
        Sub GoodDatabaseCaching()
            ' GOOD: Database results caching
            For i = 1 To 100
                Dim cacheKey = "user_" & i.ToString()
                Dim userData = Cache(cacheKey)
                
                If userData Is Nothing Then
                    userData = database.ExecuteQuery("SELECT * FROM Users WHERE Id = " & i)
                    Cache.Insert(cacheKey, userData, Nothing, DateTime.Now.AddMinutes(30), TimeSpan.Zero)
                End If
                
                ProcessUserData(userData)
            Next
            
            ' GOOD: Application-level caching
            Dim productCacheKey = "products_category_1"
            Dim cachedProducts = Application(productCacheKey)
            
            If cachedProducts Is Nothing Then
                cachedProducts = sql.Execute("SELECT * FROM Products WHERE CategoryId = 1")
                Application(productCacheKey) = cachedProducts
            End If
            
            ProcessProductData(cachedProducts)
        End Sub
        
        Function GoodExpensiveOperationsWithCache() As String
            ' GOOD: Caching expensive operations
            Dim cacheKey = "expensive_result"
            Dim cachedResult = Cache(cacheKey)
            
            If cachedResult Is Nothing Then
                Dim result = expensiveCalculation()
                Dim heavyData = slowDataProcessing()
                cachedResult = result & heavyData
                Cache.Insert(cacheKey, cachedResult, Nothing, DateTime.Now.AddHours(1), TimeSpan.Zero)
            End If
            
            ' GOOD: Memory cache for web data
            Dim webCacheKey = "web_data_slow_service"
            Dim webData = MemoryCache.Default(webCacheKey)
            
            If webData Is Nothing Then
                webData = web.GetData("https://api.slow-service.com")
                MemoryCache.Default.Set(webCacheKey, webData, DateTimeOffset.Now.AddMinutes(15))
            End If
            
            Return cachedResult.ToString() & webData.ToString()
        End Function
        
        Sub GoodFileCaching()
            ' GOOD: File content caching
            Static cachedTemplate As String = Nothing
            Static cachedSettings As String = Nothing
            Static templateLastModified As DateTime
            Static settingsLastModified As DateTime
            
            ' Check if template needs refresh
            Dim templateFile As New FileInfo("template.html")
            If cachedTemplate Is Nothing OrElse templateFile.LastWriteTime > templateLastModified Then
                cachedTemplate = file.Read("template.html")
                templateLastModified = templateFile.LastWriteTime
            End If
            
            ' Check if settings need refresh
            Dim settingsFile As New FileInfo("app.config")
            If cachedSettings Is Nothing OrElse settingsFile.LastWriteTime > settingsLastModified Then
                cachedSettings = file.Read("app.config")
                settingsLastModified = settingsFile.LastWriteTime
            End If
            
            For Each user In users
                ProcessUserWithTemplate(user, cachedTemplate, cachedSettings)
            Next
        End Sub
        
        Sub GoodWebServiceCaching()
            ' GOOD: Web service response caching
            Dim shippingCache As New Dictionary(Of String, Object)()
            Dim taxCache As New Dictionary(Of String, Object)()
            
            For Each order In orders
                ' Cache shipping rates by zip code
                Dim shippingRate As Object = Nothing
                If Not shippingCache.TryGetValue(order.ZipCode, shippingRate) Then
                    shippingRate = http.Get("https://shipping-api.com/rate?zip=" & order.ZipCode)
                    shippingCache(order.ZipCode) = shippingRate
                End If
                
                ' Cache tax rates by state
                Dim taxRate As Object = Nothing
                If Not taxCache.TryGetValue(order.State, taxRate) Then
                    taxRate = web.GetTaxRate(order.State)
                    taxCache(order.State) = taxRate
                End If
                
                CalculateOrderTotal(order, shippingRate, taxRate)
            Next
        End Sub
        
        Sub GoodHttpCacheHeaders()
            ' GOOD: Using HTTP cache headers
            Response.Cache.SetExpires(DateTime.Now.AddMinutes(30))
            Response.Cache.SetCacheability(HttpCacheability.Public)
            Response.Cache.SetValidUntilExpires(True)
            
            Dim expensiveData = GetExpensiveData()
            Response.Write(expensiveData)
        End Sub
        
        Sub GoodSessionCaching()
            ' GOOD: Session-level caching for user-specific data
            Dim userPreferences = Session("user_preferences")
            If userPreferences Is Nothing Then
                userPreferences = LoadUserPreferences(userId)
                Session("user_preferences") = userPreferences
            End If
            
            ProcessUserPreferences(userPreferences)
        End Sub
        
        Function GoodLazyLoadingWithCache() As Object
            ' GOOD: Lazy loading with caching
            Static lazyData As New Lazy(Of Object)(Function() LoadExpensiveData())
            Return lazyData.Value ' Loaded once, cached thereafter
        End Function
        
        ' Helper methods and fields
        Private database As Object
        Private sql As Object
        Private file As Object
        Private web As Object
        Private http As Object
        Private hasMoreRequests As Boolean = True
        Private requests As New List(Of Object)()
        Private users As New List(Of User)()
        Private orders As New List(Of Order)()
        Private userId As Integer = 1
        
        Function expensiveCalculation() As String
            Return "expensive result"
        End Function
        
        Function slowDataProcessing() As String
            Return "slow data"
        End Function
        
        Sub ProcessUserData(data As Object)
        End Sub
        
        Sub ProcessProductData(data As Object)
        End Sub
        
        Sub ProcessConfig(config As String)
        End Sub
        
        Sub ProcessUserWithTemplate(user As User, template As String, settings As String)
        End Sub
        
        Sub CalculateOrderTotal(order As Order, shippingRate As Object, taxRate As Object)
        End Sub
        
        Function GetExpensiveData() As String
            Return "expensive data"
        End Function
        
        Function LoadUserPreferences(userId As Integer) As Object
            Return New Object()
        End Function
        
        Sub ProcessUserPreferences(preferences As Object)
        End Sub
        
        Function LoadExpensiveData() As Object
            Return New Object()
        End Function
        
        ' Helper classes
        Public Class User
            Public Property Id As Integer
            Public Property Name As String
        End Class
        
        Public Class Order
            Public Property Id As Integer
            Public Property ZipCode As String
            Public Property State As String
        End Class
    </script>
</body>
</html>
