<%@ Page Language="VB" %>
<html>
<head>
    <title>Feature Envy Code Smell Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Feature envy code smell - methods that use more features from other classes than their own
        
        Class CustomerProcessor
            Private customerId As Integer
            
            ' BAD: Method using more features from other objects than its own
            Function BadProcessCustomerOrder(customer As Customer, order As Order) As Boolean
                ' Uses customer object extensively
                customer.ValidateAddress()
                customer.CheckCreditLimit()
                customer.UpdateLastOrderDate()
                customer.SendNotification()
                customer.LogActivity("Order processed")
                
                ' Uses order object extensively  
                order.CalculateTotal()
                order.ApplyDiscounts()
                order.ValidateItems()
                order.UpdateInventory()
                order.GenerateInvoice()
                
                ' Minimal use of own features
                Return True
            End Function
            
            ' BAD: Method with excessive external object usage
            Sub BadUpdateCustomerProfile(customer As Customer)
                customer.FirstName = customer.GetFormattedName()
                customer.LastName = customer.GetLastName().ToUpper()
                customer.Email = customer.GetEmail().ToLower()
                customer.Phone = customer.FormatPhoneNumber()
                customer.Address.Street = customer.Address.GetFormattedStreet()
                customer.Address.City = customer.Address.GetCity()
                customer.Address.State = customer.Address.GetState()
                customer.Address.ZipCode = customer.Address.GetZipCode()
            End Sub
            
            ' BAD: Excessive use of Request/Session/Server objects
            Function BadProcessWebRequest() As String
                Request.QueryString("id").ToString()
                Request.Form("data").ToString()
                Request.Headers("authorization").ToString()
                Request.Cookies("session").Value.ToString()
                
                Session("userId") = Request.QueryString("id")
                Session("lastAccess") = DateTime.Now
                Session("permissions") = Request.Headers("permissions")
                Session.Timeout = 30
                
                Server.MapPath("~/data")
                Server.HtmlEncode(Request.Form("input"))
                Server.UrlEncode(Request.QueryString("redirect"))
                
                Response.Write("Processing...")
                Response.Redirect("success.aspx")
                Response.Cookies.Add(New HttpCookie("processed", "true"))
                
                Return "Processed"
            End Function
            
            ' BAD: Chain of method calls on external objects
            Function BadProcessPayment(payment As Payment) As Boolean
                payment.CreditCard.Validate().CheckExpiration().VerifySecurityCode().ProcessTransaction()
                payment.BillingAddress.Validate().Format().Normalize().Save()
                payment.Customer.UpdateCreditScore().SendReceipt().LogTransaction().UpdateHistory()
                Return True
            End Function
            
            ' BAD: Multiple object property chains
            Sub BadGenerateReport(customer As Customer, orders As List(Of Order))
                Dim report As String = ""
                report += customer.Profile.PersonalInfo.Name.FullName
                report += customer.Profile.ContactInfo.Email.Address
                report += customer.Profile.ContactInfo.Phone.Number
                report += customer.Account.Settings.Preferences.Theme
                report += customer.Account.Billing.PaymentMethod.Type
                
                For Each order In orders
                    report += order.Details.Items.Count.ToString()
                    report += order.Details.Shipping.Address.Street
                    report += order.Details.Payment.Method.Type
                    report += order.Status.Current.Description
                Next
            End Sub
            
            ' BAD: Extensive manipulation of external object state
            Sub BadConfigureUserSettings(user As User, settings As UserSettings)
                user.Preferences.Theme = settings.Display.Theme
                user.Preferences.Language = settings.Display.Language
                user.Preferences.Timezone = settings.Display.Timezone
                user.Notifications.Email = settings.Notifications.Email
                user.Notifications.SMS = settings.Notifications.SMS
                user.Notifications.Push = settings.Notifications.Push
                user.Security.TwoFactor = settings.Security.TwoFactor
                user.Security.PasswordPolicy = settings.Security.PasswordPolicy
                user.Privacy.DataSharing = settings.Privacy.DataSharing
                user.Privacy.Analytics = settings.Privacy.Analytics
            End Sub
            
            ' BAD: Method that mainly orchestrates other objects
            Function BadProcessBusinessWorkflow(context As BusinessContext) As WorkflowResult
                context.ValidationService.ValidateInput(context.Request.Data)
                context.AuthorizationService.CheckPermissions(context.User.Roles)
                context.DataService.LoadCustomerData(context.Request.CustomerId)
                context.BusinessRuleEngine.ApplyRules(context.Customer.Type)
                context.PaymentService.ProcessPayment(context.Order.Payment)
                context.NotificationService.SendConfirmation(context.Customer.Email)
                context.AuditService.LogActivity(context.User.Id, "Workflow completed")
                context.ReportingService.UpdateMetrics(context.Workflow.Type)
                
                Return New WorkflowResult()
            End Function
        End Class
        
        ' GOOD: Well-designed methods that primarily use their own class features
        
        Class GoodCustomerProcessor
            Private customerId As Integer
            Private processingRules As List(Of String)
            Private validationEngine As ValidationEngine
            Private logger As ILogger
            
            ' GOOD: Method primarily uses its own features and data
            Function GoodProcessCustomer(customerId As Integer) As Boolean
                Me.customerId = customerId
                
                If Not ValidateCustomerId() Then Return False
                If Not ApplyProcessingRules() Then Return False
                
                LogProcessingResult("Customer processed successfully")
                Return True
            End Function
            
            ' GOOD: Method delegates appropriately but maintains responsibility
            Function GoodValidateAndSave(customerData As CustomerData) As Boolean
                ' Validate using own validation logic
                If Not IsValidData(customerData) Then
                    LogError("Invalid customer data")
                    Return False
                End If
                
                ' Simple delegation without feature envy
                Dim saved As Boolean = customerData.Save()
                
                If saved Then
                    UpdateProcessingCount()
                    LogSuccess("Customer data saved")
                End If
                
                Return saved
            End Function
            
            ' GOOD: Method with clear single responsibility
            Sub GoodConfigureProcessor(config As ProcessorConfig)
                ' Configure own state based on external config
                Me.processingRules = ExtractRules(config.Rules)
                Me.validationEngine = CreateValidationEngine(config.ValidationSettings)
                Me.logger = CreateLogger(config.LoggingSettings)
                
                InitializeProcessor()
            End Sub
            
            ' GOOD: Method that coordinates but doesn't manipulate external objects extensively
            Function GoodProcessOrder(order As Order) As OrderResult
                Dim validationResult As ValidationResult = ValidateOrder(order)
                If Not validationResult.IsValid Then
                    Return CreateErrorResult(validationResult.Errors)
                End If
                
                Dim processingResult As ProcessingResult = ProcessInternal(order)
                Return CreateOrderResult(processingResult)
            End Function
            
            ' GOOD: Factory method pattern - creates and configures objects appropriately
            Function GoodCreateCustomerProcessor(customerId As Integer) As CustomerProcessor
                Dim processor As New CustomerProcessor()
                processor.Initialize(customerId, Me.processingRules, Me.logger)
                Return processor
            End Function
            
            ' Helper methods that demonstrate good encapsulation
            Private Function ValidateCustomerId() As Boolean
                Return customerId > 0 AndAlso ExistsInDatabase(customerId)
            End Function
            
            Private Function ApplyProcessingRules() As Boolean
                For Each rule In processingRules
                    If Not ApplyRule(rule) Then Return False
                Next
                Return True
            End Function
            
            Private Sub LogProcessingResult(message As String)
                logger.Log($"Customer {customerId}: {message}")
            End Sub
            
            Private Function IsValidData(data As CustomerData) As Boolean
                Return validationEngine.Validate(data)
            End Function
            
            Private Sub UpdateProcessingCount()
                ' Update internal processing metrics
            End Sub
            
            Private Sub LogSuccess(message As String)
                logger.LogSuccess(message)
            End Sub
            
            Private Sub LogError(message As String)
                logger.LogError(message)
            End Sub
            
            Private Function ExtractRules(rules As Object) As List(Of String)
                Return New List(Of String)()
            End Function
            
            Private Function CreateValidationEngine(settings As Object) As ValidationEngine
                Return New ValidationEngine()
            End Function
            
            Private Function CreateLogger(settings As Object) As ILogger
                Return New ConsoleLogger()
            End Function
            
            Private Sub InitializeProcessor()
                ' Initialize processor state
            End Sub
            
            Private Function ValidateOrder(order As Order) As ValidationResult
                Return validationEngine.ValidateOrder(order)
            End Function
            
            Private Function ProcessInternal(order As Order) As ProcessingResult
                ' Internal processing logic
                Return New ProcessingResult()
            End Function
            
            Private Function CreateErrorResult(errors As List(Of String)) As OrderResult
                Return New OrderResult() With {.IsSuccess = False, .Errors = errors}
            End Function
            
            Private Function CreateOrderResult(result As ProcessingResult) As OrderResult
                Return New OrderResult() With {.IsSuccess = result.Success}
            End Function
            
            Private Function ExistsInDatabase(id As Integer) As Boolean
                Return True ' Database check
            End Function
            
            Private Function ApplyRule(rule As String) As Boolean
                Return True ' Rule application
            End Function
        End Class
        
        ' Supporting classes and interfaces
        Class Customer
            Public Property FirstName As String
            Public Property LastName As String
            Public Property Email As String
            Public Property Phone As String
            Public Property Address As Address
            Public Property Profile As CustomerProfile
            Public Property Account As CustomerAccount
            
            Public Sub ValidateAddress()
            End Sub
            
            Public Sub CheckCreditLimit()
            End Sub
            
            Public Sub UpdateLastOrderDate()
            End Sub
            
            Public Sub SendNotification()
            End Sub
            
            Public Sub LogActivity(activity As String)
            End Sub
            
            Public Function GetFormattedName() As String
                Return FirstName
            End Function
            
            Public Function GetLastName() As String
                Return LastName
            End Function
            
            Public Function GetEmail() As String
                Return Email
            End Function
            
            Public Function FormatPhoneNumber() As String
                Return Phone
            End Function
        End Class
        
        Class Order
            Public Property Details As OrderDetails
            Public Property Status As OrderStatus
            Public Property Payment As Payment
            
            Public Sub CalculateTotal()
            End Sub
            
            Public Sub ApplyDiscounts()
            End Sub
            
            Public Sub ValidateItems()
            End Sub
            
            Public Sub UpdateInventory()
            End Sub
            
            Public Sub GenerateInvoice()
            End Sub
        End Class
        
        Class Address
            Public Property Street As String
            Public Property City As String
            Public Property State As String
            Public Property ZipCode As String
            
            Public Function GetFormattedStreet() As String
                Return Street
            End Function
            
            Public Function GetCity() As String
                Return City
            End Function
            
            Public Function GetState() As String
                Return State
            End Function
            
            Public Function GetZipCode() As String
                Return ZipCode
            End Function
            
            Public Function Validate() As Address
                Return Me
            End Function
            
            Public Function Format() As Address
                Return Me
            End Function
            
            Public Function Normalize() As Address
                Return Me
            End Function
            
            Public Sub Save()
            End Sub
        End Class
        
        ' Additional supporting classes for completeness
        Class Payment
            Public Property CreditCard As CreditCard
            Public Property BillingAddress As Address
            Public Property Customer As Customer
        End Class
        
        Class CreditCard
            Public Function Validate() As CreditCard
                Return Me
            End Function
            
            Public Function CheckExpiration() As CreditCard
                Return Me
            End Function
            
            Public Function VerifySecurityCode() As CreditCard
                Return Me
            End Function
            
            Public Function ProcessTransaction() As CreditCard
                Return Me
            End Function
        End Class
        
        Class CustomerProfile
            Public Property PersonalInfo As PersonalInfo
            Public Property ContactInfo As ContactInfo
        End Class
        
        Class PersonalInfo
            Public Property Name As FullName
        End Class
        
        Class FullName
            Public Property FullName As String
        End Class
        
        Class ContactInfo
            Public Property Email As EmailInfo
            Public Property Phone As PhoneInfo
        End Class
        
        Class EmailInfo
            Public Property Address As String
        End Class
        
        Class PhoneInfo
            Public Property Number As String
        End Class
        
        Class CustomerAccount
            Public Property Settings As AccountSettings
            Public Property Billing As BillingInfo
        End Class
        
        Class AccountSettings
            Public Property Preferences As UserPreferences
        End Class
        
        Class UserPreferences
            Public Property Theme As String
        End Class
        
        Class BillingInfo
            Public Property PaymentMethod As PaymentMethodInfo
        End Class
        
        Class PaymentMethodInfo
            Public Property Type As String
        End Class
        
        Class OrderDetails
            Public Property Items As ItemCollection
            Public Property Shipping As ShippingInfo
            Public Property Payment As PaymentInfo
        End Class
        
        Class ItemCollection
            Public Property Count As Integer
        End Class
        
        Class ShippingInfo
            Public Property Address As Address
        End Class
        
        Class PaymentInfo
            Public Property Method As PaymentMethodInfo
        End Class
        
        Class OrderStatus
            Public Property Current As StatusInfo
        End Class
        
        Class StatusInfo
            Public Property Description As String
        End Class
        
        Class User
            Public Property Preferences As UserPreferences
            Public Property Notifications As NotificationSettings
            Public Property Security As SecuritySettings
            Public Property Privacy As PrivacySettings
            Public Property Roles As List(Of String)
            Public Property Id As Integer
        End Class
        
        Class UserSettings
            Public Property Display As DisplaySettings
            Public Property Notifications As NotificationSettings
            Public Property Security As SecuritySettings
            Public Property Privacy As PrivacySettings
        End Class
        
        Class DisplaySettings
            Public Property Theme As String
            Public Property Language As String
            Public Property Timezone As String
        End Class
        
        Class NotificationSettings
            Public Property Email As Boolean
            Public Property SMS As Boolean
            Public Property Push As Boolean
        End Class
        
        Class SecuritySettings
            Public Property TwoFactor As Boolean
            Public Property PasswordPolicy As String
        End Class
        
        Class PrivacySettings
            Public Property DataSharing As Boolean
            Public Property Analytics As Boolean
        End Class
        
        Class BusinessContext
            Public Property ValidationService As IValidationService
            Public Property AuthorizationService As IAuthorizationService
            Public Property DataService As IDataService
            Public Property BusinessRuleEngine As IBusinessRuleEngine
            Public Property PaymentService As IPaymentService
            Public Property NotificationService As INotificationService
            Public Property AuditService As IAuditService
            Public Property ReportingService As IReportingService
            Public Property Request As BusinessRequest
            Public Property User As User
            Public Property Customer As Customer
            Public Property Order As Order
            Public Property Workflow As WorkflowInfo
        End Class
        
        Class BusinessRequest
            Public Property Data As Object
            Public Property CustomerId As Integer
        End Class
        
        Class WorkflowInfo
            Public Property Type As String
        End Class
        
        Class WorkflowResult
        End Class
        
        Class CustomerData
            Public Function Save() As Boolean
                Return True
            End Function
        End Class
        
        Class ProcessorConfig
            Public Property Rules As Object
            Public Property ValidationSettings As Object
            Public Property LoggingSettings As Object
        End Class
        
        Class ValidationEngine
            Public Function Validate(data As CustomerData) As Boolean
                Return True
            End Function
            
            Public Function ValidateOrder(order As Order) As ValidationResult
                Return New ValidationResult()
            End Function
        End Class
        
        Class ValidationResult
            Public Property IsValid As Boolean
            Public Property Errors As List(Of String)
        End Class
        
        Class ProcessingResult
            Public Property Success As Boolean
        End Class
        
        Class OrderResult
            Public Property IsSuccess As Boolean
            Public Property Errors As List(Of String)
        End Class
        
        Interface ILogger
            Sub Log(message As String)
            Sub LogSuccess(message As String)
            Sub LogError(message As String)
        End Interface
        
        Class ConsoleLogger
            Implements ILogger
            
            Public Sub Log(message As String) Implements ILogger.Log
            End Sub
            
            Public Sub LogSuccess(message As String) Implements ILogger.LogSuccess
            End Sub
            
            Public Sub LogError(message As String) Implements ILogger.LogError
            End Sub
        End Class
        
        ' Service interfaces
        Interface IValidationService
            Sub ValidateInput(data As Object)
        End Interface
        
        Interface IAuthorizationService
            Sub CheckPermissions(roles As List(Of String))
        End Interface
        
        Interface IDataService
            Sub LoadCustomerData(customerId As Integer)
        End Interface
        
        Interface IBusinessRuleEngine
            Sub ApplyRules(customerType As String)
        End Interface
        
        Interface IPaymentService
            Sub ProcessPayment(payment As Payment)
        End Interface
        
        Interface INotificationService
            Sub SendConfirmation(email As String)
        End Interface
        
        Interface IAuditService
            Sub LogActivity(userId As Integer, activity As String)
        End Interface
        
        Interface IReportingService
            Sub UpdateMetrics(workflowType As String)
        End Interface
    </script>
</body>
</html>
