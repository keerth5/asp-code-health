<%@ Page Language="VB" %>
<html>
<head>
    <title>Information Disclosure Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Information disclosure - exposing sensitive information
        
        Sub BadInformationDisclosure()
            Try
                ' Some operation that might fail
                ConnectToDatabase()
            Catch ex As Exception
                ' BAD: Exposing connection string in error message
                Response.Write("Database error: " + ex.Message + " ConnectionString: " + connectionString) ' Bad: exposes connection string
                Throw New Exception("Failed to connect with password: " + dbPassword) ' Bad: exposes password
                Response.Write("Error accessing key: " + apiKey) ' Bad: exposes API key
                
                ' BAD: Exposing tokens and secrets
                LogError("Authentication failed with token: " + authToken) ' Bad: exposes token
                Response.Write("Secret key validation failed: " + secretKey) ' Bad: exposes secret
            End Try
        End Sub
        
        Sub BadExceptionHandling()
            Try
                ProcessUserData()
            Catch ex As Exception
                ' BAD: Exposing full exception details to user
                Response.Write(ex.Message) ' Bad: may contain sensitive info
                Response.Write(ex.StackTrace) ' Bad: exposes system internals
                Response.Write(ex.ToString()) ' Bad: full exception details
                
                ' BAD: Debug information in production
                Debug.Write("User password: " + userPassword) ' Bad: password in debug output
                Trace.Write("Connection string: " + connectionString) ' Bad: connection string in trace
                Debug.Write("API key: " + apiKey) ' Bad: API key in debug
            End Try
        End Sub
        
        Sub BadLoggingPractices()
            ' BAD: Logging sensitive information
            Logger.Info("User login attempt with password: " + password) ' Bad: password in logs
            Logger.Debug("Database connection: " + connectionString) ' Bad: connection string in logs
            Logger.Error("Token validation failed: " + token) ' Bad: token in logs
            
            ' BAD: Trace output with sensitive data
            Trace.WriteLine("Processing payment with key: " + paymentKey) ' Bad: payment key in trace
            Debug.WriteLine("Secret configuration: " + secretConfig) ' Bad: secret in debug
        End Sub
        
        Sub BadErrorMessages()
            ' BAD: Detailed error messages revealing system information
            If Not ValidateUser(username) Then
                Throw New Exception("User not found in database table 'Users' at server 'SQLSERVER01'") ' Bad: reveals system details
            End If
            
            If Not AuthenticateUser(password) Then
                Response.Write("Authentication failed: Invalid password hash comparison") ' Bad: reveals auth mechanism
            End If
            
            If Not ConnectToAPI() Then
                Response.Write("API connection failed to endpoint: https://internal-api.company.com/auth") ' Bad: reveals internal endpoints
            End If
        End Sub
        
        ' GOOD: Proper information handling without disclosure
        
        Sub GoodExceptionHandling()
            Try
                ConnectToDatabase()
            Catch ex As Exception
                ' GOOD: Generic error message to user
                Response.Write("A database error occurred. Please try again later.") ' Good: generic message
                
                ' GOOD: Log detailed error securely (not to user)
                LogErrorSecurely(ex, "Database connection failed") ' Good: secure logging
                
                ' GOOD: Don't expose sensitive details
                Throw New Exception("Database connection failed") ' Good: no sensitive info
            End Try
        End Sub
        
        Sub GoodErrorHandling()
            Try
                ProcessUserData()
            Catch ex As Exception
                ' GOOD: User-friendly error messages
                Response.Write("An error occurred while processing your request") ' Good: generic message
                
                ' GOOD: Log full details securely (server-side only)
                LogToFile(ex.ToString()) ' Good: logged securely, not exposed to user
                LogToDatabase(ex.Message, ex.StackTrace) ' Good: secure database logging
                
                ' GOOD: Remove debug code in production
                ' Debug.Write statements should be removed or conditional
                If IsDebugMode() Then
                    Debug.Write("Debug info") ' Good: conditional debug output
                End If
            End Try
        End Sub
        
        Sub GoodLoggingPractices()
            ' GOOD: Secure logging without sensitive information
            Logger.Info("User login attempt for user: " + username) ' Good: no password
            Logger.Debug("Database connection attempt") ' Good: no connection string
            Logger.Error("Token validation failed for user: " + userId) ' Good: no actual token
            
            ' GOOD: Sanitized logging
            Logger.Info("Processing payment for user: " + SanitizeForLogging(userId)) ' Good: sanitized data
            Logger.Debug("Configuration loaded successfully") ' Good: no sensitive config details
        End Sub
        
        Sub GoodErrorMessages()
            ' GOOD: Generic error messages that don't reveal system details
            If Not ValidateUser(username) Then
                Throw New Exception("Invalid username or password") ' Good: generic message
            End If
            
            If Not AuthenticateUser(password) Then
                Response.Write("Authentication failed") ' Good: no technical details
            End If
            
            If Not ConnectToAPI() Then
                Response.Write("Service temporarily unavailable") ' Good: no internal details
            End If
        End Sub
        
        Sub GoodSecureErrorHandling()
            Try
                PerformSensitiveOperation()
            Catch ex As SecurityException
                ' GOOD: Log security events without exposing details
                LogSecurityEvent("Unauthorized access attempt", GetClientInfo()) ' Good: secure logging
                Response.StatusCode = 403
                Response.Write("Access denied") ' Good: minimal info
                
            Catch ex As Exception
                ' GOOD: Generic error handling
                LogError(ex) ' Good: internal logging only
                Response.StatusCode = 500
                Response.Write("Internal server error") ' Good: standard message
            End Try
        End Sub
        
        Sub GoodProductionConfiguration()
            ' GOOD: Disable detailed errors in production
            If Not IsProductionEnvironment() Then
                ' Detailed errors only in development
                Response.Write("Detailed error: " + ex.Message)
            Else
                ' Generic errors in production
                Response.Write("An error occurred")
            End If
            
            ' GOOD: Conditional debugging
            If ConfigurationManager.AppSettings("DebugMode") = "true" Then
                Debug.Write("Debug information")
            End If
        End Sub
        
        Sub GoodDataSanitization()
            ' GOOD: Sanitize data before logging or displaying
            Dim sanitizedEmail = SanitizeEmail(userEmail)
            Dim maskedCreditCard = MaskCreditCard(creditCardNumber)
            
            Logger.Info("User registered: " + sanitizedEmail) ' Good: sanitized data
            Response.Write("Payment processed for card: " + maskedCreditCard) ' Good: masked data
        End Sub
        
        Function SanitizeForLogging(input As String) As String
            ' Remove or mask sensitive information for logging
            Return Regex.Replace(input, "\d{4}-\d{4}-\d{4}-\d{4}", "****-****-****-****") ' Mask credit cards
        End Function
        
        Function SanitizeEmail(email As String) As String
            ' Mask email for logging
            If email.Contains("@") Then
                Dim parts = email.Split("@"c)
                Return parts(0).Substring(0, 2) + "***@" + parts(1)
            End If
            Return "***"
        End Function
        
        Function MaskCreditCard(cardNumber As String) As String
            ' Mask all but last 4 digits
            If cardNumber.Length > 4 Then
                Return New String("*"c, cardNumber.Length - 4) + cardNumber.Substring(cardNumber.Length - 4)
            End If
            Return "****"
        End Function
        
        Sub LogErrorSecurely(ex As Exception, message As String)
            ' Log to secure location, not exposed to users
        End Sub
        
        Sub LogToFile(message As String)
            ' Secure file logging
        End Sub
        
        Sub LogToDatabase(message As String, stackTrace As String)
            ' Secure database logging
        End Sub
        
        Sub LogSecurityEvent(eventType As String, details As String)
            ' Security event logging
        End Sub
        
        Sub LogError(ex As Exception)
            ' Internal error logging
        End Sub
        
        Function IsDebugMode() As Boolean
            Return False ' Production should return false
        End Function
        
        Function IsProductionEnvironment() As Boolean
            Return True ' Check actual environment
        End Function
        
        Function GetClientInfo() As String
            Return Request.UserHostAddress + " " + Request.UserAgent
        End Function
        
        ' Helper methods and fields
        Private connectionString As String = "Server=db;Database=app;Trusted_Connection=true"
        Private dbPassword As String = "secret123"
        Private apiKey As String = "key_12345"
        Private authToken As String = "token_abcde"
        Private secretKey As String = "secret_key"
        Private userPassword As String = "user_pass"
        Private password As String = "password123"
        Private token As String = "auth_token"
        Private paymentKey As String = "payment_key"
        Private secretConfig As String = "secret_config"
        Private username As String = "testuser"
        Private userId As String = "user123"
        Private userEmail As String = "user@example.com"
        Private creditCardNumber As String = "1234567890123456"
        Private ex As Exception = New Exception("Sample exception")
        
        Sub ConnectToDatabase()
        End Sub
        
        Sub ProcessUserData()
        End Sub
        
        Function ValidateUser(username As String) As Boolean
            Return True
        End Function
        
        Function AuthenticateUser(password As String) As Boolean
            Return True
        End Function
        
        Function ConnectToAPI() As Boolean
            Return True
        End Function
        
        Sub PerformSensitiveOperation()
        End Sub
        
        ' Mock logger
        Public Class Logger
            Public Shared Sub Info(message As String)
            End Sub
            
            Public Shared Sub Debug(message As String)
            End Sub
            
            Public Shared Sub [Error](message As String)
            End Sub
        End Class
    </script>
</body>
</html>
