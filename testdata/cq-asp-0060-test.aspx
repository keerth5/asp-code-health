<%@ Page Language="VB" %>
<html>
<head>
    <title>Session Management Issues Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Session management issues - improper timeouts and insecure storage
        
        Sub BadSessionTimeout()
            ' BAD: Excessive session timeout
            Session.Timeout = 120 ' Bad: 2 hours is too long
            Session.Timeout = 480 ' Bad: 8 hours is excessive
            Session.Timeout = 1440 ' Bad: 24 hours is way too long
            Session.Timeout = 60 ' Bad: 1 hour may be too long for sensitive apps
            Session.Timeout = 90 ' Bad: 1.5 hours is excessive
        End Sub
        
        Sub BadSessionStorage()
            ' BAD: Storing sensitive data in session without encryption
            Session("userPassword") = Request.Form("password") ' Bad: password in session
            Session("creditCardNumber") = Request.Form("ccNumber") ' Bad: credit card in session
            Session("socialSecurityNumber") = Request.Form("ssn") ' Bad: SSN in session
            Session("apiKey") = GetApiKey() ' Bad: API key in session without encryption
            Session("authToken") = GenerateToken() ' Bad: token in session without encryption
            Session("bankAccountNumber") = Request.Form("accountNumber") ' Bad: account number in session
        End Sub
        
        Sub BadSessionAuthentication()
            ' BAD: Login without session regeneration
            If ValidateCredentials(username, password) Then
                Session("IsAuthenticated") = True ' Bad: no session regeneration
                Session("UserId") = userId ' Bad: no session regeneration
                RedirectToHome() ' Bad: no session ID regeneration after login
            End If
            
            ' BAD: Authentication without proper session management
            If AuthenticateUser(credentials) Then
                Session("LoggedIn") = True ' Bad: no session regeneration
                Session("UserRole") = userRole ' Bad: no session regeneration
            End If
        End Sub
        
        Sub BadSessionLogout()
            ' BAD: Incomplete session cleanup on logout
            Session("IsAuthenticated") = Nothing ' Bad: partial cleanup
            Session.Remove("UserId") ' Bad: manual removal instead of abandon
            ' Missing Session.Abandon() ' Bad: session not properly abandoned
            
            ' BAD: Logout without session regeneration
            Session.Clear() ' Bad: clear without abandon
            Response.Redirect("login.aspx") ' Bad: no proper session termination
        End Sub
        
        Sub BadSessionValidation()
            ' BAD: No session validation
            Dim userId = Session("UserId") ' Bad: no validation of session state
            ProcessUserData(userId) ' Bad: using unvalidated session data
            
            ' BAD: No session expiry check
            Dim lastActivity = Session("LastActivity") ' Bad: no expiry validation
            If lastActivity IsNot Nothing Then
                UpdateUserActivity() ' Bad: no time-based validation
            End If
        End Sub
        
        ' GOOD: Proper session management with security best practices
        
        Sub GoodSessionTimeout()
            ' GOOD: Appropriate session timeouts
            Session.Timeout = 20 ' Good: 20 minutes is reasonable
            Session.Timeout = 15 ' Good: 15 minutes for sensitive applications
            Session.Timeout = 30 ' Good: 30 minutes maximum for most applications
            Session.Timeout = 10 ' Good: 10 minutes for high-security applications
            Session.Timeout = 5 ' Good: 5 minutes for very sensitive operations
        End Sub
        
        Sub GoodSessionStorage()
            ' GOOD: Secure session storage with encryption
            Session("userIdEncrypted") = EncryptData(userId) ' Good: encrypted user ID
            Session("roleEncrypted") = EncryptData(userRole) ' Good: encrypted role
            
            ' GOOD: Store only necessary non-sensitive data
            Session("userName") = username ' Good: username is not sensitive
            Session("preferredLanguage") = language ' Good: preference data
            Session("lastLoginTime") = DateTime.Now ' Good: timestamp
            
            ' GOOD: Use secure session state provider
            ' In web.config: <sessionState cookieless="false" regenerateExpiredSessionId="true" 
            ' cookieTimeout="20" httpOnlyCookies="true" cookieSameSite="Strict" />
        End Sub
        
        Sub GoodSessionAuthentication()
            ' GOOD: Login with session regeneration
            If ValidateCredentials(username, password) Then
                ' Regenerate session ID to prevent session fixation
                Session.Abandon() ' Good: abandon old session
                Session.Regenerate() ' Good: regenerate session ID
                
                Session("IsAuthenticated") = True ' Good: after regeneration
                Session("UserId") = EncryptData(userId) ' Good: encrypted user ID
                Session("LoginTime") = DateTime.Now ' Good: login timestamp
                Session("LastActivity") = DateTime.Now ' Good: activity tracking
                
                RedirectToHome() ' Good: redirect after secure session setup
            End If
        End Sub
        
        Sub GoodSessionLogout()
            ' GOOD: Complete session cleanup on logout
            Session.Abandon() ' Good: properly abandon session
            Session.Clear() ' Good: clear session data
            
            ' GOOD: Clear authentication cookies
            If Request.Cookies("ASP.NET_SessionId") IsNot Nothing Then
                Dim sessionCookie As New HttpCookie("ASP.NET_SessionId", "")
                sessionCookie.Expires = DateTime.Now.AddDays(-1)
                Response.Cookies.Add(sessionCookie) ' Good: expire session cookie
            End If
            
            ' GOOD: Redirect to login page
            Response.Redirect("login.aspx", True) ' Good: secure redirect after logout
        End Sub
        
        Sub GoodSessionValidation()
            ' GOOD: Comprehensive session validation
            If Not ValidateSession() Then
                Session.Abandon()
                Response.Redirect("login.aspx")
                Return
            End If
            
            ' GOOD: Validate session expiry
            If IsSessionExpired() Then
                Session.Abandon()
                Response.Redirect("sessionexpired.aspx")
                Return
            End If
            
            ' GOOD: Update last activity
            Session("LastActivity") = DateTime.Now ' Good: track activity
            
            ' Safe to use validated session data
            Dim userId = DecryptData(Session("userIdEncrypted").ToString()) ' Good: decrypt session data
            ProcessUserData(userId) ' Good: using validated session data
        End Sub
        
        Function ValidateSession() As Boolean
            ' GOOD: Comprehensive session validation
            If Session Is Nothing OrElse Session("IsAuthenticated") IsNot True Then
                Return False
            End If
            
            ' Check if session has required fields
            If Session("UserId") Is Nothing OrElse Session("LoginTime") Is Nothing Then
                Return False
            End If
            
            ' Validate session age
            Dim loginTime As DateTime = CType(Session("LoginTime"), DateTime)
            If DateTime.Now.Subtract(loginTime).TotalHours > 8 Then ' Max 8 hours
                Return False
            End If
            
            Return True ' Good: comprehensive validation
        End Function
        
        Function IsSessionExpired() As Boolean
            ' GOOD: Check session expiry based on activity
            If Session("LastActivity") Is Nothing Then
                Return True
            End If
            
            Dim lastActivity As DateTime = CType(Session("LastActivity"), DateTime)
            Dim inactiveTime = DateTime.Now.Subtract(lastActivity)
            
            ' Session expires after 20 minutes of inactivity
            Return inactiveTime.TotalMinutes > 20 ' Good: activity-based expiry
        End Function
        
        Sub GoodSessionSecurity()
            ' GOOD: Additional session security measures
            ' Check for session hijacking
            If DetectSessionHijacking() Then
                LogSecurityEvent("Potential session hijacking detected")
                Session.Abandon()
                Response.Redirect("securityalert.aspx")
                Return
            End If
            
            ' GOOD: Validate session from same IP (optional, be careful with proxies)
            If IsIPValidationEnabled() AndAlso Not ValidateSessionIP() Then
                LogSecurityEvent("Session IP mismatch detected")
                Session.Abandon()
                Response.Redirect("login.aspx")
                Return
            End If
        End Sub
        
        Function DetectSessionHijacking() As Boolean
            ' GOOD: Simple session hijacking detection
            If Session("UserAgent") Is Nothing Then
                Session("UserAgent") = Request.UserAgent
                Return False
            End If
            
            ' Check if User-Agent changed
            If Session("UserAgent").ToString() <> Request.UserAgent Then
                Return True ' Potential hijacking
            End If
            
            Return False
        End Function
        
        Function ValidateSessionIP() As Boolean
            ' GOOD: IP validation for session security
            If Session("IPAddress") Is Nothing Then
                Session("IPAddress") = Request.UserHostAddress
                Return True
            End If
            
            Return Session("IPAddress").ToString() = Request.UserHostAddress
        End Function
        
        Function IsIPValidationEnabled() As Boolean
            ' Check if IP validation is enabled in configuration
            Return ConfigurationManager.AppSettings("ValidateSessionIP") = "true"
        End Function
        
        Sub GoodSessionConfiguration()
            ' GOOD: Secure session configuration (web.config settings)
            ' <sessionState 
            '   mode="InProc" 
            '   cookieless="false" 
            '   regenerateExpiredSessionId="true"
            '   timeout="20"
            '   httpOnlyCookies="true"
            '   cookieSameSite="Strict"
            '   cookieSecure="true" />
            
            ' GOOD: Custom session state provider for additional security
            ' <sessionState mode="Custom" customProvider="SecureSessionProvider" />
        End Sub
        
        Function EncryptData(data As String) As String
            ' GOOD: Encrypt sensitive session data
            ' Implementation would use proper encryption
            Return Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(data))
        End Function
        
        Function DecryptData(encryptedData As String) As String
            ' GOOD: Decrypt session data
            ' Implementation would use proper decryption
            Return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(encryptedData))
        End Function
        
        Sub LogSecurityEvent(message As String)
            ' GOOD: Log security events
            ' Implementation would log to secure location
        End Sub
        
        ' Helper methods and fields
        Private username As String = "testuser"
        Private password As String = "password123"
        Private userId As String = "user123"
        Private userRole As String = "User"
        Private language As String = "en-US"
        Private credentials As String = "credentials"
        
        Function ValidateCredentials(user As String, pass As String) As Boolean
            Return True
        End Function
        
        Function AuthenticateUser(creds As String) As Boolean
            Return True
        End Function
        
        Function GetApiKey() As String
            Return "api_key_123"
        End Function
        
        Function GenerateToken() As String
            Return "token_456"
        End Function
        
        Sub RedirectToHome()
            Response.Redirect("home.aspx")
        End Sub
        
        Sub ProcessUserData(userId As String)
        End Sub
        
        Sub UpdateUserActivity()
        End Sub
        
        ' Extension method simulation
        Module SessionExtensions
            <System.Runtime.CompilerServices.Extension()>
            Public Sub Regenerate(session As HttpSessionState)
                ' Implementation would regenerate session ID
                ' This is a simplified example
            End Sub
        End Module
    </script>
</body>
</html>
