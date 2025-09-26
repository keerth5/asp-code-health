<%@ Page Language="VB" %>
<html>
<head>
    <title>Outdated Comments Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Outdated comments - comments that don't match the current code implementation
        
        Sub BadOutdatedTodoComments()
            ' TODO: Fix this bug - it crashes on null input
            ' FIXME: Memory leak in this method
            ' HACK: Temporary workaround for API issue
            ' TEMP: Remove this after testing
            ' TODO: Optimize this algorithm
            
            ' The actual code has been fixed but comments remain
            If input IsNot Nothing Then
                ProcessInput(input)
            End If
        End Sub
        
        Function BadDeprecatedComments() As String
            ' This method uses the old API format
            ' Legacy code from VB 6.0 migration
            ' Deprecated: Use new method instead
            ' Old implementation - needs updating
            ' Obsolete: This approach is no longer recommended
            
            ' But the code is actually modern
            Return JsonSerializer.Serialize(data)
        End Function
        
        Sub BadVersionSpecificComments()
            ' Version 1.0 implementation
            ' Compatible with ASP Classic only
            ' VB 6.0 style error handling
            ' This works in .NET Framework 2.0
            ' ASP.NET 1.1 compatible code
            
            ' But it's actually modern .NET code
            Try
                ProcessModernData()
            Catch ex As Exception
                Logger.LogError(ex)
            End Try
        End Sub
        
        ' BAD: HTML comments with outdated information
        Sub BadHtmlComments()
            ' <!-- TODO: Replace this with AJAX call -->
            ' <!-- FIXME: Browser compatibility issues -->
            ' <!-- Old jQuery version - update needed -->
            ' <!-- Remove this temporary fix -->
            ' <!-- Hack for IE6 support -->
            
            Response.Write("<div>Modern content</div>")
        End Sub
        
        Function BadOutdatedBusinessLogic() As Boolean
            ' Old business rule: Customers can only have 5 orders
            ' TODO: Update when limit is increased to 10
            ' FIXME: This doesn't handle premium customers
            ' Legacy logic from old system
            
            ' But the actual logic is different now
            Return customer.OrderCount <= 20 AndAlso customer.IsPremium
        End Function
        
        Sub BadOutdatedTechnicalComments()
            ' Uses deprecated SqlCommand approach
            ' TODO: Migrate to Entity Framework
            ' Old connection string format
            ' Remove when moving to new database
            ' Temporary database connection
            
            ' But it's using modern approach
            Using context As New ApplicationDbContext()
                Dim users = context.Users.ToList()
            End Using
        End Sub
        
        ' BAD: Comments about temporary solutions that are now permanent
        Function BadTemporaryComments() As Integer
            ' Temporary calculation until we get the real formula
            ' Quick fix - will be replaced next sprint
            ' Placeholder implementation
            ' Remove this hack after client approval
            ' Temporary workaround for API limitation
            
            ' But this is now the permanent solution
            Return complexBusinessCalculation()
        End Function
        
        ' BAD: Outdated performance comments
        Sub BadPerformanceComments()
            ' Slow operation - optimize later
            ' Performance issue - needs caching
            ' TODO: Implement async version
            ' Memory intensive operation
            ' Bottleneck in production
            
            ' But it's now optimized and async
            Dim result = Await OptimizedAsyncOperation()
            Cache.Set("result", result, TimeSpan.FromHours(1))
        End Sub
        
        ' GOOD: Current and accurate comments
        
        Sub GoodCurrentComments()
            ' Validates user input according to current business rules
            ' Updated: 2024-01-15 - Added premium customer handling
            If Not ValidateInput(userInput) Then
                Throw New ArgumentException("Invalid input format")
            End If
            
            ' Process input using current validation rules
            ProcessValidatedInput(userInput)
        End Sub
        
        Function GoodAccurateComments() As String
            ' Serializes data using System.Text.Json (current standard)
            ' Returns JSON string compatible with REST API v2.0
            Dim options As New JsonSerializerOptions With {
                .PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            }
            
            Return JsonSerializer.Serialize(data, options)
        End Function
        
        Sub GoodUpdatedComments()
            ' Current implementation using async/await pattern
            ' Handles timeout scenarios with proper error logging
            ' Last updated: 2024-01-20
            Try
                Await ProcessDataAsync()
            Catch ex As TimeoutException
                Logger.LogWarning("Operation timed out", ex)
                ' Fallback to cached data if available
                LoadFromCache()
            End Try
        End Sub
        
        Function GoodBusinessRuleComments() As Boolean
            ' Business rule as of 2024: Premium customers have unlimited orders
            ' Standard customers limited to 50 orders per month
            ' Updated to reflect current pricing tier changes
            If customer.IsPremium Then
                Return True ' No limit for premium customers
            Else
                Return customer.MonthlyOrderCount <= 50
            End If
        End Function
        
        Sub GoodTechnicalComments()
            ' Uses Entity Framework Core with connection pooling
            ' Implements repository pattern for testability
            ' Connection string configured in appsettings.json
            Using scope = serviceProvider.CreateScope()
                Dim repository = scope.ServiceProvider.GetService(Of IUserRepository)()
                repository.Save(user)
            End Using
        End Sub
        
        ' GOOD: Comments that explain current why, not what
        Function GoodExplanatoryComments() As Decimal
            ' Apply graduated discount based on order volume
            ' Business requirement: Encourage larger orders
            If orderTotal > 1000 Then
                Return orderTotal * 0.1D ' 10% discount for orders over $1000
            ElseIf orderTotal > 500 Then
                Return orderTotal * 0.05D ' 5% discount for orders over $500
            Else
                Return 0 ' No discount for small orders
            End If
        End Function
        
        Sub GoodDocumentedComplexLogic()
            ' Complex algorithm for calculating shipping costs
            ' Factors: distance, weight, priority, destination type
            ' Formula reviewed and approved by logistics team 2024-01-10
            
            Dim baseCost As Decimal = CalculateDistanceCost(origin, destination)
            Dim weightMultiplier As Decimal = CalculateWeightFactor(packageWeight)
            Dim priorityAdjustment As Decimal = GetPriorityAdjustment(shippingPriority)
            
            shippingCost = baseCost * weightMultiplier + priorityAdjustment
        End Sub
        
        ' GOOD: Comments with completion status
        Function GoodCompletedTaskComments() As String
            ' COMPLETED: Migrated from old API to REST API v2.0 (2024-01-15)
            ' RESOLVED: Fixed character encoding issue (2024-01-18)
            ' IMPLEMENTED: Added retry logic for network failures (2024-01-20)
            
            Return CallModernRestApi()
        End Function
        
        Sub GoodVersionedComments()
            ' Current implementation for .NET 8.0
            ' Compatible with C# 12 language features
            ' Uses current ASP.NET Core patterns
            ' Migration from .NET Framework completed 2024-01-01
            
            UseModernNetFeatures()
        End Sub
        
        ' GOOD: Living documentation
        ''' <summary>
        ''' Processes customer orders using current business rules
        ''' </summary>
        ''' <param name="order">Order to process</param>
        ''' <returns>Processing result with status and details</returns>
        ''' <remarks>
        ''' Business rules last updated: 2024-01-20
        ''' - Premium customers: No quantity limits
        ''' - Standard customers: Max 10 items per order
        ''' - Bulk orders: Require manager approval
        ''' </remarks>
        Function GoodDocumentedMethod(order As Order) As OrderResult
            ' Implementation matches documentation
            If customer.IsPremium Then
                Return ProcessPremiumOrder(order)
            ElseIf order.ItemCount > 10 Then
                Return RequireManagerApproval(order)
            Else
                Return ProcessStandardOrder(order)
            End If
        End Function
        
        ' Helper methods and properties
        Private input As String = "test"
        Private data As Object = New With {.Name = "Test"}
        Private userInput As String = "user input"
        Private customer As Customer = New Customer()
        Private orderTotal As Decimal = 100
        Private packageWeight As Decimal = 5.0
        Private shippingPriority As String = "Standard"
        Private origin As String = "Origin"
        Private destination As String = "Destination"
        Private shippingCost As Decimal
        Private order As Order = New Order()
        Private user As User = New User()
        Private serviceProvider As IServiceProvider
        
        Sub ProcessInput(input As String)
        End Sub
        
        Sub ProcessModernData()
        End Sub
        
        Sub ProcessValidatedInput(input As String)
        End Sub
        
        Function ValidateInput(input As String) As Boolean
            Return True
        End Function
        
        Function complexBusinessCalculation() As Integer
            Return 42
        End Function
        
        Async Function OptimizedAsyncOperation() As Task(Of String)
            Return "result"
        End Function
        
        Sub LoadFromCache()
        End Sub
        
        Async Function ProcessDataAsync() As Task
        End Function
        
        Function CalculateDistanceCost(origin As String, destination As String) As Decimal
            Return 10.0D
        End Function
        
        Function CalculateWeightFactor(weight As Decimal) As Decimal
            Return 1.2D
        End Function
        
        Function GetPriorityAdjustment(priority As String) As Decimal
            Return 5.0D
        End Function
        
        Function CallModernRestApi() As String
            Return "API Response"
        End Function
        
        Sub UseModernNetFeatures()
        End Sub
        
        Function ProcessPremiumOrder(order As Order) As OrderResult
            Return New OrderResult()
        End Function
        
        Function RequireManagerApproval(order As Order) As OrderResult
            Return New OrderResult()
        End Function
        
        Function ProcessStandardOrder(order As Order) As OrderResult
            Return New OrderResult()
        End Function
        
        ' Supporting classes
        Class Customer
            Public Property OrderCount As Integer = 15
            Public Property IsPremium As Boolean = False
            Public Property MonthlyOrderCount As Integer = 25
        End Class
        
        Class Order
            Public Property ItemCount As Integer = 5
        End Class
        
        Class OrderResult
            Public Property Success As Boolean = True
        End Class
        
        Class User
        End Class
        
        Interface IUserRepository
            Sub Save(user As User)
        End Interface
        
        Class Logger
            Public Shared Sub LogError(ex As Exception)
            End Sub
            
            Public Shared Sub LogWarning(message As String, ex As Exception)
            End Sub
        End Class
        
        Class Cache
            Public Shared Sub [Set](key As String, value As Object, expiration As TimeSpan)
            End Sub
        End Class
    </script>
</body>
</html>
