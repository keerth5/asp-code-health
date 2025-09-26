<%@ Page Language="VB" %>
<html>
<head>
    <title>Inappropriate Commenting Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inappropriate commenting - over-commenting obvious code or under-commenting complex logic
        
        ' BAD: Over-commenting obvious operations
        Sub BadOverCommentedMethod()
            ' Increment counter by 1
            counter = counter + 1
            
            ' Decrement value by 1  
            value = value - 1
            
            ' Add two numbers together
            result = number1 + number2
            
            ' Subtract second number from first
            difference = number1 - number2
            
            ' Multiply two values
            product = value1 * value2
            
            ' Divide first number by second
            quotient = dividend / divisor
            
            ' Declare string variable
            Dim message As String
            
            ' Set the string value
            message = "Hello World"
            
            ' Declare integer variable  
            Dim count As Integer
            
            ' Set count to zero
            count = 0
        End Sub
        
        ' BAD: Commenting every single line unnecessarily
        Function BadExcessiveComments() As Boolean
            ' Check if user is not null
            If user IsNot Nothing Then
                ' Get the user's name
                Dim name As String = user.Name
                
                ' Check if name is not empty
                If Not String.IsNullOrEmpty(name) Then
                    ' Convert name to uppercase
                    name = name.ToUpper()
                    
                    ' Set the display name
                    displayName = name
                    
                    ' Return true to indicate success
                    Return True
                End If
            End If
            
            ' Return false if validation failed
            Return False
        End Function
        
        ' BAD: Under-commenting complex logic
        Function BadComplexAlgorithmWithoutComments(data As List(Of Double)) As Double
            ' Complex mathematical algorithm with no explanation
            Dim result As Double = 0
            Dim n As Integer = data.Count
            
            For i As Integer = 0 To n - 1
                Dim weight As Double = Math.Exp(-Math.Pow(i - n/2, 2) / (2 * Math.Pow(n/6, 2)))
                result += data(i) * weight
            Next
            
            result = result / Math.Sqrt(2 * Math.PI * Math.Pow(n/6, 2))
            
            Dim adjustment As Double = 1.0
            For i As Integer = 1 To n
                adjustment *= (1 + Math.Sin(i * Math.PI / n) * 0.1)
            Next
            
            Return result * adjustment
        End Function
        
        ' BAD: Complex business logic without explanation
        Function BadBusinessRuleWithoutComments(customer As Customer, order As Order) As Decimal
            Dim discount As Decimal = 0
            
            If customer.YearsSinceRegistration > 5 AndAlso customer.TotalSpent > 10000 Then
                If order.ItemCount > 20 Then
                    discount = order.Total * 0.25
                ElseIf order.Total > 5000 Then
                    discount = order.Total * 0.2
                Else
                    discount = order.Total * 0.15
                End If
                
                If customer.HasPremiumMembership AndAlso order.IsFirstOrderThisMonth Then
                    discount += order.Total * 0.05
                End If
                
                If DateTime.Now.DayOfWeek = DayOfWeek.Tuesday AndAlso DateTime.Now.Hour < 12 Then
                    discount *= 1.1
                End If
            ElseIf customer.IsEmployee Then
                discount = order.Total * 0.3
                If customer.Department = "IT" Then
                    discount += 50
                End If
            End If
            
            Return Math.Min(discount, order.Total * 0.5)
        End Function
        
        ' BAD: Cryptic variable names with no comments
        Sub BadCrypticCodeWithoutComments()
            Dim a As Integer = GetValue1()
            Dim b As Integer = GetValue2()
            Dim c As Integer = GetValue3()
            
            Dim x As Double = (a * 1.15 + b * 0.85) / (c + 1)
            Dim y As Double = Math.Pow(x, 1.3) * 0.75
            Dim z As Double = y + (a * b / Math.Max(c, 1)) * 0.25
            
            If z > threshold1 AndAlso z < threshold2 Then
                ProcessType1(z)
            ElseIf z >= threshold2 Then
                ProcessType2(z * factor1)
            Else
                ProcessType3(z / factor2)
            End If
        End Sub
        
        ' GOOD: Appropriate commenting - explains why and complex how, not obvious what
        
        ' GOOD: Comments explain the purpose and business rules
        Function GoodBusinessLogicWithComments(customer As Customer, order As Order) As Decimal
            ' Calculate loyalty discount based on customer history and order characteristics
            ' Business rules: Long-term customers with high spend get tiered discounts
            ' Additional bonuses for premium members and promotional periods
            
            Dim discount As Decimal = 0
            
            ' Loyalty discount tier for customers with 5+ years and $10K+ spent
            If customer.YearsSinceRegistration > 5 AndAlso customer.TotalSpent > 10000 Then
                ' Tiered discount based on order size to encourage larger purchases
                If order.ItemCount > 20 Then
                    discount = order.Total * 0.25D ' 25% for bulk orders
                ElseIf order.Total > 5000 Then
                    discount = order.Total * 0.2D  ' 20% for high-value orders
                Else
                    discount = order.Total * 0.15D ' 15% base loyalty discount
                End If
                
                ' Premium member bonus: 5% extra for first order each month
                If customer.HasPremiumMembership AndAlso order.IsFirstOrderThisMonth Then
                    discount += order.Total * 0.05D
                End If
                
                ' Tuesday morning special: 10% bonus before noon
                If DateTime.Now.DayOfWeek = DayOfWeek.Tuesday AndAlso DateTime.Now.Hour < 12 Then
                    discount *= 1.1D
                End If
            ElseIf customer.IsEmployee Then
                ' Employee discount: 30% base plus IT department bonus
                discount = order.Total * 0.3D
                If customer.Department = "IT" Then
                    discount += 50D ' Fixed $50 bonus for IT staff
                End If
            End If
            
            ' Cap total discount at 50% of order value
            Return Math.Min(discount, order.Total * 0.5D)
        End Function
        
        ' GOOD: Complex algorithm with clear explanation
        Function GoodWeightedAverageWithComments(data As List(Of Double)) As Double
            ' Calculates weighted average using Gaussian weights centered on the middle element
            ' This smooths the data while giving more importance to central values
            ' Used for noise reduction in time-series analysis
            
            Dim result As Double = 0
            Dim n As Integer = data.Count
            Dim sigma As Double = n / 6.0 ' Standard deviation: 1/6 of data length
            
            ' Apply Gaussian weights to each data point
            For i As Integer = 0 To n - 1
                ' Gaussian weight formula: e^(-(x-μ)²/(2σ²))
                Dim distanceFromCenter As Double = i - n / 2.0
                Dim weight As Double = Math.Exp(-Math.Pow(distanceFromCenter, 2) / (2 * Math.Pow(sigma, 2)))
                result += data(i) * weight
            Next
            
            ' Normalize by the Gaussian normalization factor
            result = result / Math.Sqrt(2 * Math.PI * Math.Pow(sigma, 2))
            
            ' Apply seasonal adjustment factor based on data position
            ' This compensates for edge effects in the weighting
            Dim adjustment As Double = 1.0
            For i As Integer = 1 To n
                adjustment *= (1 + Math.Sin(i * Math.PI / n) * 0.1)
            Next
            
            Return result * adjustment
        End Function
        
        ' GOOD: Self-documenting code with minimal but helpful comments
        Function GoodSelfDocumentingCode(customer As Customer) As Boolean
            ' Validate customer eligibility for premium upgrade
            If Not IsEligibleForUpgrade(customer) Then
                Return False
            End If
            
            ' Check account standing and payment history
            If HasOutstandingBalance(customer) OrElse HasRecentChargebacks(customer) Then
                Return False
            End If
            
            ' Verify minimum activity requirements are met
            Return MeetsActivityRequirements(customer)
        End Function
        
        ' GOOD: Comments for non-obvious business decisions
        Sub GoodBusinessDecisionComments()
            ' Process orders in reverse chronological order
            ' Business requirement: Newest orders get priority in fulfillment
            For i As Integer = orders.Count - 1 To 0 Step -1
                ProcessOrder(orders(i))
            Next
            
            ' Cache results for 15 minutes
            ' Balance between data freshness and performance
            Cache.Set(cacheKey, result, TimeSpan.FromMinutes(15))
        End Sub
        
        ' GOOD: Explaining the why behind technical decisions
        Sub GoodTechnicalDecisionComments()
            ' Use StringBuilder for concatenation in loop
            ' String concatenation in VB.NET creates new objects each time
            Dim builder As New StringBuilder()
            For Each item In items
                builder.AppendLine(FormatItem(item))
            Next
            
            ' Dispose resources explicitly rather than relying on finalizer
            ' Ensures timely cleanup of database connections
            connection.Dispose()
        End Sub
        
        ' GOOD: Minimal comments for clear code
        Function GoodMinimalComments(items As List(Of Item)) As Decimal
            If items Is Nothing OrElse items.Count = 0 Then
                Return 0
            End If
            
            Dim total As Decimal = 0
            For Each item In items
                total += item.Price * item.Quantity
            Next
            
            Return ApplyTaxes(total)
        End Function
        
        ' GOOD: Complex regex with explanation
        Function GoodRegexWithComments(input As String) As Boolean
            ' Validate email format: local@domain.tld
            ' Allows alphanumeric, dots, hyphens, underscores in local part
            ' Domain must have at least one dot and valid TLD
            Dim emailPattern As String = "^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
            Return Regex.IsMatch(input, emailPattern)
        End Function
        
        ' GOOD: API integration with context
        Function GoodApiIntegrationComments() As String
            ' Retry logic for external API calls
            ' Service occasionally returns 503 during high load
            Dim maxRetries As Integer = 3
            Dim retryDelay As Integer = 1000 ' milliseconds
            
            For attempt As Integer = 1 To maxRetries
                Try
                    Return CallExternalApi()
                Catch ex As HttpRequestException When attempt < maxRetries
                    ' Wait before retry with exponential backoff
                    Thread.Sleep(retryDelay * attempt)
                End Try
            Next
            
            Throw New ServiceUnavailableException("External API unavailable after retries")
        End Function
        
        ' Helper methods and properties
        Private counter As Integer = 0
        Private value As Integer = 10
        Private result As Integer
        Private number1 As Integer = 5
        Private number2 As Integer = 3
        Private difference As Integer
        Private value1 As Integer = 4
        Private value2 As Integer = 6
        Private product As Integer
        Private dividend As Integer = 20
        Private divisor As Integer = 4
        Private quotient As Integer
        Private user As User
        Private displayName As String
        Private threshold1 As Double = 10.0
        Private threshold2 As Double = 50.0
        Private factor1 As Double = 1.5
        Private factor2 As Double = 2.0
        Private orders As New List(Of Order)()
        Private items As New List(Of Item)()
        Private cacheKey As String = "result_key"
        Private connection As IDbConnection
        
        Function GetValue1() As Integer
            Return 10
        End Function
        
        Function GetValue2() As Integer
            Return 20
        End Function
        
        Function GetValue3() As Integer
            Return 5
        End Function
        
        Sub ProcessType1(value As Double)
        End Sub
        
        Sub ProcessType2(value As Double)
        End Sub
        
        Sub ProcessType3(value As Double)
        End Sub
        
        Function IsEligibleForUpgrade(customer As Customer) As Boolean
            Return True
        End Function
        
        Function HasOutstandingBalance(customer As Customer) As Boolean
            Return False
        End Function
        
        Function HasRecentChargebacks(customer As Customer) As Boolean
            Return False
        End Function
        
        Function MeetsActivityRequirements(customer As Customer) As Boolean
            Return True
        End Function
        
        Sub ProcessOrder(order As Order)
        End Sub
        
        Function FormatItem(item As Item) As String
            Return item.ToString()
        End Function
        
        Function ApplyTaxes(amount As Decimal) As Decimal
            Return amount * 1.1D
        End Function
        
        Function CallExternalApi() As String
            Return "API Response"
        End Function
        
        ' Supporting classes
        Class Customer
            Public Property YearsSinceRegistration As Integer = 6
            Public Property TotalSpent As Decimal = 15000
            Public Property HasPremiumMembership As Boolean = True
            Public Property IsFirstOrderThisMonth As Boolean = True
            Public Property IsEmployee As Boolean = False
            Public Property Department As String = "Sales"
        End Class
        
        Class Order
            Public Property ItemCount As Integer = 25
            Public Property Total As Decimal = 1000
            Public Property IsFirstOrderThisMonth As Boolean = True
        End Class
        
        Class Item
            Public Property Price As Decimal = 10
            Public Property Quantity As Integer = 2
        End Class
        
        Class User
            Public Property Name As String = "John Doe"
        End Class
        
        Interface IDbConnection
            Inherits IDisposable
        End Interface
        
        Class Cache
            Public Shared Sub [Set](key As String, value As Object, expiration As TimeSpan)
            End Sub
        End Class
        
        Class ServiceUnavailableException
            Inherits Exception
            
            Public Sub New(message As String)
                MyBase.New(message)
            End Sub
        End Class
    </script>
</body>
</html>
