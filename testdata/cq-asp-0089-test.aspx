<%@ Page Language="VB" %>
<html>
<head>
    <title>Inconsistent Exception Messages Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inconsistent exception messages - exception messages with inconsistent format or information
        
        Sub BadInconsistentExceptionFormats()
            ' BAD: Mixed capitalization and punctuation
            If userId <= 0 Then
                Throw New ArgumentException("invalid user id")
            End If
            
            If String.IsNullOrEmpty(userName) Then
                Throw New ArgumentException("User name cannot be empty.")
            End If
            
            If email.Length < 5 Then
                Throw New ArgumentException("EMAIL TOO SHORT!")
            End If
            
            If password Is Nothing Then
                Throw New ArgumentException("Password is required")
            End If
        End Sub
        
        Sub BadMixedMessageStyles()
            ' BAD: Different message styles and formats
            Try
                ProcessData()
            Catch ex As FileNotFoundException
                Throw New InvalidOperationException("file not found")
            Catch ex As UnauthorizedAccessException
                Throw New InvalidOperationException("Access denied: Insufficient permissions.")
            Catch ex As IOException
                Throw New InvalidOperationException("IO ERROR OCCURRED!!!")
            End Try
        End Sub
        
        Function BadInconsistentValidationMessages(input As String) As Boolean
            ' BAD: Inconsistent validation error messages
            If String.IsNullOrEmpty(input) Then
                Throw New ArgumentException("input cannot be null or empty")
            End If
            
            If input.Length < 3 Then
                Throw New ArgumentException("Input must be at least 3 characters long.")
            End If
            
            If input.Contains(" ") Then
                Throw New ArgumentException("NO SPACES ALLOWED IN INPUT!")
            End If
            
            If Not IsValidFormat(input) Then
                Throw New ArgumentException("Invalid format detected")
            End If
            
            Return True
        End Function
        
        Sub BadMixedExceptionDetails()
            ' BAD: Some messages have details, others don't
            If connectionString Is Nothing Then
                Throw New InvalidOperationException("connection string is null")
            End If
            
            If timeout <= 0 Then
                Throw New InvalidOperationException("Timeout value must be greater than zero. Current value: " & timeout.ToString())
            End If
            
            If retryCount > 10 Then
                Throw New InvalidOperationException("TOO MANY RETRIES")
            End If
        End Sub
        
        Sub BadInconsistentParameterMessages()
            ' BAD: Inconsistent parameter name formatting
            If customerId <= 0 Then
                Throw New ArgumentOutOfRangeException("customerId", "Customer ID must be positive")
            End If
            
            If String.IsNullOrEmpty(customerName) Then
                Throw New ArgumentException("customer name cannot be empty")
            End If
            
            If customerAge < 0 Then
                Throw New ArgumentOutOfRangeException("CUSTOMER_AGE", "Age cannot be negative!")
            End If
        End Sub
        
        Function BadMixedBusinessRuleMessages(order As Order) As Boolean
            ' BAD: Inconsistent business rule error messages
            If order.Items.Count = 0 Then
                Throw New InvalidOperationException("order has no items")
            End If
            
            If order.Total <= 0 Then
                Throw New InvalidOperationException("Order total must be greater than zero.")
            End If
            
            If order.CustomerId <= 0 Then
                Throw New InvalidOperationException("INVALID CUSTOMER ID IN ORDER!")
            End If
            
            If Not order.IsValid Then
                Throw New InvalidOperationException("Order validation failed: Missing required fields")
            End If
            
            Return True
        End Function
        
        Sub BadMixedSecurityMessages()
            ' BAD: Security exception messages with different formats
            If Not IsAuthenticated() Then
                Throw New UnauthorizedAccessException("user not authenticated")
            End If
            
            If Not HasPermission("READ") Then
                Throw New UnauthorizedAccessException("Access denied: User does not have READ permission.")
            End If
            
            If IsTokenExpired() Then
                Throw New UnauthorizedAccessException("TOKEN HAS EXPIRED!")
            End If
        End Sub
        
        ' GOOD: Consistent exception messages with standardized format
        
        Sub GoodConsistentExceptionFormats()
            ' GOOD: Consistent capitalization, punctuation, and format
            If userId <= 0 Then
                Throw New ArgumentException("User ID must be greater than zero.")
            End If
            
            If String.IsNullOrEmpty(userName) Then
                Throw New ArgumentException("User name cannot be null or empty.")
            End If
            
            If email.Length < 5 Then
                Throw New ArgumentException("Email address must be at least 5 characters long.")
            End If
            
            If password Is Nothing Then
                Throw New ArgumentException("Password cannot be null.")
            End If
        End Sub
        
        Sub GoodConsistentErrorHandling()
            ' GOOD: Consistent error message format in exception handling
            Try
                ProcessData()
            Catch ex As FileNotFoundException
                Throw New InvalidOperationException("Required file was not found.", ex)
            Catch ex As UnauthorizedAccessException
                Throw New InvalidOperationException("Access denied due to insufficient permissions.", ex)
            Catch ex As IOException
                Throw New InvalidOperationException("An I/O error occurred during processing.", ex)
            End Try
        End Sub
        
        Function GoodConsistentValidationMessages(input As String) As Boolean
            ' GOOD: Consistent validation error message format
            If String.IsNullOrEmpty(input) Then
                Throw New ArgumentException("Input cannot be null or empty.")
            End If
            
            If input.Length < 3 Then
                Throw New ArgumentException("Input must be at least 3 characters long.")
            End If
            
            If input.Contains(" ") Then
                Throw New ArgumentException("Input cannot contain spaces.")
            End If
            
            If Not IsValidFormat(input) Then
                Throw New ArgumentException("Input format is invalid.")
            End If
            
            Return True
        End Function
        
        Sub GoodConsistentDetailsInMessages()
            ' GOOD: Consistent level of detail in exception messages
            If connectionString Is Nothing Then
                Throw New InvalidOperationException("Connection string cannot be null.")
            End If
            
            If timeout <= 0 Then
                Throw New InvalidOperationException($"Timeout value must be greater than zero. Current value: {timeout}")
            End If
            
            If retryCount > 10 Then
                Throw New InvalidOperationException($"Retry count cannot exceed 10. Current value: {retryCount}")
            End If
        End Sub
        
        Sub GoodConsistentParameterMessages()
            ' GOOD: Consistent parameter name formatting and message structure
            If customerId <= 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(customerId), "Customer ID must be greater than zero.")
            End If
            
            If String.IsNullOrEmpty(customerName) Then
                Throw New ArgumentException("Customer name cannot be null or empty.", NameOf(customerName))
            End If
            
            If customerAge < 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(customerAge), "Customer age cannot be negative.")
            End If
        End Sub
        
        Function GoodConsistentBusinessRuleMessages(order As Order) As Boolean
            ' GOOD: Consistent business rule error message format
            If order.Items.Count = 0 Then
                Throw New InvalidOperationException("Order must contain at least one item.")
            End If
            
            If order.Total <= 0 Then
                Throw New InvalidOperationException("Order total must be greater than zero.")
            End If
            
            If order.CustomerId <= 0 Then
                Throw New InvalidOperationException("Order must have a valid customer ID.")
            End If
            
            If Not order.IsValid Then
                Throw New InvalidOperationException("Order validation failed due to missing required fields.")
            End If
            
            Return True
        End Function
        
        Sub GoodConsistentSecurityMessages()
            ' GOOD: Consistent security exception message format
            If Not IsAuthenticated() Then
                Throw New UnauthorizedAccessException("User authentication is required.")
            End If
            
            If Not HasPermission("READ") Then
                Throw New UnauthorizedAccessException("User does not have required READ permission.")
            End If
            
            If IsTokenExpired() Then
                Throw New UnauthorizedAccessException("Authentication token has expired.")
            End If
        End Sub
        
        ' GOOD: Using centralized message formatting
        Public Class GoodExceptionMessageFormatter
            Public Shared Function FormatArgumentError(paramName As String, requirement As String) As String
                Return $"{paramName} {requirement}."
            End Function
            
            Public Shared Function FormatValidationError(field As String, rule As String) As String
                Return $"{field} validation failed: {rule}."
            End Function
            
            Public Shared Function FormatBusinessRuleError(rule As String) As String
                Return $"Business rule violation: {rule}."
            End Function
            
            Public Shared Function FormatSecurityError(action As String, reason As String) As String
                Return $"Access denied for {action}: {reason}."
            End Function
        End Class
        
        Sub GoodUsingMessageFormatter()
            ' GOOD: Using centralized message formatting for consistency
            If userId <= 0 Then
                Dim message As String = GoodExceptionMessageFormatter.FormatArgumentError("User ID", "must be greater than zero")
                Throw New ArgumentException(message)
            End If
            
            If String.IsNullOrEmpty(email) Then
                Dim message As String = GoodExceptionMessageFormatter.FormatValidationError("Email", "cannot be null or empty")
                Throw New ArgumentException(message)
            End If
            
            If Not HasValidSubscription() Then
                Dim message As String = GoodExceptionMessageFormatter.FormatBusinessRuleError("valid subscription required for this operation")
                Throw New InvalidOperationException(message)
            End If
        End Sub
        
        ' GOOD: Exception message constants for consistency
        Public Class GoodExceptionMessages
            Public Const ARGUMENT_NULL = "Argument cannot be null."
            Public Const ARGUMENT_EMPTY = "Argument cannot be empty."
            Public Const ARGUMENT_NEGATIVE = "Argument cannot be negative."
            Public Const INVALID_FORMAT = "Argument format is invalid."
            Public Const ACCESS_DENIED = "Access denied due to insufficient permissions."
            Public Const AUTHENTICATION_REQUIRED = "User authentication is required."
            Public Const RESOURCE_NOT_FOUND = "Requested resource was not found."
            Public Const OPERATION_FAILED = "Operation could not be completed."
        End Class
        
        Sub GoodUsingMessageConstants()
            ' GOOD: Using predefined message constants
            If input Is Nothing Then
                Throw New ArgumentNullException(NameOf(input), GoodExceptionMessages.ARGUMENT_NULL)
            End If
            
            If String.IsNullOrEmpty(input) Then
                Throw New ArgumentException(GoodExceptionMessages.ARGUMENT_EMPTY, NameOf(input))
            End If
            
            If Not IsAuthenticated() Then
                Throw New UnauthorizedAccessException(GoodExceptionMessages.AUTHENTICATION_REQUIRED)
            End If
        End Sub
        
        ' GOOD: Localized exception messages
        Public Class GoodLocalizedExceptions
            Private Shared ReadOnly messages As New Dictionary(Of String, String) From {
                {"INVALID_USER_ID", "User ID must be a positive integer."},
                {"EMPTY_USERNAME", "Username cannot be null or empty."},
                {"INVALID_EMAIL", "Email address format is invalid."},
                {"ACCESS_DENIED", "Access denied due to insufficient permissions."},
                {"AUTHENTICATION_FAILED", "User authentication failed."}
            }
            
            Public Shared Function GetMessage(key As String) As String
                Return If(messages.ContainsKey(key), messages(key), "An error occurred.")
            End Function
        End Class
        
        Sub GoodUsingLocalizedMessages()
            ' GOOD: Using localized message system
            If userId <= 0 Then
                Dim message As String = GoodLocalizedExceptions.GetMessage("INVALID_USER_ID")
                Throw New ArgumentException(message, NameOf(userId))
            End If
            
            If String.IsNullOrEmpty(userName) Then
                Dim message As String = GoodLocalizedExceptions.GetMessage("EMPTY_USERNAME")
                Throw New ArgumentException(message, NameOf(userName))
            End If
        End Sub
        
        ' Helper methods and properties
        Private userId As Integer = 1
        Private userName As String = "testuser"
        Private email As String = "test@example.com"
        Private password As String = "password"
        Private connectionString As String = "Server=localhost"
        Private timeout As Integer = 30
        Private retryCount As Integer = 3
        Private customerId As Integer = 1
        Private customerName As String = "John Doe"
        Private customerAge As Integer = 25
        Private input As String = "test"
        
        Sub ProcessData()
            ' Simulate processing that might throw exceptions
        End Sub
        
        Function IsValidFormat(input As String) As Boolean
            Return True
        End Function
        
        Function IsAuthenticated() As Boolean
            Return True
        End Function
        
        Function HasPermission(permission As String) As Boolean
            Return True
        End Function
        
        Function IsTokenExpired() As Boolean
            Return False
        End Function
        
        Function HasValidSubscription() As Boolean
            Return True
        End Function
        
        ' Supporting classes
        Class Order
            Public Property Items As New List(Of OrderItem)()
            Public Property Total As Decimal = 100
            Public Property CustomerId As Integer = 1
            Public Property IsValid As Boolean = True
        End Class
        
        Class OrderItem
            Public Property Id As Integer
            Public Property Name As String
            Public Property Price As Decimal
        End Class
    </script>
</body>
</html>
