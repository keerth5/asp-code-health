<%@ Page Language="VB" %>
<html>
<head>
    <title>Shotgun Surgery Anti-Pattern Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Shotgun surgery anti-pattern - changes requiring modifications across multiple classes
        
        ' BAD: Public methods that require changes across multiple classes
        Public Shared Function BadGetUserData() As UserData
            ' This method forces changes in multiple places when modified
            Dim user As New UserData()
            user.Name = DatabaseHelper.GetUserName()
            user.Email = EmailValidator.ValidateAndFormat()
            user.Permissions = SecurityManager.GetPermissions()
            user.Profile = ProfileManager.LoadProfile()
            Return user
        End Function
        
        Public Shared Sub BadUpdateUserSettings()
            ' Changes here require updates in multiple classes
            ConfigManager.UpdateSetting("theme", "dark")
            CacheManager.InvalidateUserCache()
            NotificationService.SendUpdateNotification()
            AuditLogger.LogSettingsChange()
            DatabaseHelper.UpdateUserPreferences()
        End Sub
        
        Public Shared Function BadSaveOrderData() As Boolean
            ' Saving an order touches many systems
            OrderValidator.ValidateOrder()
            InventoryManager.UpdateStock()
            PaymentProcessor.ProcessPayment()
            ShippingCalculator.CalculateShipping()
            TaxCalculator.CalculateTax()
            EmailService.SendConfirmation()
            ReportGenerator.UpdateSalesReport()
            Return True
        End Function
        
        ' BAD: Class with many external dependencies that change together
        Class BadOrderProcessor
            Private Shared orderValidator As OrderValidator
            Private Shared inventoryManager As InventoryManager
            Private Shared paymentProcessor As PaymentProcessor
            Private Shared shippingCalculator As ShippingCalculator
            Private Shared taxCalculator As TaxCalculator
            Private Shared emailService As EmailService
            Private Shared reportGenerator As ReportGenerator
            Private Shared auditLogger As AuditLogger
            
            Public Shared Function ProcessOrder() As Boolean
                ' Any change to order processing affects all these classes
                Return True
            End Function
        End Class
        
        ' BAD: Multiple public constants that are used across many classes
        Public Shared ReadOnly USER_STATUS_ACTIVE As String = "ACTIVE"
        Public Shared ReadOnly USER_STATUS_INACTIVE As String = "INACTIVE"
        Public Shared ReadOnly USER_STATUS_PENDING As String = "PENDING"
        Public Shared ReadOnly USER_STATUS_SUSPENDED As String = "SUSPENDED"
        
        Public Shared ReadOnly ORDER_STATUS_NEW As String = "NEW"
        Public Shared ReadOnly ORDER_STATUS_PROCESSING As String = "PROCESSING"
        Public Shared ReadOnly ORDER_STATUS_SHIPPED As String = "SHIPPED"
        Public Shared ReadOnly ORDER_STATUS_DELIVERED As String = "DELIVERED"
        
        ' BAD: Utility class that many other classes depend on
        Public Class BadUtilityClass
            Public Shared Function FormatCurrency(amount As Decimal) As String
                ' Used by OrderManager, PaymentProcessor, ReportGenerator, InvoiceGenerator
                Return amount.ToString("C")
            End Function
            
            Public Shared Function ValidateEmail(email As String) As Boolean
                ' Used by UserManager, CustomerService, NotificationService, RegistrationHandler
                Return email.Contains("@")
            End Function
            
            Public Shared Function GenerateId() As String
                ' Used by OrderService, UserService, ProductService, CategoryService
                Return Guid.NewGuid().ToString()
            End Function
            
            Public Shared Function LogError(message As String)
                ' Used by all classes for error logging
                ' Any change here affects entire application
            End Sub
        End Class
        
        ' BAD: Configuration class that many classes depend on
        Public Class BadConfigurationManager
            Public Shared ReadOnly DATABASE_CONNECTION As String = "server=localhost"
            Public Shared ReadOnly EMAIL_SERVER As String = "smtp.company.com"
            Public Shared ReadOnly API_ENDPOINT As String = "https://api.company.com"
            Public Shared ReadOnly CACHE_TIMEOUT As Integer = 300
            Public Shared ReadOnly MAX_RETRY_COUNT As Integer = 3
            Public Shared ReadOnly DEFAULT_PAGE_SIZE As Integer = 50
            
            ' Any change to these settings affects multiple classes
        End Class
        
        ' BAD: Data access methods that multiple classes use
        Public Shared Function BadGetCustomerById(customerId As Integer) As Customer
            ' Used by OrderService, BillingService, SupportService, MarketingService
            ' Changes to customer data structure affect all these services
            Return New Customer()
        End Function
        
        Public Shared Sub BadUpdateCustomerData(customer As Customer)
            ' Updates affect OrderProcessor, BillingProcessor, NotificationService
            DatabaseHelper.UpdateCustomer(customer)
            CacheManager.InvalidateCustomer(customer.Id)
            AuditLogger.LogCustomerUpdate(customer.Id)
            SearchIndexer.UpdateCustomerIndex(customer)
        End Sub
        
        ' GOOD: Well-encapsulated classes that minimize cross-cutting changes
        
        ' GOOD: Encapsulated order processing with clear boundaries
        Public Class GoodOrderService
            Private orderRepository As IOrderRepository
            Private eventPublisher As IEventPublisher
            
            Public Sub New(repository As IOrderRepository, publisher As IEventPublisher)
                Me.orderRepository = repository
                Me.eventPublisher = publisher
            End Sub
            
            Public Function ProcessOrder(order As Order) As OrderResult
                ' Encapsulated logic that doesn't require changes across multiple classes
                Dim result As OrderResult = ValidateOrder(order)
                If result.IsValid Then
                    orderRepository.Save(order)
                    eventPublisher.Publish(New OrderProcessedEvent(order))
                End If
                Return result
            End Function
            
            Private Function ValidateOrder(order As Order) As OrderResult
                ' Internal validation logic
                Return New OrderResult() With {.IsValid = True}
            End Function
        End Class
        
        ' GOOD: Event-driven architecture reduces coupling
        Public Class GoodEventPublisher
            Implements IEventPublisher
            
            Private handlers As New List(Of IEventHandler)()
            
            Public Sub Subscribe(handler As IEventHandler)
                handlers.Add(handler)
            End Sub
            
            Public Sub Publish(eventData As Object) Implements IEventPublisher.Publish
                For Each handler In handlers
                    handler.Handle(eventData)
                Next
            End Sub
        End Class
        
        ' GOOD: Repository pattern isolates data access
        Public Class GoodOrderRepository
            Implements IOrderRepository
            
            Private connectionFactory As IConnectionFactory
            
            Public Sub New(factory As IConnectionFactory)
                Me.connectionFactory = factory
            End Sub
            
            Public Sub Save(order As Order) Implements IOrderRepository.Save
                ' Isolated data access logic
                Using connection = connectionFactory.CreateConnection()
                    ' Save order logic
                End Using
            End Sub
            
            Public Function GetById(id As Integer) As Order Implements IOrderRepository.GetById
                ' Isolated retrieval logic
                Return New Order()
            End Function
        End Class
        
        ' GOOD: Configuration with dependency injection
        Public Class GoodConfiguration
            Implements IConfiguration
            
            Private settings As Dictionary(Of String, String)
            
            Public Sub New()
                settings = LoadSettings()
            End Sub
            
            Public Function GetValue(key As String) As String Implements IConfiguration.GetValue
                Return If(settings.ContainsKey(key), settings(key), String.Empty)
            End Function
            
            Private Function LoadSettings() As Dictionary(Of String, String)
                ' Load from configuration source
                Return New Dictionary(Of String, String)()
            End Function
        End Class
        
        ' GOOD: Service with clear single responsibility
        Public Class GoodCustomerService
            Private customerRepository As ICustomerRepository
            Private eventPublisher As IEventPublisher
            
            Public Sub New(repository As ICustomerRepository, publisher As IEventPublisher)
                Me.customerRepository = repository
                Me.eventPublisher = publisher
            End Sub
            
            Public Function GetCustomer(customerId As Integer) As Customer
                Return customerRepository.GetById(customerId)
            End Function
            
            Public Sub UpdateCustomer(customer As Customer)
                customerRepository.Update(customer)
                eventPublisher.Publish(New CustomerUpdatedEvent(customer))
            End Sub
        End Class
        
        ' GOOD: Factory pattern for object creation
        Public Class GoodServiceFactory
            Private configuration As IConfiguration
            
            Public Sub New(config As IConfiguration)
                Me.configuration = config
            End Sub
            
            Public Function CreateOrderService() As IOrderService
                Dim repository = CreateOrderRepository()
                Dim publisher = CreateEventPublisher()
                Return New GoodOrderService(repository, publisher)
            End Function
            
            Private Function CreateOrderRepository() As IOrderRepository
                Dim connectionFactory = CreateConnectionFactory()
                Return New GoodOrderRepository(connectionFactory)
            End Function
            
            Private Function CreateEventPublisher() As IEventPublisher
                Return New GoodEventPublisher()
            End Function
            
            Private Function CreateConnectionFactory() As IConnectionFactory
                Return New SqlConnectionFactory(configuration.GetValue("ConnectionString"))
            End Function
        End Class
        
        ' Supporting interfaces and classes
        Interface IOrderRepository
            Sub Save(order As Order)
            Function GetById(id As Integer) As Order
            Sub Update(customer As Customer)
        End Interface
        
        Interface IEventPublisher
            Sub Publish(eventData As Object)
        End Interface
        
        Interface IEventHandler
            Sub Handle(eventData As Object)
        End Interface
        
        Interface IConnectionFactory
            Function CreateConnection() As IDbConnection
        End Interface
        
        Interface IConfiguration
            Function GetValue(key As String) As String
        End Interface
        
        Interface ICustomerRepository
            Function GetById(id As Integer) As Customer
            Sub Update(customer As Customer)
        End Interface
        
        Interface IOrderService
            Function ProcessOrder(order As Order) As OrderResult
        End Interface
        
        ' Data classes
        Class Order
            Public Property Id As Integer
            Public Property CustomerId As Integer
            Public Property Total As Decimal
        End Class
        
        Class Customer
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Class UserData
            Public Property Name As String
            Public Property Email As String
            Public Property Permissions As List(Of String)
            Public Property Profile As Object
        End Class
        
        Class OrderResult
            Public Property IsValid As Boolean
            Public Property Errors As List(Of String)
        End Class
        
        Class OrderProcessedEvent
            Public Property Order As Order
            
            Public Sub New(order As Order)
                Me.Order = order
            End Sub
        End Class
        
        Class CustomerUpdatedEvent
            Public Property Customer As Customer
            
            Public Sub New(customer As Customer)
                Me.Customer = customer
            End Sub
        End Class
        
        Class SqlConnectionFactory
            Implements IConnectionFactory
            
            Private connectionString As String
            
            Public Sub New(connString As String)
                Me.connectionString = connString
            End Sub
            
            Public Function CreateConnection() As IDbConnection Implements IConnectionFactory.CreateConnection
                Return Nothing ' Would return actual connection
            End Function
        End Class
        
        ' Stub classes for bad examples
        Class DatabaseHelper
            Public Shared Function GetUserName() As String
                Return "User"
            End Function
            
            Public Shared Sub UpdateUserPreferences()
            End Sub
            
            Public Shared Sub UpdateCustomer(customer As Customer)
            End Sub
        End Class
        
        Class EmailValidator
            Public Shared Function ValidateAndFormat() As String
                Return "user@example.com"
            End Function
        End Class
        
        Class SecurityManager
            Public Shared Function GetPermissions() As List(Of String)
                Return New List(Of String)()
            End Function
        End Class
        
        Class ProfileManager
            Public Shared Function LoadProfile() As Object
                Return Nothing
            End Function
        End Class
        
        Class ConfigManager
            Public Shared Sub UpdateSetting(key As String, value As String)
            End Sub
        End Class
        
        Class CacheManager
            Public Shared Sub InvalidateUserCache()
            End Sub
            
            Public Shared Sub InvalidateCustomer(customerId As Integer)
            End Sub
        End Class
        
        Class NotificationService
            Public Shared Sub SendUpdateNotification()
            End Sub
        End Class
        
        Class AuditLogger
            Public Shared Sub LogSettingsChange()
            End Sub
            
            Public Shared Sub LogCustomerUpdate(customerId As Integer)
            End Sub
        End Class
        
        Class OrderValidator
            Public Shared Sub ValidateOrder()
            End Sub
        End Class
        
        Class InventoryManager
            Public Shared Sub UpdateStock()
            End Sub
        End Class
        
        Class PaymentProcessor
            Public Shared Sub ProcessPayment()
            End Sub
        End Class
        
        Class ShippingCalculator
            Public Shared Sub CalculateShipping()
            End Sub
        End Class
        
        Class TaxCalculator
            Public Shared Sub CalculateTax()
            End Sub
        End Class
        
        Class EmailService
            Public Shared Sub SendConfirmation()
            End Sub
        End Class
        
        Class ReportGenerator
            Public Shared Sub UpdateSalesReport()
            End Sub
        End Class
        
        Class SearchIndexer
            Public Shared Sub UpdateCustomerIndex(customer As Customer)
            End Sub
        End Class
    </script>
</body>
</html>
