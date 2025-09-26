<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Unit Tests Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing unit tests - classes or methods without corresponding unit tests
        
        ' BAD: Public methods that should have unit tests but don't
        Public Function BadCalculateTotal(items As List(Of Item)) As Decimal
            ' This calculation method needs unit tests
            Dim total As Decimal = 0
            For Each item In items
                total += item.Price * item.Quantity
            Next
            Return total
        End Function
        
        Public Function BadProcessPayment(amount As Decimal, cardNumber As String) As Boolean
            ' Payment processing should definitely have unit tests
            If amount <= 0 Then Return False
            If String.IsNullOrEmpty(cardNumber) Then Return False
            If cardNumber.Length < 16 Then Return False
            
            ' Process payment logic
            Return True
        End Function
        
        Public Function BadValidateEmail(email As String) As Boolean
            ' Validation logic needs thorough testing
            If String.IsNullOrEmpty(email) Then Return False
            If Not email.Contains("@") Then Return False
            If Not email.Contains(".") Then Return False
            
            Dim parts() As String = email.Split("@"c)
            If parts.Length <> 2 Then Return False
            If parts(0).Length = 0 Or parts(1).Length = 0 Then Return False
            
            Return True
        End Function
        
        Public Function BadConvertTemperature(celsius As Double) As Double
            ' Conversion logic should be unit tested
            Return (celsius * 9.0 / 5.0) + 32.0
        End Function
        
        Public Function BadParseDate(dateString As String) As DateTime?
            ' Date parsing is error-prone and needs tests
            Try
                Return DateTime.Parse(dateString)
            Catch
                Return Nothing
            End Try
        End Function
        
        ' BAD: Service classes without unit tests
        Public Class BadCalculatorService
            Public Function Add(a As Integer, b As Integer) As Integer
                Return a + b
            End Function
            
            Public Function Subtract(a As Integer, b As Integer) As Integer
                Return a - b
            End Function
            
            Public Function Multiply(a As Integer, b As Integer) As Integer
                Return a * b
            End Function
            
            Public Function Divide(a As Integer, b As Integer) As Integer
                If b = 0 Then Throw New DivideByZeroException()
                Return a \ b
            End Function
        End Class
        
        Public Class BadUserManager
            Public Function CreateUser(username As String, email As String) As User
                If String.IsNullOrEmpty(username) Then
                    Throw New ArgumentException("Username required")
                End If
                If String.IsNullOrEmpty(email) Then
                    Throw New ArgumentException("Email required")
                End If
                
                Return New User() With {.Username = username, .Email = email}
            End Function
            
            Public Function ValidateUser(user As User) As Boolean
                Return Not String.IsNullOrEmpty(user.Username) AndAlso 
                       Not String.IsNullOrEmpty(user.Email)
            End Function
        End Class
        
        Public Class BadOrderProcessor
            Public Function ProcessOrder(order As Order) As OrderResult
                If order Is Nothing Then
                    Return New OrderResult() With {.Success = False, .Message = "Order is null"}
                End If
                
                If order.Items Is Nothing OrElse order.Items.Count = 0 Then
                    Return New OrderResult() With {.Success = False, .Message = "No items"}
                End If
                
                Dim total As Decimal = CalculateOrderTotal(order)
                If total <= 0 Then
                    Return New OrderResult() With {.Success = False, .Message = "Invalid total"}
                End If
                
                Return New OrderResult() With {.Success = True, .Total = total}
            End Function
            
            Private Function CalculateOrderTotal(order As Order) As Decimal
                Dim total As Decimal = 0
                For Each item In order.Items
                    total += item.Price * item.Quantity
                Next
                Return total
            End Function
        End Class
        
        Public Class BadDataValidator
            Public Function ValidateRequired(value As String, fieldName As String) As ValidationResult
                If String.IsNullOrEmpty(value) Then
                    Return New ValidationResult() With {
                        .IsValid = False,
                        .ErrorMessage = $"{fieldName} is required"
                    }
                End If
                Return New ValidationResult() With {.IsValid = True}
            End Function
            
            Public Function ValidateLength(value As String, minLength As Integer, maxLength As Integer) As ValidationResult
                If String.IsNullOrEmpty(value) Then
                    Return New ValidationResult() With {
                        .IsValid = False,
                        .ErrorMessage = "Value cannot be empty"
                    }
                End If
                
                If value.Length < minLength Then
                    Return New ValidationResult() With {
                        .IsValid = False,
                        .ErrorMessage = $"Value must be at least {minLength} characters"
                    }
                End If
                
                If value.Length > maxLength Then
                    Return New ValidationResult() With {
                        .IsValid = False,
                        .ErrorMessage = $"Value cannot exceed {maxLength} characters"
                    }
                End If
                
                Return New ValidationResult() With {.IsValid = True}
            End Function
        End Class
        
        ' BAD: Complex business logic without tests
        Protected Function BadCalculateDiscount(orderTotal As Decimal, customerType As String, isFirstOrder As Boolean) As Decimal
            Dim discount As Decimal = 0
            
            Select Case customerType.ToUpper()
                Case "PREMIUM"
                    discount = orderTotal * 0.15D
                Case "GOLD"
                    discount = orderTotal * 0.1D
                Case "SILVER"
                    discount = orderTotal * 0.05D
                Case Else
                    discount = 0
            End Select
            
            If isFirstOrder Then
                discount += orderTotal * 0.1D ' Additional 10% for first order
            End If
            
            ' Cap discount at 50% of order total
            If discount > orderTotal * 0.5D Then
                discount = orderTotal * 0.5D
            End If
            
            Return discount
        End Function
        
        ' GOOD: Methods and classes with proper unit test coverage (indicated by comments)
        
        ' GOOD: Well-tested calculation method
        Public Function GoodCalculateTotal(items As List(Of Item)) As Decimal
            ' Unit tests: CalculateTotalTests.vb
            ' - TestCalculateTotal_EmptyList_ReturnsZero
            ' - TestCalculateTotal_SingleItem_ReturnsCorrectTotal
            ' - TestCalculateTotal_MultipleItems_ReturnsSum
            ' - TestCalculateTotal_NullList_ThrowsException
            
            If items Is Nothing Then
                Throw New ArgumentNullException(NameOf(items))
            End If
            
            Dim total As Decimal = 0
            For Each item In items
                total += item.Price * item.Quantity
            Next
            Return total
        End Function
        
        ' GOOD: Well-tested service class
        Public Class GoodCalculatorService
            ' Unit tests: CalculatorServiceTests.vb
            ' Comprehensive test coverage for all methods
            
            Public Function Add(a As Integer, b As Integer) As Integer
                ' Tested: positive numbers, negative numbers, zero, overflow
                Return a + b
            End Function
            
            Public Function Divide(a As Integer, b As Integer) As Integer
                ' Tested: normal division, division by zero, negative numbers
                If b = 0 Then Throw New DivideByZeroException()
                Return a \ b
            End Function
        End Class
        
        ' GOOD: Testable design with dependency injection
        Public Class GoodUserService
            ' Unit tests: UserServiceTests.vb
            ' Uses mock dependencies for isolated testing
            
            Private userRepository As IUserRepository
            Private emailService As IEmailService
            
            Public Sub New(repository As IUserRepository, emailSvc As IEmailService)
                Me.userRepository = repository
                Me.emailService = emailSvc
            End Sub
            
            Public Function CreateUser(userData As UserData) As User
                ' Well-tested with mocked dependencies
                ValidateUserData(userData)
                
                Dim user As User = New User() With {
                    .Username = userData.Username,
                    .Email = userData.Email
                }
                
                userRepository.Save(user)
                emailService.SendWelcomeEmail(user.Email)
                
                Return user
            End Function
            
            Private Sub ValidateUserData(userData As UserData)
                If userData Is Nothing Then
                    Throw New ArgumentNullException(NameOf(userData))
                End If
                If String.IsNullOrEmpty(userData.Username) Then
                    Throw New ArgumentException("Username required")
                End If
                If String.IsNullOrEmpty(userData.Email) Then
                    Throw New ArgumentException("Email required")
                End If
            End Sub
        End Class
        
        ' GOOD: Test-driven development approach
        Public Class GoodOrderValidator
            ' Unit tests: OrderValidatorTests.vb
            ' Test cases written before implementation (TDD)
            
            Public Function ValidateOrder(order As Order) As ValidationResult
                ' Comprehensive test coverage:
                ' - Null order validation
                ' - Empty items validation  
                ' - Invalid quantities validation
                ' - Price validation
                ' - Customer validation
                
                If order Is Nothing Then
                    Return CreateValidationError("Order cannot be null")
                End If
                
                If order.Items Is Nothing OrElse order.Items.Count = 0 Then
                    Return CreateValidationError("Order must contain at least one item")
                End If
                
                For Each item In order.Items
                    If item.Quantity <= 0 Then
                        Return CreateValidationError("Item quantity must be positive")
                    End If
                    If item.Price < 0 Then
                        Return CreateValidationError("Item price cannot be negative")
                    End If
                Next
                
                Return New ValidationResult() With {.IsValid = True}
            End Function
            
            Private Function CreateValidationError(message As String) As ValidationResult
                Return New ValidationResult() With {
                    .IsValid = False,
                    .ErrorMessage = message
                }
            End Function
        End Class
        
        ' GOOD: Unit testable utility functions
        Public Module GoodMathUtilities
            ' Unit tests: MathUtilitiesTests.vb
            ' Pure functions that are easy to test
            
            Public Function CalculatePercentage(value As Decimal, percentage As Decimal) As Decimal
                ' Tests cover: normal cases, zero values, negative values, edge cases
                If percentage < 0 OrElse percentage > 100 Then
                    Throw New ArgumentOutOfRangeException(NameOf(percentage))
                End If
                Return value * (percentage / 100D)
            End Function
            
            Public Function RoundToNearestCent(amount As Decimal) As Decimal
                ' Tests cover: various decimal places, rounding rules
                Return Math.Round(amount, 2, MidpointRounding.AwayFromZero)
            End Function
        End Module
        
        ' Supporting classes and interfaces
        Class Item
            Public Property Price As Decimal
            Public Property Quantity As Integer
        End Class
        
        Class User
            Public Property Username As String
            Public Property Email As String
        End Class
        
        Class UserData
            Public Property Username As String
            Public Property Email As String
        End Class
        
        Class Order
            Public Property Items As List(Of Item)
            Public Property CustomerId As Integer
        End Class
        
        Class OrderResult
            Public Property Success As Boolean
            Public Property Message As String
            Public Property Total As Decimal
        End Class
        
        Class ValidationResult
            Public Property IsValid As Boolean
            Public Property ErrorMessage As String
        End Class
        
        Interface IUserRepository
            Sub Save(user As User)
            Function GetById(id As Integer) As User
        End Interface
        
        Interface IEmailService
            Sub SendWelcomeEmail(email As String)
        End Interface
    </script>
</body>
</html>
