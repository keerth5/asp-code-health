<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Factory Patterns Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing factory patterns - complex object creation logic scattered throughout codebase
        
        ' BAD: Complex object creation with multiple conditions
        Function BadCreatePaymentProcessor(paymentType As String) As Object
            ' BAD: Complex creation logic without factory pattern
            If paymentType = "CreditCard" Then
                Dim processor = New CreditCardProcessor()
                processor.SetMerchantId("12345")
                processor.SetApiKey("secret-key")
                Return processor
            ElseIf paymentType = "PayPal" Then
                Dim processor = New PayPalProcessor()
                processor.SetClientId("client-123")
                processor.SetSecretKey("secret-456")
                Return processor
            ElseIf paymentType = "BankTransfer" Then
                Dim processor = New BankTransferProcessor()
                processor.SetBankCode("BANK001")
                processor.SetRoutingNumber("123456789")
                Return processor
            Else
                Return Nothing
            End If
        End Function
        
        ' BAD: Scattered object creation without centralization
        Sub BadProcessOrders()
            ' BAD: Multiple object creations scattered throughout
            For Each orderType In orderTypes
                If orderType = "Standard" Then
                    Dim order = New StandardOrder()
                    order.Priority = 1
                    order.ShippingMethod = "Ground"
                    ProcessOrder(order)
                ElseIf orderType = "Express" Then
                    Dim order = New ExpressOrder()
                    order.Priority = 2
                    order.ShippingMethod = "Air"
                    ProcessOrder(order)
                ElseIf orderType = "Overnight" Then
                    Dim order = New OvernightOrder()
                    order.Priority = 3
                    order.ShippingMethod = "Overnight"
                    ProcessOrder(order)
                End If
            Next
        End Sub
        
        ' BAD: Type-based object creation without factory
        Function BadCreateHandler(handlerType As Type) As IHandler
            ' BAD: Type checking and creation logic mixed
            If handlerType.Equals(GetType(EmailHandler)) Then
                Dim handler = New EmailHandler()
                handler.SmtpServer = "smtp.company.com"
                handler.Port = 587
                Return handler
            ElseIf handlerType.Equals(GetType(SmsHandler)) Then
                Dim handler = New SmsHandler()
                handler.ApiEndpoint = "https://api.sms.com"
                handler.ApiKey = "sms-key-123"
                Return handler
            ElseIf handlerType.Equals(GetType(PushHandler)) Then
                Dim handler = New PushHandler()
                handler.ServerKey = "push-server-key"
                handler.SenderId = "123456789"
                Return handler
            End If
            Return Nothing
        End Function
        
        ' BAD: String-based object creation with repetitive logic
        Function BadCreateConnection(connectionType As String) As IConnection
            ' BAD: Repetitive creation logic
            Select Case connectionType.ToLower()
                Case "sql"
                    Dim conn = New SqlConnection()
                    conn.ConnectionString = GetConnectionString("sql")
                    conn.CommandTimeout = 30
                    Return conn
                Case "oracle"
                    Dim conn = New OracleConnection()
                    conn.ConnectionString = GetConnectionString("oracle")
                    conn.CommandTimeout = 30
                    Return conn
                Case "mysql"
                    Dim conn = New MySqlConnection()
                    conn.ConnectionString = GetConnectionString("mysql")
                    conn.CommandTimeout = 30
                    Return conn
            End Select
            Return Nothing
        End Function
        
        ' BAD: Complex validation and creation mixed
        Function BadCreateValidator(validationType As String, rules As String()) As IValidator
            ' BAD: Validation and creation logic intertwined
            If String.IsNullOrEmpty(validationType) Then
                Throw New ArgumentException("Validation type required")
            End If
            
            If validationType = "Email" Then
                Dim validator = New EmailValidator()
                For Each rule In rules
                    validator.AddRule(rule)
                Next
                Return validator
            ElseIf validationType = "Phone" Then
                Dim validator = New PhoneValidator()
                For Each rule In rules
                    validator.AddRule(rule)
                Next
                Return validator
            ElseIf validationType = "Address" Then
                Dim validator = New AddressValidator()
                For Each rule In rules
                    validator.AddRule(rule)
                Next
                Return validator
            End If
            
            Return Nothing
        End Function
        
        ' BAD: Nested object creation without abstraction
        Sub BadSetupApplication()
            ' BAD: Complex setup without factory abstraction
            If applicationMode = "Development" Then
                Dim logger = New FileLogger()
                logger.LogLevel = LogLevel.Debug
                logger.FilePath = "dev.log"
                
                Dim cache = New MemoryCache()
                cache.MaxSize = 100
                
                Dim database = New LocalDatabase()
                database.ConnectionString = "local-db"
                
                SetupComponents(logger, cache, database)
            ElseIf applicationMode = "Production" Then
                Dim logger = New DatabaseLogger()
                logger.LogLevel = LogLevel.Error
                logger.ConnectionString = "prod-log-db"
                
                Dim cache = New RedisCache()
                cache.ConnectionString = "redis-prod"
                
                Dim database = New SqlServerDatabase()
                database.ConnectionString = "prod-db"
                
                SetupComponents(logger, cache, database)
            End If
        End Sub
        
        ' BAD: Repeated object creation patterns
        Function BadCreateReports() As List(Of IReport)
            Dim reports As New List(Of IReport)()
            
            ' BAD: Repetitive creation patterns
            Dim salesReport = New SalesReport()
            salesReport.DateRange = GetDateRange("monthly")
            salesReport.Format = "PDF"
            reports.Add(salesReport)
            
            Dim inventoryReport = New InventoryReport()
            inventoryReport.DateRange = GetDateRange("weekly")
            inventoryReport.Format = "Excel"
            reports.Add(inventoryReport)
            
            Dim customerReport = New CustomerReport()
            customerReport.DateRange = GetDateRange("daily")
            customerReport.Format = "CSV"
            reports.Add(customerReport)
            
            Return reports
        End Function
        
        ' GOOD: Proper factory pattern implementations
        
        ' GOOD: Simple factory pattern
        Class GoodPaymentProcessorFactory
            Public Shared Function CreateProcessor(paymentType As String) As IPaymentProcessor
                Select Case paymentType.ToLower()
                    Case "creditcard"
                        Return CreateCreditCardProcessor()
                    Case "paypal"
                        Return CreatePayPalProcessor()
                    Case "banktransfer"
                        Return CreateBankTransferProcessor()
                    Case Else
                        Throw New ArgumentException($"Unsupported payment type: {paymentType}")
                End Select
            End Function
            
            Private Shared Function CreateCreditCardProcessor() As IPaymentProcessor
                Dim processor As New CreditCardProcessor()
                processor.SetMerchantId(ConfigurationManager.AppSettings("MerchantId"))
                processor.SetApiKey(ConfigurationManager.AppSettings("CreditCardApiKey"))
                Return processor
            End Function
            
            Private Shared Function CreatePayPalProcessor() As IPaymentProcessor
                Dim processor As New PayPalProcessor()
                processor.SetClientId(ConfigurationManager.AppSettings("PayPalClientId"))
                processor.SetSecretKey(ConfigurationManager.AppSettings("PayPalSecret"))
                Return processor
            End Function
            
            Private Shared Function CreateBankTransferProcessor() As IPaymentProcessor
                Dim processor As New BankTransferProcessor()
                processor.SetBankCode(ConfigurationManager.AppSettings("BankCode"))
                processor.SetRoutingNumber(ConfigurationManager.AppSettings("RoutingNumber"))
                Return processor
            End Function
        End Class
        
        ' GOOD: Abstract factory pattern
        MustInherit Class GoodOrderFactory
            Public MustOverride Function CreateOrder() As IOrder
            Public MustOverride Function CreateShipping() As IShipping
            
            Public Shared Function GetFactory(orderType As String) As GoodOrderFactory
                Select Case orderType.ToLower()
                    Case "standard"
                        Return New StandardOrderFactory()
                    Case "express"
                        Return New ExpressOrderFactory()
                    Case "overnight"
                        Return New OvernightOrderFactory()
                    Case Else
                        Throw New ArgumentException($"Unknown order type: {orderType}")
                End Select
            End Function
        End Class
        
        Class StandardOrderFactory
            Inherits GoodOrderFactory
            
            Public Overrides Function CreateOrder() As IOrder
                Return New StandardOrder()
            End Function
            
            Public Overrides Function CreateShipping() As IShipping
                Return New GroundShipping()
            End Function
        End Class
        
        Class ExpressOrderFactory
            Inherits GoodOrderFactory
            
            Public Overrides Function CreateOrder() As IOrder
                Return New ExpressOrder()
            End Function
            
            Public Overrides Function CreateShipping() As IShipping
                Return New AirShipping()
            End Function
        End Class
        
        Class OvernightOrderFactory
            Inherits GoodOrderFactory
            
            Public Overrides Function CreateOrder() As IOrder
                Return New OvernightOrder()
            End Function
            
            Public Overrides Function CreateShipping() As IShipping
                Return New OvernightShipping()
            End Function
        End Class
        
        ' GOOD: Factory method pattern
        MustInherit Class GoodHandler
            Public MustOverride Sub Handle(message As String)
            
            Public Shared Function CreateHandler(handlerType As Type) As GoodHandler
                If GetType(IEmailHandler).IsAssignableFrom(handlerType) Then
                    Return EmailHandlerFactory.Create()
                ElseIf GetType(ISmsHandler).IsAssignableFrom(handlerType) Then
                    Return SmsHandlerFactory.Create()
                ElseIf GetType(IPushHandler).IsAssignableFrom(handlerType) Then
                    Return PushHandlerFactory.Create()
                Else
                    Throw New ArgumentException($"Unsupported handler type: {handlerType}")
                End If
            End Function
        End Class
        
        ' GOOD: Builder pattern for complex object creation
        Class GoodConnectionBuilder
            Private _connectionType As String
            Private _connectionString As String
            Private _timeout As Integer = 30
            Private _retryCount As Integer = 3
            
            Public Function SetConnectionType(connectionType As String) As GoodConnectionBuilder
                _connectionType = connectionType
                Return Me
            End Function
            
            Public Function SetConnectionString(connectionString As String) As GoodConnectionBuilder
                _connectionString = connectionString
                Return Me
            End Function
            
            Public Function SetTimeout(timeout As Integer) As GoodConnectionBuilder
                _timeout = timeout
                Return Me
            End Function
            
            Public Function SetRetryCount(retryCount As Integer) As GoodConnectionBuilder
                _retryCount = retryCount
                Return Me
            End Function
            
            Public Function Build() As IConnection
                ValidateParameters()
                
                Select Case _connectionType.ToLower()
                    Case "sql"
                        Return New SqlConnection(_connectionString, _timeout, _retryCount)
                    Case "oracle"
                        Return New OracleConnection(_connectionString, _timeout, _retryCount)
                    Case "mysql"
                        Return New MySqlConnection(_connectionString, _timeout, _retryCount)
                    Case Else
                        Throw New ArgumentException($"Unsupported connection type: {_connectionType}")
                End Select
            End Function
            
            Private Sub ValidateParameters()
                If String.IsNullOrEmpty(_connectionType) Then
                    Throw New ArgumentException("Connection type is required")
                End If
                If String.IsNullOrEmpty(_connectionString) Then
                    Throw New ArgumentException("Connection string is required")
                End If
            End Sub
        End Class
        
        ' GOOD: Dependency injection with factory
        Interface IGoodComponentFactory
            Function CreateLogger() As ILogger
            Function CreateCache() As ICache
            Function CreateDatabase() As IDatabase
        End Interface
        
        Class GoodDevelopmentFactory
            Implements IGoodComponentFactory
            
            Public Function CreateLogger() As ILogger Implements IGoodComponentFactory.CreateLogger
                Return New FileLogger("dev.log", LogLevel.Debug)
            End Function
            
            Public Function CreateCache() As ICache Implements IGoodComponentFactory.CreateCache
                Return New MemoryCache(100)
            End Function
            
            Public Function CreateDatabase() As IDatabase Implements IGoodComponentFactory.CreateDatabase
                Return New LocalDatabase("local-db")
            End Function
        End Class
        
        Class GoodProductionFactory
            Implements IGoodComponentFactory
            
            Public Function CreateLogger() As ILogger Implements IGoodComponentFactory.CreateLogger
                Return New DatabaseLogger("prod-log-db", LogLevel.Error)
            End Function
            
            Public Function CreateCache() As ICache Implements IGoodComponentFactory.CreateCache
                Return New RedisCache("redis-prod")
            End Function
            
            Public Function CreateDatabase() As IDatabase Implements IGoodComponentFactory.CreateDatabase
                Return New SqlServerDatabase("prod-db")
            End Function
        End Class
        
        ' GOOD: Generic factory with registration
        Class GoodGenericFactory(Of T)
            Private Shared ReadOnly _creators As New Dictionary(Of String, Func(Of T))()
            
            Public Shared Sub RegisterCreator(key As String, creator As Func(Of T))
                _creators(key) = creator
            End Sub
            
            Public Shared Function Create(key As String) As T
                If _creators.ContainsKey(key) Then
                    Return _creators(key)()
                Else
                    Throw New ArgumentException($"No creator registered for key: {key}")
                End If
            End Function
        End Class
        
        ' Supporting classes and interfaces
        Interface IPaymentProcessor
            Sub SetMerchantId(merchantId As String)
            Sub SetApiKey(apiKey As String)
            Sub SetClientId(clientId As String)
            Sub SetSecretKey(secretKey As String)
            Sub SetBankCode(bankCode As String)
            Sub SetRoutingNumber(routingNumber As String)
        End Interface
        
        Class CreditCardProcessor
            Implements IPaymentProcessor
            
            Public Sub SetMerchantId(merchantId As String) Implements IPaymentProcessor.SetMerchantId
            End Sub
            
            Public Sub SetApiKey(apiKey As String) Implements IPaymentProcessor.SetApiKey
            End Sub
            
            Public Sub SetClientId(clientId As String) Implements IPaymentProcessor.SetClientId
            End Sub
            
            Public Sub SetSecretKey(secretKey As String) Implements IPaymentProcessor.SetSecretKey
            End Sub
            
            Public Sub SetBankCode(bankCode As String) Implements IPaymentProcessor.SetBankCode
            End Sub
            
            Public Sub SetRoutingNumber(routingNumber As String) Implements IPaymentProcessor.SetRoutingNumber
            End Sub
        End Class
        
        Class PayPalProcessor
            Implements IPaymentProcessor
            
            Public Sub SetMerchantId(merchantId As String) Implements IPaymentProcessor.SetMerchantId
            End Sub
            
            Public Sub SetApiKey(apiKey As String) Implements IPaymentProcessor.SetApiKey
            End Sub
            
            Public Sub SetClientId(clientId As String) Implements IPaymentProcessor.SetClientId
            End Sub
            
            Public Sub SetSecretKey(secretKey As String) Implements IPaymentProcessor.SetSecretKey
            End Sub
            
            Public Sub SetBankCode(bankCode As String) Implements IPaymentProcessor.SetBankCode
            End Sub
            
            Public Sub SetRoutingNumber(routingNumber As String) Implements IPaymentProcessor.SetRoutingNumber
            End Sub
        End Class
        
        Class BankTransferProcessor
            Implements IPaymentProcessor
            
            Public Sub SetMerchantId(merchantId As String) Implements IPaymentProcessor.SetMerchantId
            End Sub
            
            Public Sub SetApiKey(apiKey As String) Implements IPaymentProcessor.SetApiKey
            End Sub
            
            Public Sub SetClientId(clientId As String) Implements IPaymentProcessor.SetClientId
            End Sub
            
            Public Sub SetSecretKey(secretKey As String) Implements IPaymentProcessor.SetSecretKey
            End Sub
            
            Public Sub SetBankCode(bankCode As String) Implements IPaymentProcessor.SetBankCode
            End Sub
            
            Public Sub SetRoutingNumber(routingNumber As String) Implements IPaymentProcessor.SetRoutingNumber
            End Sub
        End Class
        
        ' Additional supporting classes
        Interface IOrder
        End Interface
        
        Interface IShipping
        End Interface
        
        Interface IHandler
        End Interface
        
        Interface IEmailHandler
            Inherits IHandler
        End Interface
        
        Interface ISmsHandler
            Inherits IHandler
        End Interface
        
        Interface IPushHandler
            Inherits IHandler
        End Interface
        
        Interface IConnection
        End Interface
        
        Interface IValidator
            Sub AddRule(rule As String)
        End Interface
        
        Interface IReport
        End Interface
        
        Interface ILogger
        End Interface
        
        Interface ICache
        End Interface
        
        Interface IDatabase
        End Interface
        
        Class StandardOrder
            Implements IOrder
            Public Property Priority As Integer
            Public Property ShippingMethod As String
        End Class
        
        Class ExpressOrder
            Implements IOrder
            Public Property Priority As Integer
            Public Property ShippingMethod As String
        End Class
        
        Class OvernightOrder
            Implements IOrder
            Public Property Priority As Integer
            Public Property ShippingMethod As String
        End Class
        
        Class GroundShipping
            Implements IShipping
        End Class
        
        Class AirShipping
            Implements IShipping
        End Class
        
        Class OvernightShipping
            Implements IShipping
        End Class
        
        Class EmailHandler
            Implements IEmailHandler
            Public Property SmtpServer As String
            Public Property Port As Integer
            
            Public Sub Handle(message As String) Implements IHandler.Handle
            End Sub
        End Class
        
        Class SmsHandler
            Implements ISmsHandler
            Public Property ApiEndpoint As String
            Public Property ApiKey As String
            
            Public Sub Handle(message As String) Implements IHandler.Handle
            End Sub
        End Class
        
        Class PushHandler
            Implements IPushHandler
            Public Property ServerKey As String
            Public Property SenderId As String
            
            Public Sub Handle(message As String) Implements IHandler.Handle
            End Sub
        End Class
        
        Class SqlConnection
            Implements IConnection
            
            Public Property ConnectionString As String
            Public Property CommandTimeout As Integer
            
            Public Sub New()
            End Sub
            
            Public Sub New(connectionString As String, timeout As Integer, retryCount As Integer)
                Me.ConnectionString = connectionString
                Me.CommandTimeout = timeout
            End Sub
        End Class
        
        Class OracleConnection
            Implements IConnection
            
            Public Property ConnectionString As String
            Public Property CommandTimeout As Integer
            
            Public Sub New()
            End Sub
            
            Public Sub New(connectionString As String, timeout As Integer, retryCount As Integer)
                Me.ConnectionString = connectionString
                Me.CommandTimeout = timeout
            End Sub
        End Class
        
        Class MySqlConnection
            Implements IConnection
            
            Public Property ConnectionString As String
            Public Property CommandTimeout As Integer
            
            Public Sub New()
            End Sub
            
            Public Sub New(connectionString As String, timeout As Integer, retryCount As Integer)
                Me.ConnectionString = connectionString
                Me.CommandTimeout = timeout
            End Sub
        End Class
        
        Class EmailValidator
            Implements IValidator
            
            Public Sub AddRule(rule As String) Implements IValidator.AddRule
            End Sub
        End Class
        
        Class PhoneValidator
            Implements IValidator
            
            Public Sub AddRule(rule As String) Implements IValidator.AddRule
            End Sub
        End Class
        
        Class AddressValidator
            Implements IValidator
            
            Public Sub AddRule(rule As String) Implements IValidator.AddRule
            End Sub
        End Class
        
        Class FileLogger
            Implements ILogger
            
            Public Property LogLevel As LogLevel
            Public Property FilePath As String
            
            Public Sub New()
            End Sub
            
            Public Sub New(filePath As String, logLevel As LogLevel)
                Me.FilePath = filePath
                Me.LogLevel = logLevel
            End Sub
        End Class
        
        Class DatabaseLogger
            Implements ILogger
            
            Public Property LogLevel As LogLevel
            Public Property ConnectionString As String
            
            Public Sub New()
            End Sub
            
            Public Sub New(connectionString As String, logLevel As LogLevel)
                Me.ConnectionString = connectionString
                Me.LogLevel = logLevel
            End Sub
        End Class
        
        Class MemoryCache
            Implements ICache
            
            Public Property MaxSize As Integer
            
            Public Sub New()
            End Sub
            
            Public Sub New(maxSize As Integer)
                Me.MaxSize = maxSize
            End Sub
        End Class
        
        Class RedisCache
            Implements ICache
            
            Public Property ConnectionString As String
            
            Public Sub New()
            End Sub
            
            Public Sub New(connectionString As String)
                Me.ConnectionString = connectionString
            End Sub
        End Class
        
        Class LocalDatabase
            Implements IDatabase
            
            Public Property ConnectionString As String
            
            Public Sub New()
            End Sub
            
            Public Sub New(connectionString As String)
                Me.ConnectionString = connectionString
            End Sub
        End Class
        
        Class SqlServerDatabase
            Implements IDatabase
            
            Public Property ConnectionString As String
            
            Public Sub New()
            End Sub
            
            Public Sub New(connectionString As String)
                Me.ConnectionString = connectionString
            End Sub
        End Class
        
        Class SalesReport
            Implements IReport
            
            Public Property DateRange As String
            Public Property Format As String
        End Class
        
        Class InventoryReport
            Implements IReport
            
            Public Property DateRange As String
            Public Property Format As String
        End Class
        
        Class CustomerReport
            Implements IReport
            
            Public Property DateRange As String
            Public Property Format As String
        End Class
        
        Class EmailHandlerFactory
            Public Shared Function Create() As GoodHandler
                Return New EmailHandler()
            End Function
        End Class
        
        Class SmsHandlerFactory
            Public Shared Function Create() As GoodHandler
                Return New SmsHandler()
            End Function
        End Class
        
        Class PushHandlerFactory
            Public Shared Function Create() As GoodHandler
                Return New PushHandler()
            End Function
        End Class
        
        Class ConfigurationManager
            Public Shared ReadOnly Property AppSettings As Dictionary(Of String, String)
                Get
                    Return New Dictionary(Of String, String)()
                End Get
            End Property
        End Class
        
        Enum LogLevel
            Debug
            Info
            Warning
            [Error]
        End Enum
        
        ' Helper methods and properties
        Private orderTypes As String() = {"Standard", "Express", "Overnight"}
        Private applicationMode As String = "Development"
        
        Sub ProcessOrder(order As IOrder)
        End Sub
        
        Function GetConnectionString(connectionType As String) As String
            Return $"connection-{connectionType}"
        End Function
        
        Function GetDateRange(period As String) As String
            Return $"range-{period}"
        End Function
        
        Sub SetupComponents(logger As ILogger, cache As ICache, database As IDatabase)
        End Sub
    </script>
</body>
</html>
