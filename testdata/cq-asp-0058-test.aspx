<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing HTTPS Enforcement Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing HTTPS enforcement for sensitive operations
        
        Sub BadHTTPSEnforcement()
            ' BAD: Login operations over HTTP
            If Request.Url.Scheme = "http" Then ' Bad: allowing HTTP for login
                ProcessLogin() ' Bad: login over HTTP
            End If
            
            ' BAD: Password operations without HTTPS enforcement
            If Request.Form("password") <> "" Then ' Bad: password over HTTP
                ValidatePassword() ' Bad: password validation over HTTP
            End If
            
            ' BAD: Authentication without HTTPS check
            If Request.Url.Scheme = "http" Then ' Bad: allowing HTTP for auth
                AuthenticateUser() ' Bad: authentication over HTTP
            End If
        End Sub
        
        Sub BadCookieConfiguration()
            ' BAD: Insecure cookie settings
            Dim authCookie As New HttpCookie("AuthToken", "token123")
            authCookie.Secure = False ' Bad: cookie not secure
            Response.Cookies.Add(authCookie)
            
            Dim sessionCookie As New HttpCookie("SessionId", "session456")
            sessionCookie.HttpOnly = False ' Bad: cookie not HttpOnly
            Response.Cookies.Add(sessionCookie)
            
            ' BAD: Default cookie settings (insecure)
            Response.Cookies("UserPref").Value = "preference" ' Bad: default settings
            Response.Cookies("LoginStatus").Value = "authenticated" ' Bad: default settings
        End Sub
        
        Sub BadFormsAuthConfiguration()
            ' BAD: Forms authentication without SSL requirement
            ' In web.config: <forms authentication requireSSL="false" /> ' Bad: no SSL requirement
            ' In web.config: <forms cookieRequireSSL="false" /> ' Bad: cookie not requiring SSL
            
            ' Simulating configuration check
            If GetConfigValue("requireSSL") = "false" Then ' Bad: SSL not required
                ProcessFormsAuth() ' Bad: forms auth without SSL
            End If
            
            If GetConfigValue("cookieRequireSSL") = "false" Then ' Bad: cookie SSL not required
                SetAuthCookie() ' Bad: auth cookie without SSL requirement
            End If
        End Sub
        
        Sub BadMembershipConfiguration()
            ' BAD: Membership provider without SSL
            ' In web.config: <membership requireSSL="false" /> ' Bad: membership without SSL
            
            If GetMembershipConfig("requireSSL") = "false" Then ' Bad: membership SSL not required
                CreateUser() ' Bad: user creation without SSL
                ValidateUser() ' Bad: user validation without SSL
            End If
        End Sub
        
        Sub BadRedirectsAndLinks()
            ' BAD: Redirecting to HTTP for sensitive operations
            Response.Redirect("http://example.com/login.aspx") ' Bad: HTTP redirect for login
            Response.Redirect("http://example.com/account.aspx") ' Bad: HTTP redirect for account
            
            ' BAD: Links to HTTP for sensitive pages
            Dim loginLink = "<a href='http://example.com/login.aspx'>Login</a>" ' Bad: HTTP login link
            Dim accountLink = "<a href='http://example.com/account.aspx'>Account</a>" ' Bad: HTTP account link
            
            Response.Write(loginLink)
            Response.Write(accountLink)
        End Sub
        
        ' GOOD: Proper HTTPS enforcement
        
        Sub GoodHTTPSEnforcement()
            ' GOOD: Enforce HTTPS for sensitive operations
            If Request.Url.Scheme <> "https" Then
                Dim httpsUrl = Request.Url.ToString().Replace("http://", "https://")
                Response.Redirect(httpsUrl, True) ' Good: redirect to HTTPS
                Return
            End If
            
            ' Safe to process sensitive operations over HTTPS
            ProcessLogin() ' Good: login over HTTPS
            ValidatePassword() ' Good: password validation over HTTPS
            AuthenticateUser() ' Good: authentication over HTTPS
        End Sub
        
        Sub GoodSecureCookies()
            ' GOOD: Secure cookie configuration
            Dim authCookie As New HttpCookie("AuthToken", "token123")
            authCookie.Secure = True ' Good: cookie requires HTTPS
            authCookie.HttpOnly = True ' Good: cookie not accessible via JavaScript
            authCookie.SameSite = SameSiteMode.Strict ' Good: CSRF protection
            Response.Cookies.Add(authCookie)
            
            Dim sessionCookie As New HttpCookie("SessionId", "session456")
            sessionCookie.Secure = True ' Good: secure cookie
            sessionCookie.HttpOnly = True ' Good: HttpOnly cookie
            sessionCookie.SameSite = SameSiteMode.Lax ' Good: reasonable CSRF protection
            Response.Cookies.Add(sessionCookie)
        End Sub
        
        Sub GoodFormsAuthConfiguration()
            ' GOOD: Forms authentication with SSL requirement
            ' In web.config: <forms authentication requireSSL="true" /> ' Good: SSL required
            ' In web.config: <forms cookieRequireSSL="true" /> ' Good: cookie requires SSL
            
            ' Check SSL requirement
            If GetConfigValue("requireSSL") <> "true" Then
                Throw New ConfigurationException("SSL is required for forms authentication")
            End If
            
            If GetConfigValue("cookieRequireSSL") <> "true" Then
                Throw New ConfigurationException("SSL is required for authentication cookies")
            End If
            
            ' Safe to process with SSL requirements enforced
            ProcessFormsAuth() ' Good: forms auth with SSL
            SetAuthCookie() ' Good: auth cookie with SSL requirement
        End Sub
        
        Sub GoodMembershipConfiguration()
            ' GOOD: Membership provider with SSL
            ' In web.config: <membership requireSSL="true" /> ' Good: membership requires SSL
            
            If GetMembershipConfig("requireSSL") <> "true" Then
                Throw New ConfigurationException("SSL is required for membership operations")
            End If
            
            ' Safe to process with SSL requirement enforced
            CreateUser() ' Good: user creation with SSL
            ValidateUser() ' Good: user validation with SSL
        End Sub
        
        Sub GoodSecureRedirects()
            ' GOOD: Secure redirects and links
            Response.Redirect("https://example.com/login.aspx") ' Good: HTTPS redirect
            Response.Redirect("https://example.com/account.aspx") ' Good: HTTPS redirect
            
            ' GOOD: Secure links
            Dim loginLink = "<a href='https://example.com/login.aspx'>Login</a>" ' Good: HTTPS login link
            Dim accountLink = "<a href='https://example.com/account.aspx'>Account</a>" ' Good: HTTPS account link
            
            Response.Write(loginLink)
            Response.Write(accountLink)
        End Sub
        
        Sub GoodHTTPSRedirection()
            ' GOOD: Automatic HTTPS redirection
            If Not Request.IsSecureConnection Then
                Dim httpsUrl = "https://" + Request.Url.Host + Request.Url.PathAndQuery
                Response.Status = "301 Moved Permanently"
                Response.AddHeader("Location", httpsUrl)
                Response.End()
            End If
        End Sub
        
        Sub GoodSecurityHeaders()
            ' GOOD: Security headers for HTTPS enforcement
            Response.Headers.Add("Strict-Transport-Security", "max-age=31536000; includeSubDomains") ' Good: HSTS
            Response.Headers.Add("Content-Security-Policy", "upgrade-insecure-requests") ' Good: upgrade HTTP to HTTPS
            Response.Headers.Add("X-Content-Type-Options", "nosniff") ' Good: content type protection
            Response.Headers.Add("X-Frame-Options", "SAMEORIGIN") ' Good: clickjacking protection
        End Sub
        
        Sub GoodConditionalHTTPSCheck()
            ' GOOD: Check HTTPS for sensitive pages only
            Dim sensitivePages As String() = {"login.aspx", "account.aspx", "payment.aspx", "admin.aspx"}
            Dim currentPage = System.IO.Path.GetFileName(Request.Url.LocalPath).ToLower()
            
            If sensitivePages.Contains(currentPage) AndAlso Not Request.IsSecureConnection Then
                Dim httpsUrl = Request.Url.ToString().Replace("http://", "https://")
                Response.Redirect(httpsUrl, True) ' Good: HTTPS for sensitive pages
            End If
        End Sub
        
        Sub GoodApplicationLevelHTTPS()
            ' GOOD: Application-level HTTPS enforcement
            If ConfigurationManager.AppSettings("RequireHTTPS") = "true" Then
                If Not Request.IsSecureConnection Then
                    Dim httpsUrl = Request.Url.ToString().Replace("http://", "https://")
                    Response.Redirect(httpsUrl, True) ' Good: application-level HTTPS
                End If
            End If
        End Sub
        
        Sub GoodLoadBalancerHTTPS()
            ' GOOD: Handle HTTPS behind load balancer
            Dim forwardedProto = Request.Headers("X-Forwarded-Proto")
            Dim isSecure = Request.IsSecureConnection OrElse 
                          (Not String.IsNullOrEmpty(forwardedProto) AndAlso forwardedProto.ToLower() = "https")
            
            If Not isSecure Then
                Dim httpsUrl = "https://" + Request.Url.Host + Request.Url.PathAndQuery
                Response.Redirect(httpsUrl, True) ' Good: HTTPS with load balancer support
            End If
        End Sub
        
        Function GetConfigValue(key As String) As String
            ' Simulate configuration reading
            Return "false" ' For testing bad scenarios
        End Function
        
        Function GetMembershipConfig(key As String) As String
            ' Simulate membership configuration reading
            Return "false" ' For testing bad scenarios
        End Function
        
        ' Helper methods
        Sub ProcessLogin()
        End Sub
        
        Sub ValidatePassword()
        End Sub
        
        Sub AuthenticateUser()
        End Sub
        
        Sub ProcessFormsAuth()
        End Sub
        
        Sub SetAuthCookie()
        End Sub
        
        Sub CreateUser()
        End Sub
        
        Sub ValidateUser()
        End Sub
    </script>
</body>
</html>
