<%@ Page Language="VB" %>
<html>
<head>
    <title>Open-Closed Principle Violations Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Open-Closed Principle violations - classes that need modification rather than extension for new features
        
        ' BAD: Type checking with multiple if statements
        Class BadPaymentProcessor
            Public Sub ProcessPayment(payment As Object)
                ' BAD: Adding new payment types requires modifying this method
                If TypeOf payment Is CreditCardPayment Then
                    ProcessCreditCard(CType(payment, CreditCardPayment))
                ElseIf TypeOf payment Is PayPalPayment Then
                    ProcessPayPal(CType(payment, PayPalPayment))
                ElseIf TypeOf payment Is BankTransferPayment Then
                    ProcessBankTransfer(CType(payment, BankTransferPayment))
                ElseIf TypeOf payment Is BitcoinPayment Then
                    ProcessBitcoin(CType(payment, BitcoinPayment))
                End If
            End Sub
            
            Private Sub ProcessCreditCard(payment As CreditCardPayment)
            End Sub
            
            Private Sub ProcessPayPal(payment As PayPalPayment)
            End Sub
            
            Private Sub ProcessBankTransfer(payment As BankTransferPayment)
            End Sub
            
            Private Sub ProcessBitcoin(payment As BitcoinPayment)
            End Sub
        End Class
        
        ' BAD: String-based type checking
        Class BadReportGenerator
            Public Function GenerateReport(reportType As String) As String
                ' BAD: Adding new report types requires modifying this method
                If String.Equals(reportType, "Sales", StringComparison.OrdinalIgnoreCase) Then
                    Return GenerateSalesReport()
                ElseIf String.Equals(reportType, "Inventory", StringComparison.OrdinalIgnoreCase) Then
                    Return GenerateInventoryReport()
                ElseIf String.Equals(reportType, "Customer", StringComparison.OrdinalIgnoreCase) Then
                    Return GenerateCustomerReport()
                ElseIf String.Equals(reportType, "Financial", StringComparison.OrdinalIgnoreCase) Then
                    Return GenerateFinancialReport()
                Else
                    Return "Unknown report type"
                End If
            End Function
            
            Private Function GenerateSalesReport() As String
                Return "Sales Report"
            End Function
            
            Private Function GenerateInventoryReport() As String
                Return "Inventory Report"
            End Function
            
            Private Function GenerateCustomerReport() As String
                Return "Customer Report"
            End Function
            
            Private Function GenerateFinancialReport() As String
                Return "Financial Report"
            End Function
        End Class
        
        ' BAD: Switch/Case with type names
        Class BadNotificationService
            Public Sub SendNotification(notificationType As String, message As String)
                ' BAD: Adding new notification types requires modifying this method
                Select Case notificationType.ToLower()
                    Case "email"
                        SendEmailNotification(message)
                    Case "sms"
                        SendSmsNotification(message)
                    Case "push"
                        SendPushNotification(message)
                    Case "slack"
                        SendSlackNotification(message)
                    Case "teams"
                        SendTeamsNotification(message)
                End Select
            End Sub
            
            Private Sub SendEmailNotification(message As String)
            End Sub
            
            Private Sub SendSmsNotification(message As String)
            End Sub
            
            Private Sub SendPushNotification(message As String)
            End Sub
            
            Private Sub SendSlackNotification(message As String)
            End Sub
            
            Private Sub SendTeamsNotification(message As String)
            End Sub
        End Class
        
        ' BAD: GetType() comparisons
        Class BadShapeCalculator
            Public Function CalculateArea(shape As Object) As Double
                ' BAD: Adding new shapes requires modifying this method
                If shape.GetType() = GetType(Circle) Then
                    Dim circle = CType(shape, Circle)
                    Return Math.PI * circle.Radius * circle.Radius
                ElseIf shape.GetType() = GetType(Rectangle) Then
                    Dim rectangle = CType(shape, Rectangle)
                    Return rectangle.Width * rectangle.Height
                ElseIf shape.GetType() = GetType(Triangle) Then
                    Dim triangle = CType(shape, Triangle)
                    Return 0.5 * triangle.Base * triangle.Height
                ElseIf shape.GetType() = GetType(Square) Then
                    Dim square = CType(shape, Square)
                    Return square.Side * square.Side
                End If
                Return 0
            End Function
        End Class
        
        ' BAD: Multiple type checks in business logic
        Class BadDiscountCalculator
            Public Function CalculateDiscount(customer As Object, orderAmount As Decimal) As Decimal
                ' BAD: Adding new customer types requires modifying this method
                If customer.GetType().Name = "RegularCustomer" Then
                    Return orderAmount * 0.05D
                ElseIf customer.GetType().Name = "PremiumCustomer" Then
                    Return orderAmount * 0.1D
                ElseIf customer.GetType().Name = "VipCustomer" Then
                    Return orderAmount * 0.15D
                ElseIf customer.GetType().Name = "EmployeeCustomer" Then
                    Return orderAmount * 0.2D
                End If
                Return 0
            End Function
        End Class
        
        ' BAD: Hardcoded type strings in conditions
        Class BadUserPermissionChecker
            Public Function HasPermission(user As Object, action As String) As Boolean
                ' BAD: Adding new user types requires modifying this method
                Dim userType = user.GetType().Name
                
                If String.Compare(userType, "AdminUser", True) = 0 Then
                    Return True ' Admin can do everything
                ElseIf String.Compare(userType, "ManagerUser", True) = 0 Then
                    Return action <> "DeleteSystem"
                ElseIf String.Compare(userType, "RegularUser", True) = 0 Then
                    Return action = "Read" OrElse action = "Update"
                ElseIf String.Compare(userType, "GuestUser", True) = 0 Then
                    Return action = "Read"
                End If
                
                Return False
            End Function
        End Sub
        
        ' GOOD: Open-Closed Principle compliant implementations
        
        ' GOOD: Strategy pattern for payment processing
        Interface IGoodPaymentProcessor
            Sub ProcessPayment()
        End Interface
        
        Class GoodCreditCardProcessor
            Implements IGoodPaymentProcessor
            
            Public Sub ProcessPayment() Implements IGoodPaymentProcessor.ProcessPayment
                ' Credit card specific processing
            End Sub
        End Class
        
        Class GoodPayPalProcessor
            Implements IGoodPaymentProcessor
            
            Public Sub ProcessPayment() Implements IGoodPaymentProcessor.ProcessPayment
                ' PayPal specific processing
            End Sub
        End Class
        
        Class GoodBankTransferProcessor
            Implements IGoodPaymentProcessor
            
            Public Sub ProcessPayment() Implements IGoodPaymentProcessor.ProcessPayment
                ' Bank transfer specific processing
            End Sub
        End Class
        
        ' GOOD: Context class that uses strategy
        Class GoodPaymentContext
            Private processor As IGoodPaymentProcessor
            
            Public Sub New(processor As IGoodPaymentProcessor)
                Me.processor = processor
            End Sub
            
            Public Sub ProcessPayment()
                processor.ProcessPayment()
            End Sub
        End Class
        
        ' GOOD: Factory pattern for creating processors
        Class GoodPaymentProcessorFactory
            Public Shared Function CreateProcessor(paymentType As String) As IGoodPaymentProcessor
                Select Case paymentType.ToLower()
                    Case "creditcard"
                        Return New GoodCreditCardProcessor()
                    Case "paypal"
                        Return New GoodPayPalProcessor()
                    Case "banktransfer"
                        Return New GoodBankTransferProcessor()
                    Case Else
                        Throw New ArgumentException("Unknown payment type")
                End Select
            End Function
        End Class
        
        ' GOOD: Abstract base class for reports
        MustInherit Class GoodReportBase
            Public MustOverride Function GenerateReport() As String
            
            Protected Function GetCommonHeader() As String
                Return "Generated on: " & DateTime.Now.ToString()
            End Function
            
            Protected Function GetCommonFooter() As String
                Return "End of Report"
            End Function
        End Class
        
        Class GoodSalesReport
            Inherits GoodReportBase
            
            Public Overrides Function GenerateReport() As String
                Return GetCommonHeader() & vbCrLf & "Sales Report Content" & vbCrLf & GetCommonFooter()
            End Function
        End Class
        
        Class GoodInventoryReport
            Inherits GoodReportBase
            
            Public Overrides Function GenerateReport() As String
                Return GetCommonHeader() & vbCrLf & "Inventory Report Content" & vbCrLf & GetCommonFooter()
            End Function
        End Class
        
        Class GoodCustomerReport
            Inherits GoodReportBase
            
            Public Overrides Function GenerateReport() As String
                Return GetCommonHeader() & vbCrLf & "Customer Report Content" & vbCrLf & GetCommonFooter()
            End Function
        End Class
        
        ' GOOD: Report generator using polymorphism
        Class GoodReportGenerator
            Public Function GenerateReport(report As GoodReportBase) As String
                ' GOOD: No modification needed for new report types
                Return report.GenerateReport()
            End Function
        End Class
        
        ' GOOD: Interface for notifications
        Interface IGoodNotificationSender
            Sub SendNotification(message As String)
        End Interface
        
        Class GoodEmailNotificationSender
            Implements IGoodNotificationSender
            
            Public Sub SendNotification(message As String) Implements IGoodNotificationSender.SendNotification
                ' Email sending logic
            End Sub
        End Class
        
        Class GoodSmsNotificationSender
            Implements IGoodNotificationSender
            
            Public Sub SendNotification(message As String) Implements IGoodNotificationSender.SendNotification
                ' SMS sending logic
            End Sub
        End Class
        
        Class GoodPushNotificationSender
            Implements IGoodNotificationSender
            
            Public Sub SendNotification(message As String) Implements IGoodNotificationSender.SendNotification
                ' Push notification logic
            End Sub
        End Class
        
        ' GOOD: Notification service using composition
        Class GoodNotificationService
            Private senders As List(Of IGoodNotificationSender)
            
            Public Sub New()
                senders = New List(Of IGoodNotificationSender)()
            End Sub
            
            Public Sub AddSender(sender As IGoodNotificationSender)
                senders.Add(sender)
            End Sub
            
            Public Sub SendNotification(message As String)
                For Each sender In senders
                    sender.SendNotification(message)
                Next
            End Sub
        End Class
        
        ' GOOD: Abstract shape class
        MustInherit Class GoodShape
            Public MustOverride Function CalculateArea() As Double
        End Class
        
        Class GoodCircle
            Inherits GoodShape
            
            Public Property Radius As Double
            
            Public Overrides Function CalculateArea() As Double
                Return Math.PI * Radius * Radius
            End Function
        End Class
        
        Class GoodRectangle
            Inherits GoodShape
            
            Public Property Width As Double
            Public Property Height As Double
            
            Public Overrides Function CalculateArea() As Double
                Return Width * Height
            End Function
        End Class
        
        Class GoodTriangle
            Inherits GoodShape
            
            Public Property Base As Double
            Public Property Height As Double
            
            Public Overrides Function CalculateArea() As Double
                Return 0.5 * Base * Height
            End Function
        End Class
        
        ' GOOD: Shape calculator using polymorphism
        Class GoodShapeCalculator
            Public Function CalculateArea(shape As GoodShape) As Double
                ' GOOD: No modification needed for new shapes
                Return shape.CalculateArea()
            End Function
            
            Public Function CalculateTotalArea(shapes As List(Of GoodShape)) As Double
                Dim totalArea As Double = 0
                For Each shape In shapes
                    totalArea += shape.CalculateArea()
                Next
                Return totalArea
            End Function
        End Class
        
        ' GOOD: Interface for discount calculation
        Interface IGoodDiscountCalculator
            Function CalculateDiscount(orderAmount As Decimal) As Decimal
        End Interface
        
        Class GoodRegularCustomerDiscount
            Implements IGoodDiscountCalculator
            
            Public Function CalculateDiscount(orderAmount As Decimal) As Decimal Implements IGoodDiscountCalculator.CalculateDiscount
                Return orderAmount * 0.05D
            End Function
        End Class
        
        Class GoodPremiumCustomerDiscount
            Implements IGoodDiscountCalculator
            
            Public Function CalculateDiscount(orderAmount As Decimal) As Decimal Implements IGoodDiscountCalculator.CalculateDiscount
                Return orderAmount * 0.1D
            End Function
        End Class
        
        Class GoodVipCustomerDiscount
            Implements IGoodDiscountCalculator
            
            Public Function CalculateDiscount(orderAmount As Decimal) As Decimal Implements IGoodDiscountCalculator.CalculateDiscount
                Return orderAmount * 0.15D
            End Function
        End Class
        
        ' GOOD: Customer with discount strategy
        Class GoodCustomer
            Private discountCalculator As IGoodDiscountCalculator
            
            Public Sub New(discountCalculator As IGoodDiscountCalculator)
                Me.discountCalculator = discountCalculator
            End Sub
            
            Public Function CalculateDiscount(orderAmount As Decimal) As Decimal
                Return discountCalculator.CalculateDiscount(orderAmount)
            End Function
        End Class
        
        ' GOOD: Permission interface
        Interface IGoodPermissionChecker
            Function HasPermission(action As String) As Boolean
        End Interface
        
        Class GoodAdminPermissions
            Implements IGoodPermissionChecker
            
            Public Function HasPermission(action As String) As Boolean Implements IGoodPermissionChecker.HasPermission
                Return True ' Admin can do everything
            End Function
        End Class
        
        Class GoodManagerPermissions
            Implements IGoodPermissionChecker
            
            Public Function HasPermission(action As String) As Boolean Implements IGoodPermissionChecker.HasPermission
                Return action <> "DeleteSystem"
            End Function
        End Class
        
        Class GoodRegularUserPermissions
            Implements IGoodPermissionChecker
            
            Public Function HasPermission(action As String) As Boolean Implements IGoodPermissionChecker.HasPermission
                Return action = "Read" OrElse action = "Update"
            End Function
        End Class
        
        Class GoodGuestPermissions
            Implements IGoodPermissionChecker
            
            Public Function HasPermission(action As String) As Boolean Implements IGoodPermissionChecker.HasPermission
                Return action = "Read"
            End Function
        End Class
        
        ' GOOD: User with permission strategy
        Class GoodUser
            Private permissionChecker As IGoodPermissionChecker
            
            Public Sub New(permissionChecker As IGoodPermissionChecker)
                Me.permissionChecker = permissionChecker
            End Sub
            
            Public Function HasPermission(action As String) As Boolean
                Return permissionChecker.HasPermission(action)
            End Function
        End Class
        
        ' GOOD: Command pattern for extensible operations
        Interface IGoodCommand
            Sub Execute()
        End Interface
        
        Class GoodEmailCommand
            Implements IGoodCommand
            
            Private message As String
            
            Public Sub New(message As String)
                Me.message = message
            End Sub
            
            Public Sub Execute() Implements IGoodCommand.Execute
                ' Send email
            End Sub
        End Class
        
        Class GoodLogCommand
            Implements IGoodCommand
            
            Private logMessage As String
            
            Public Sub New(logMessage As String)
                Me.logMessage = logMessage
            End Sub
            
            Public Sub Execute() Implements IGoodCommand.Execute
                ' Log message
            End Sub
        End Class
        
        ' GOOD: Command invoker
        Class GoodCommandInvoker
            Private commands As List(Of IGoodCommand)
            
            Public Sub New()
                commands = New List(Of IGoodCommand)()
            End Sub
            
            Public Sub AddCommand(command As IGoodCommand)
                commands.Add(command)
            End Sub
            
            Public Sub ExecuteCommands()
                For Each command In commands
                    command.Execute()
                Next
            End Sub
        End Class
        
        ' Supporting classes for bad examples
        Class CreditCardPayment
        End Class
        
        Class PayPalPayment
        End Class
        
        Class BankTransferPayment
        End Class
        
        Class BitcoinPayment
        End Class
        
        Class Circle
            Public Property Radius As Double
        End Class
        
        Class Rectangle
            Public Property Width As Double
            Public Property Height As Double
        End Class
        
        Class Triangle
            Public Property Base As Double
            Public Property Height As Double
        End Class
        
        Class Square
            Public Property Side As Double
        End Class
        
        Class RegularCustomer
        End Class
        
        Class PremiumCustomer
        End Class
        
        Class VipCustomer
        End Class
        
        Class EmployeeCustomer
        End Class
        
        Class AdminUser
        End Class
        
        Class ManagerUser
        End Class
        
        Class RegularUser
        End Class
        
        Class GuestUser
        End Class
    </script>
</body>
</html>
