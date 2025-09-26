<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Region Organization Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing region organization - large classes without proper region organization for readability
        
        ' BAD: Large class without regions - hard to navigate
        Class BadLargeClassWithoutRegions
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
            Public Property Phone As String
            Public Property Address As String
            Public Property City As String
            Public Property State As String
            Public Property ZipCode As String
            Public Property Country As String
            Public Property DateCreated As DateTime
            Public Property LastModified As DateTime
            Public Property IsActive As Boolean
            Public Property Status As String
            
            Public Sub New()
                InitializeDefaults()
            End Sub
            
            Public Sub New(name As String, email As String)
                Me.Name = name
                Me.Email = email
                InitializeDefaults()
            End Sub
            
            Public Sub New(id As Integer, name As String, email As String, phone As String)
                Me.Id = id
                Me.Name = name
                Me.Email = email
                Me.Phone = phone
                InitializeDefaults()
            End Sub
            
            Public Function ValidateName() As Boolean
                Return Not String.IsNullOrEmpty(Name) AndAlso Name.Length >= 2
            End Function
            
            Public Function ValidateEmail() As Boolean
                Return Not String.IsNullOrEmpty(Email) AndAlso Email.Contains("@")
            End Function
            
            Public Function ValidatePhone() As Boolean
                Return Not String.IsNullOrEmpty(Phone) AndAlso Phone.Length >= 10
            End Function
            
            Public Function ValidateAddress() As Boolean
                Return Not String.IsNullOrEmpty(Address)
            End Function
            
            Public Function ValidateZipCode() As Boolean
                Return Not String.IsNullOrEmpty(ZipCode) AndAlso ZipCode.Length = 5
            End Function
            
            Public Sub Save()
                If ValidateAll() Then
                    SaveToDatabase()
                End If
            End Sub
            
            Public Sub Update()
                If ValidateAll() Then
                    UpdateInDatabase()
                End If
            End Sub
            
            Public Sub Delete()
                DeleteFromDatabase()
            End Sub
            
            Public Function Load(id As Integer) As Boolean
                Return LoadFromDatabase(id)
            End Function
            
            Public Function GetFullName() As String
                Return $"{Name}"
            End Function
            
            Public Function GetDisplayAddress() As String
                Return $"{Address}, {City}, {State} {ZipCode}"
            End Function
            
            Public Function GetContactInfo() As String
                Return $"Email: {Email}, Phone: {Phone}"
            End Function
            
            Public Sub SendWelcomeEmail()
                EmailService.SendWelcome(Email, Name)
            End Sub
            
            Public Sub SendNotification(message As String)
                EmailService.SendNotification(Email, message)
            End Sub
            
            Public Sub LogActivity(activity As String)
                Logger.Log($"User {Id}: {activity}")
            End Sub
            
            Private Sub InitializeDefaults()
                DateCreated = DateTime.Now
                IsActive = True
                Status = "Active"
            End Sub
            
            Private Function ValidateAll() As Boolean
                Return ValidateName() AndAlso ValidateEmail() AndAlso ValidatePhone()
            End Function
            
            Private Sub SaveToDatabase()
                ' Database save logic
            End Sub
            
            Private Sub UpdateInDatabase()
                ' Database update logic
            End Sub
            
            Private Sub DeleteFromDatabase()
                ' Database delete logic
            End Sub
            
            Private Function LoadFromDatabase(id As Integer) As Boolean
                ' Database load logic
                Return True
            End Function
        End Class
        
        ' BAD: Another large class with many methods but no organization
        Class BadOrderProcessingClass
            Dim orderId As Integer
            Dim customerId As Integer
            Dim items As List(Of OrderItem)
            Dim subtotal As Decimal
            Dim tax As Decimal
            Dim shipping As Decimal
            Dim total As Decimal
            Dim orderDate As DateTime
            Dim shippingAddress As String
            Dim billingAddress As String
            Dim paymentMethod As String
            Dim orderStatus As String
            
            Public Sub ProcessOrder()
            End Sub
            
            Public Sub CalculateSubtotal()
            End Sub
            
            Public Sub CalculateTax()
            End Sub
            
            Public Sub CalculateShipping()
            End Sub
            
            Public Sub CalculateTotal()
            End Sub
            
            Public Function ValidateOrder() As Boolean
                Return True
            End Function
            
            Public Function ValidateItems() As Boolean
                Return True
            End Function
            
            Public Function ValidatePayment() As Boolean
                Return True
            End Function
            
            Public Function ValidateShipping() As Boolean
                Return True
            End Function
            
            Public Sub SendConfirmationEmail()
            End Sub
            
            Public Sub SendShippingNotification()
            End Sub
            
            Public Sub SendDeliveryNotification()
            End Sub
            
            Public Sub UpdateInventory()
            End Sub
            
            Public Sub ProcessPayment()
            End Sub
            
            Public Sub GenerateInvoice()
            End Sub
            
            Public Sub CreateShippingLabel()
            End Sub
            
            Public Sub TrackShipment()
            End Sub
            
            Public Sub HandleReturn()
            End Sub
            
            Public Sub ProcessRefund()
            End Sub
            
            Private Sub LogOrderActivity(activity As String)
            End Sub
            
            Private Sub SaveOrderToDatabase()
            End Sub
            
            Private Sub UpdateOrderStatus(status As String)
            End Sub
        End Class
        
        ' GOOD: Well-organized class with proper regions
        Class GoodUserManagerWithRegions
            
#Region "Properties and Fields"
            
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
            Public Property Phone As String
            Public Property Address As String
            Public Property City As String
            Public Property State As String
            Public Property ZipCode As String
            Public Property Country As String
            Public Property DateCreated As DateTime
            Public Property LastModified As DateTime
            Public Property IsActive As Boolean
            Public Property Status As String
            
            Private logger As ILogger
            Private emailService As IEmailService
            Private repository As IUserRepository
            
#End Region
            
#Region "Constructors"
            
            Public Sub New()
                InitializeDefaults()
            End Sub
            
            Public Sub New(name As String, email As String)
                Me.Name = name
                Me.Email = email
                InitializeDefaults()
            End Sub
            
            Public Sub New(id As Integer, name As String, email As String, phone As String)
                Me.Id = id
                Me.Name = name
                Me.Email = email
                Me.Phone = phone
                InitializeDefaults()
            End Sub
            
#End Region
            
#Region "Public Methods"
            
            Public Sub Save()
                If ValidateAll() Then
                    repository.Save(Me)
                    LogActivity("User saved")
                End If
            End Sub
            
            Public Sub Update()
                If ValidateAll() Then
                    repository.Update(Me)
                    LogActivity("User updated")
                End If
            End Sub
            
            Public Sub Delete()
                repository.Delete(Id)
                LogActivity("User deleted")
            End Sub
            
            Public Function Load(id As Integer) As Boolean
                Dim userData = repository.GetById(id)
                If userData IsNot Nothing Then
                    MapFromData(userData)
                    Return True
                End If
                Return False
            End Function
            
#End Region
            
#Region "Validation Methods"
            
            Public Function ValidateName() As Boolean
                Return Not String.IsNullOrEmpty(Name) AndAlso Name.Length >= 2
            End Function
            
            Public Function ValidateEmail() As Boolean
                Return Not String.IsNullOrEmpty(Email) AndAlso Email.Contains("@")
            End Function
            
            Public Function ValidatePhone() As Boolean
                Return Not String.IsNullOrEmpty(Phone) AndAlso Phone.Length >= 10
            End Function
            
            Public Function ValidateAddress() As Boolean
                Return Not String.IsNullOrEmpty(Address)
            End Function
            
            Public Function ValidateZipCode() As Boolean
                Return Not String.IsNullOrEmpty(ZipCode) AndAlso ZipCode.Length = 5
            End Function
            
#End Region
            
#Region "Display and Formatting Methods"
            
            Public Function GetFullName() As String
                Return $"{Name}"
            End Function
            
            Public Function GetDisplayAddress() As String
                Return $"{Address}, {City}, {State} {ZipCode}"
            End Function
            
            Public Function GetContactInfo() As String
                Return $"Email: {Email}, Phone: {Phone}"
            End Function
            
#End Region
            
#Region "Communication Methods"
            
            Public Sub SendWelcomeEmail()
                emailService.SendWelcome(Email, Name)
                LogActivity("Welcome email sent")
            End Sub
            
            Public Sub SendNotification(message As String)
                emailService.SendNotification(Email, message)
                LogActivity($"Notification sent: {message}")
            End Sub
            
#End Region
            
#Region "Private Helper Methods"
            
            Private Sub InitializeDefaults()
                DateCreated = DateTime.Now
                IsActive = True
                Status = "Active"
            End Sub
            
            Private Function ValidateAll() As Boolean
                Return ValidateName() AndAlso ValidateEmail() AndAlso ValidatePhone()
            End Function
            
            Private Sub LogActivity(activity As String)
                logger.Log($"User {Id}: {activity}")
            End Sub
            
            Private Sub MapFromData(userData As Object)
                ' Map data from repository object
            End Sub
            
#End Region
            
        End Class
        
        ' GOOD: Service class with logical region organization
        Class GoodOrderServiceWithRegions
            
#Region "Fields and Properties"
            
            Private orderRepository As IOrderRepository
            Private paymentService As IPaymentService
            Private inventoryService As IInventoryService
            Private emailService As IEmailService
            Private logger As ILogger
            
            Public Property CurrentOrder As Order
            
#End Region
            
#Region "Constructor and Initialization"
            
            Public Sub New(orderRepo As IOrderRepository, 
                          paymentSvc As IPaymentService,
                          inventorySvc As IInventoryService,
                          emailSvc As IEmailService,
                          loggerSvc As ILogger)
                orderRepository = orderRepo
                paymentService = paymentSvc
                inventoryService = inventorySvc
                emailService = emailSvc
                logger = loggerSvc
            End Sub
            
#End Region
            
#Region "Order Processing Methods"
            
            Public Function ProcessOrder(order As Order) As OrderResult
                Try
                    ValidateOrder(order)
                    CalculateTotals(order)
                    ProcessPayment(order)
                    UpdateInventory(order)
                    SaveOrder(order)
                    SendConfirmationEmail(order)
                    
                    Return New OrderResult() With {.Success = True, .OrderId = order.Id}
                Catch ex As Exception
                    logger.LogError($"Order processing failed: {ex.Message}")
                    Return New OrderResult() With {.Success = False, .Error = ex.Message}
                End Try
            End Function
            
            Public Sub CancelOrder(orderId As Integer)
                Dim order = orderRepository.GetById(orderId)
                If order IsNot Nothing Then
                    order.Status = "Cancelled"
                    orderRepository.Update(order)
                    ProcessRefund(order)
                    SendCancellationEmail(order)
                End If
            End Sub
            
#End Region
            
#Region "Calculation Methods"
            
            Private Sub CalculateTotals(order As Order)
                order.Subtotal = CalculateSubtotal(order.Items)
                order.Tax = CalculateTax(order.Subtotal)
                order.Shipping = CalculateShipping(order)
                order.Total = order.Subtotal + order.Tax + order.Shipping
            End Sub
            
            Private Function CalculateSubtotal(items As List(Of OrderItem)) As Decimal
                Return items.Sum(Function(item) item.Price * item.Quantity)
            End Function
            
            Private Function CalculateTax(subtotal As Decimal) As Decimal
                Return subtotal * 0.08D ' 8% tax rate
            End Function
            
            Private Function CalculateShipping(order As Order) As Decimal
                ' Shipping calculation logic
                Return 9.99D
            End Function
            
#End Region
            
#Region "Validation Methods"
            
            Private Sub ValidateOrder(order As Order)
                If order Is Nothing Then
                    Throw New ArgumentNullException(NameOf(order))
                End If
                
                If order.Items Is Nothing OrElse order.Items.Count = 0 Then
                    Throw New InvalidOperationException("Order must contain items")
                End If
                
                ValidateCustomer(order.CustomerId)
                ValidateItems(order.Items)
                ValidatePaymentMethod(order.PaymentMethod)
            End Sub
            
            Private Sub ValidateCustomer(customerId As Integer)
                ' Customer validation logic
            End Sub
            
            Private Sub ValidateItems(items As List(Of OrderItem))
                ' Items validation logic
            End Sub
            
            Private Sub ValidatePaymentMethod(paymentMethod As String)
                ' Payment method validation logic
            End Sub
            
#End Region
            
#Region "Payment and Inventory Methods"
            
            Private Sub ProcessPayment(order As Order)
                paymentService.ProcessPayment(order.PaymentMethod, order.Total)
            End Sub
            
            Private Sub ProcessRefund(order As Order)
                paymentService.ProcessRefund(order.PaymentMethod, order.Total)
            End Sub
            
            Private Sub UpdateInventory(order As Order)
                For Each item In order.Items
                    inventoryService.UpdateStock(item.ProductId, -item.Quantity)
                Next
            End Sub
            
#End Region
            
#Region "Data Persistence Methods"
            
            Private Sub SaveOrder(order As Order)
                order.OrderDate = DateTime.Now
                order.Status = "Confirmed"
                orderRepository.Save(order)
            End Sub
            
#End Region
            
#Region "Communication Methods"
            
            Private Sub SendConfirmationEmail(order As Order)
                emailService.SendOrderConfirmation(order.CustomerEmail, order)
            End Sub
            
            Private Sub SendCancellationEmail(order As Order)
                emailService.SendOrderCancellation(order.CustomerEmail, order)
            End Sub
            
#End Region
            
        End Class
        
        ' GOOD: Large utility class with clear region organization
        Class GoodUtilityClassWithRegions
            
#Region "String Utilities"
            
            Public Shared Function IsValidEmail(email As String) As Boolean
                Return Not String.IsNullOrEmpty(email) AndAlso email.Contains("@")
            End Function
            
            Public Shared Function FormatPhoneNumber(phone As String) As String
                ' Phone formatting logic
                Return phone
            End Function
            
            Public Shared Function SanitizeInput(input As String) As String
                ' Input sanitization logic
                Return input
            End Function
            
#End Region
            
#Region "Date and Time Utilities"
            
            Public Shared Function FormatDate(dateValue As DateTime) As String
                Return dateValue.ToString("MM/dd/yyyy")
            End Function
            
            Public Shared Function CalculateAge(birthDate As DateTime) As Integer
                Return DateTime.Now.Year - birthDate.Year
            End Function
            
            Public Shared Function IsBusinessDay(dateValue As DateTime) As Boolean
                Return dateValue.DayOfWeek <> DayOfWeek.Saturday AndAlso 
                       dateValue.DayOfWeek <> DayOfWeek.Sunday
            End Function
            
#End Region
            
#Region "Numeric Utilities"
            
            Public Shared Function FormatCurrency(amount As Decimal) As String
                Return amount.ToString("C")
            End Function
            
            Public Shared Function CalculatePercentage(value As Decimal, total As Decimal) As Decimal
                If total = 0 Then Return 0
                Return (value / total) * 100
            End Function
            
            Public Shared Function RoundToNearestCent(amount As Decimal) As Decimal
                Return Math.Round(amount, 2)
            End Function
            
#End Region
            
#Region "Collection Utilities"
            
            Public Shared Function IsNullOrEmpty(Of T)(collection As IEnumerable(Of T)) As Boolean
                Return collection Is Nothing OrElse Not collection.Any()
            End Function
            
            Public Shared Function SafeGet(Of T)(list As List(Of T), index As Integer) As T
                If list IsNot Nothing AndAlso index >= 0 AndAlso index < list.Count Then
                    Return list(index)
                End If
                Return Nothing
            End Function
            
#End Region
            
#Region "File and Path Utilities"
            
            Public Shared Function GetSafeFileName(fileName As String) As String
                ' Safe filename logic
                Return fileName
            End Function
            
            Public Shared Function EnsureDirectoryExists(path As String) As Boolean
                ' Directory creation logic
                Return True
            End Function
            
#End Region
            
        End Class
        
        ' Supporting interfaces and classes
        Interface ILogger
            Sub Log(message As String)
            Sub LogError(message As String)
        End Interface
        
        Interface IEmailService
            Sub SendWelcome(email As String, name As String)
            Sub SendNotification(email As String, message As String)
            Sub SendOrderConfirmation(email As String, order As Order)
            Sub SendOrderCancellation(email As String, order As Order)
        End Interface
        
        Interface IUserRepository
            Sub Save(user As Object)
            Sub Update(user As Object)
            Sub Delete(id As Integer)
            Function GetById(id As Integer) As Object
        End Interface
        
        Interface IOrderRepository
            Sub Save(order As Order)
            Sub Update(order As Order)
            Function GetById(id As Integer) As Order
        End Interface
        
        Interface IPaymentService
            Sub ProcessPayment(paymentMethod As String, amount As Decimal)
            Sub ProcessRefund(paymentMethod As String, amount As Decimal)
        End Interface
        
        Interface IInventoryService
            Sub UpdateStock(productId As Integer, quantity As Integer)
        End Interface
        
        Class Order
            Public Property Id As Integer
            Public Property CustomerId As Integer
            Public Property CustomerEmail As String
            Public Property Items As List(Of OrderItem)
            Public Property Subtotal As Decimal
            Public Property Tax As Decimal
            Public Property Shipping As Decimal
            Public Property Total As Decimal
            Public Property OrderDate As DateTime
            Public Property Status As String
            Public Property PaymentMethod As String
        End Class
        
        Class OrderItem
            Public Property ProductId As Integer
            Public Property Price As Decimal
            Public Property Quantity As Integer
        End Class
        
        Class OrderResult
            Public Property Success As Boolean
            Public Property OrderId As Integer
            Public Property [Error] As String
        End Class
        
        Class EmailService
            Public Shared Sub SendWelcome(email As String, name As String)
            End Sub
            
            Public Shared Sub SendNotification(email As String, message As String)
            End Sub
        End Class
        
        Class Logger
            Public Shared Sub Log(message As String)
            End Sub
        End Class
    </script>
</body>
</html>
