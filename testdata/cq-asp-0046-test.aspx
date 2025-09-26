<%@ Page Language="VB" %>
<html>
<head>
    <title>Lazy Loading Abuse Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Lazy loading abuse - excessive or inappropriate lazy loading causing N+1 problems
        
        Sub BadLazyLoadingInLoop()
            ' BAD: Lazy loading properties accessed in loops (N+1 problem)
            For Each user In users
                Console.WriteLine(user.Profile.Name) ' Bad: lazy loading in loop
                Console.WriteLine(user.Profile.Email) ' Bad: lazy loading in loop
                Console.WriteLine(user.Profile.Address.Street) ' Bad: nested lazy loading
                Console.WriteLine(user.Profile.Address.City) ' Bad: nested lazy loading
                Console.WriteLine(user.Orders.Count) ' Bad: lazy loading collection in loop
            Next
            
            ' BAD: Multiple lazy property access in foreach
            For Each order In orders
                ProcessCustomer(order.Customer.Name) ' Bad: lazy loading in loop
                ProcessCustomer(order.Customer.Email) ' Bad: lazy loading in loop
                ProcessCustomer(order.Customer.Phone) ' Bad: lazy loading in loop
                ProcessProduct(order.Product.Name) ' Bad: lazy loading in loop
                ProcessProduct(order.Product.Category.Name) ' Bad: nested lazy loading
            Next
        End Sub
        
        Sub BadExcessiveLazyAccess()
            ' BAD: Excessive lazy property access causing multiple database hits
            For Each customer In customers
                Dim profile = customer.Profile ' Lazy load 1
                Dim preferences = customer.Preferences ' Lazy load 2
                Dim history = customer.OrderHistory ' Lazy load 3
                Dim recommendations = customer.Recommendations ' Lazy load 4
                Dim settings = customer.Settings ' Lazy load 5
                
                ProcessCustomerData(profile, preferences, history)
            Next
        End Sub
        
        Sub BadLazyLoadInWhileLoop()
            ' BAD: Lazy loading in while loops
            While hasMoreCustomers
                Dim customer = GetNextCustomer()
                customer.Load() ' Bad: explicit lazy loading in loop
                ProcessCustomer(customer.Profile.FullName) ' Bad: lazy property access
                ProcessOrders(customer.Orders) ' Bad: lazy collection access
            End While
        End Sub
        
        Sub BadLazyValueAccess()
            ' BAD: Multiple accesses to Lazy<T>.Value
            Dim lazyService As New Lazy(Of ExpensiveService)(Function() New ExpensiveService())
            
            For i = 1 To 100
                Dim result1 = lazyService.Value.ProcessData(data1) ' Lazy.Value access 1
                Dim result2 = lazyService.Value.ProcessData(data2) ' Lazy.Value access 2
                Dim result3 = lazyService.Value.ValidateData(data3) ' Lazy.Value access 3
                ProcessResults(result1, result2, result3)
            Next
        End Sub
        
        Sub BadNestedLazyLoading()
            ' BAD: Deep nested lazy loading chains
            For Each order In orders
                Dim customerName = order.Customer.Profile.PersonalInfo.FullName ' Bad: deep lazy chain
                Dim customerAddress = order.Customer.Profile.Address.FullAddress ' Bad: deep lazy chain
                Dim productCategory = order.Product.Category.ParentCategory.Name ' Bad: deep lazy chain
                Dim supplierInfo = order.Product.Supplier.ContactInfo.Email ' Bad: deep lazy chain
                
                ProcessOrderInfo(customerName, customerAddress, productCategory)
            Next
        End Sub
        
        ' GOOD: Efficient lazy loading patterns
        
        Sub GoodEagerLoading()
            ' GOOD: Eager loading to avoid N+1 problems
            Dim usersWithProfiles = users.Include(Function(u) u.Profile).
                                         Include(Function(u) u.Profile.Address).
                                         Include(Function(u) u.Orders).
                                         ToList()
            
            For Each user In usersWithProfiles
                Console.WriteLine(user.Profile.Name) ' No lazy loading - data already loaded
                Console.WriteLine(user.Profile.Email) ' No lazy loading - data already loaded
                Console.WriteLine(user.Profile.Address.Street) ' No lazy loading - data already loaded
                Console.WriteLine(user.Orders.Count) ' No lazy loading - data already loaded
            Next
        End Sub
        
        Sub GoodBatchLoading()
            ' GOOD: Batch loading instead of individual lazy loads
            Dim customerIds = customers.Select(Function(c) c.Id).ToList()
            Dim profiles = LoadProfilesBatch(customerIds)
            Dim preferences = LoadPreferencesBatch(customerIds)
            Dim histories = LoadOrderHistoriesBatch(customerIds)
            
            For Each customer In customers
                Dim profile = profiles(customer.Id) ' Pre-loaded data
                Dim preference = preferences(customer.Id) ' Pre-loaded data
                Dim history = histories(customer.Id) ' Pre-loaded data
                
                ProcessCustomerData(profile, preference, history)
            Next
        End Sub
        
        Sub GoodCachedLazyValue()
            ' GOOD: Cache Lazy<T>.Value to avoid repeated access
            Dim lazyService As New Lazy(Of ExpensiveService)(Function() New ExpensiveService())
            Dim service = lazyService.Value ' Get value once
            
            For i = 1 To 100
                Dim result1 = service.ProcessData(data1) ' Use cached reference
                Dim result2 = service.ProcessData(data2) ' Use cached reference
                Dim result3 = service.ValidateData(data3) ' Use cached reference
                ProcessResults(result1, result2, result3)
            Next
        End Sub
        
        Sub GoodSelectiveEagerLoading()
            ' GOOD: Selective eager loading based on usage patterns
            Dim ordersWithDetails = orders.Include(Function(o) o.Customer).
                                          Include(Function(o) o.Product).
                                          Include(Function(o) o.Product.Category).
                                          Where(Function(o) o.Status = "Active").
                                          ToList()
            
            For Each order In ordersWithDetails
                ProcessCustomer(order.Customer.Name) ' Pre-loaded
                ProcessProduct(order.Product.Name) ' Pre-loaded
                ProcessCategory(order.Product.Category.Name) ' Pre-loaded
            Next
        End Sub
        
        Sub GoodProjectionToAvoidLazyLoading()
            ' GOOD: Using projections to load only needed data
            Dim customerSummaries = customers.Select(Function(c) New CustomerSummary With {
                .Id = c.Id,
                .Name = c.Profile.Name,
                .Email = c.Profile.Email,
                .OrderCount = c.Orders.Count,
                .LastOrderDate = c.Orders.Max(Function(o) o.OrderDate)
            }).ToList()
            
            For Each summary In customerSummaries
                ProcessCustomerSummary(summary) ' All data loaded in single query
            Next
        End Sub
        
        Sub GoodAsyncLazyLoading()
            ' GOOD: Async lazy loading for better performance
            Dim lazyDataTask As New Lazy(Of Task(Of ExpensiveData))(Function() LoadExpensiveDataAsync())
            
            ' Do other work while data loads
            DoOtherWork()
            
            ' Await the lazy-loaded data when needed
            Dim expensiveData = Await lazyDataTask.Value
            ProcessExpensiveData(expensiveData)
        End Sub
        
        Sub GoodLazyInitializationPattern()
            ' GOOD: Proper lazy initialization for expensive objects
            Dim lazyProcessor As New Lazy(Of DataProcessor)(Function() New DataProcessor())
            
            ' Only create processor if needed
            If needsProcessing Then
                Dim processor = lazyProcessor.Value
                processor.ProcessAllData(allData) ' Process all data at once
            End If
        End Sub
        
        Sub GoodBulkOperations()
            ' GOOD: Bulk operations instead of individual lazy loads
            Dim customerIds = GetCustomerIdsToProcess()
            
            ' Load all needed data in bulk
            Dim customerData = LoadCustomerDataBulk(customerIds)
            Dim orderData = LoadOrderDataBulk(customerIds)
            Dim preferencesData = LoadPreferencesDataBulk(customerIds)
            
            ' Process with pre-loaded data
            For Each customerId In customerIds
                ProcessCustomerComplete(
                    customerData(customerId),
                    orderData(customerId),
                    preferencesData(customerId)
                )
            Next
        End Sub
        
        Function GoodLazyWithCaching() As String
            ' GOOD: Lazy loading with caching to prevent repeated loads
            Static cachedExpensiveData As ExpensiveData = Nothing
            Static isLoaded As Boolean = False
            
            If Not isLoaded Then
                cachedExpensiveData = LoadExpensiveData()
                isLoaded = True
            End If
            
            Return cachedExpensiveData.ProcessedValue
        End Function
        
        Sub GoodConditionalLazyLoading()
            ' GOOD: Conditional lazy loading based on actual need
            For Each user In users
                ' Only load profile if we actually need it
                If user.RequiresProfileProcessing Then
                    Dim profile = LoadUserProfile(user.Id) ' Load only when needed
                    ProcessUserProfile(profile)
                End If
                
                ' Only load orders if user has any
                If user.HasOrders Then
                    Dim orders = LoadUserOrders(user.Id) ' Load only when needed
                    ProcessUserOrders(orders)
                End If
            Next
        End Sub
        
        ' Helper methods and fields
        Private users As New List(Of User)()
        Private orders As New List(Of Order)()
        Private customers As New List(Of Customer)()
        Private hasMoreCustomers As Boolean = True
        Private data1 As String = "data1"
        Private data2 As String = "data2"
        Private data3 As String = "data3"
        Private allData As New List(Of String)()
        Private needsProcessing As Boolean = True
        
        Sub ProcessCustomer(info As String)
        End Sub
        
        Sub ProcessProduct(info As String)
        End Sub
        
        Sub ProcessCustomerData(profile As Object, preferences As Object, history As Object)
        End Sub
        
        Function GetNextCustomer() As Customer
            Return New Customer()
        End Function
        
        Sub ProcessOrders(orders As Object)
        End Sub
        
        Sub ProcessResults(result1 As Object, result2 As Object, result3 As Object)
        End Sub
        
        Sub ProcessOrderInfo(customerName As String, address As String, category As String)
        End Sub
        
        Function LoadProfilesBatch(ids As List(Of Integer)) As Dictionary(Of Integer, Object)
            Return New Dictionary(Of Integer, Object)()
        End Function
        
        Function LoadPreferencesBatch(ids As List(Of Integer)) As Dictionary(Of Integer, Object)
            Return New Dictionary(Of Integer, Object)()
        End Function
        
        Function LoadOrderHistoriesBatch(ids As List(Of Integer)) As Dictionary(Of Integer, Object)
            Return New Dictionary(Of Integer, Object)()
        End Function
        
        Sub ProcessCategory(name As String)
        End Sub
        
        Sub ProcessCustomerSummary(summary As CustomerSummary)
        End Sub
        
        Function LoadExpensiveDataAsync() As Task(Of ExpensiveData)
            Return Task.FromResult(New ExpensiveData())
        End Function
        
        Sub DoOtherWork()
        End Sub
        
        Sub ProcessExpensiveData(data As ExpensiveData)
        End Sub
        
        Function GetCustomerIdsToProcess() As List(Of Integer)
            Return New List(Of Integer)()
        End Function
        
        Function LoadCustomerDataBulk(ids As List(Of Integer)) As Dictionary(Of Integer, Object)
            Return New Dictionary(Of Integer, Object)()
        End Function
        
        Function LoadOrderDataBulk(ids As List(Of Integer)) As Dictionary(Of Integer, Object)
            Return New Dictionary(Of Integer, Object)()
        End Function
        
        Function LoadPreferencesDataBulk(ids As List(Of Integer)) As Dictionary(Of Integer, Object)
            Return New Dictionary(Of Integer, Object)()
        End Function
        
        Sub ProcessCustomerComplete(customer As Object, orders As Object, preferences As Object)
        End Sub
        
        Function LoadExpensiveData() As ExpensiveData
            Return New ExpensiveData()
        End Function
        
        Function LoadUserProfile(userId As Integer) As Object
            Return New Object()
        End Function
        
        Function LoadUserOrders(userId As Integer) As Object
            Return New Object()
        End Function
        
        Sub ProcessUserProfile(profile As Object)
        End Sub
        
        Sub ProcessUserOrders(orders As Object)
        End Sub
        
        ' Helper classes
        Public Class User
            Public Property Id As Integer
            Public Property Profile As UserProfile
            Public Property Orders As List(Of Order)
            Public Property RequiresProfileProcessing As Boolean
            Public Property HasOrders As Boolean
        End Class
        
        Public Class UserProfile
            Public Property Name As String
            Public Property Email As String
            Public Property Address As Address
        End Class
        
        Public Class Address
            Public Property Street As String
            Public Property City As String
        End Class
        
        Public Class Order
            Public Property Id As Integer
            Public Property Customer As Customer
            Public Property Product As Product
            Public Property Status As String
            Public Property OrderDate As DateTime
        End Class
        
        Public Class Customer
            Public Property Id As Integer
            Public Property Profile As UserProfile
            Public Property Preferences As Object
            Public Property OrderHistory As Object
            Public Property Recommendations As Object
            Public Property Settings As Object
        End Class
        
        Public Class Product
            Public Property Name As String
            Public Property Category As Category
            Public Property Supplier As Supplier
        End Class
        
        Public Class Category
            Public Property Name As String
            Public Property ParentCategory As Category
        End Class
        
        Public Class Supplier
            Public Property ContactInfo As ContactInfo
        End Class
        
        Public Class ContactInfo
            Public Property Email As String
        End Class
        
        Public Class ExpensiveService
            Public Function ProcessData(data As String) As Object
                Return New Object()
            End Function
            
            Public Function ValidateData(data As String) As Object
                Return New Object()
            End Function
        End Class
        
        Public Class ExpensiveData
            Public Property ProcessedValue As String = "processed"
        End Class
        
        Public Class DataProcessor
            Public Sub ProcessAllData(data As List(Of String))
            End Sub
        End Class
        
        Public Class CustomerSummary
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
            Public Property OrderCount As Integer
            Public Property LastOrderDate As DateTime
        End Class
    </script>
</body>
</html>
